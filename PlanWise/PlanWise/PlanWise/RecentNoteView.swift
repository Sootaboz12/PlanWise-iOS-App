//
//  RecentNoteView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI
import SwiftData

struct RecentNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [NoteItem]
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showPhotoLibrary = false
    @State private var isDeleting = false
    @State private var deleteOffset: CGFloat = 0
    @State private var deleteOpacity: Double = 1.0
    
    var recentNote: NoteItem? {
        notes.first(where: { $0.id == userManager.mostRecentNoteId })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if let note = recentNote {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Note header with image
                            ZStack(alignment: .bottomLeading) {
                                if let imageURL = note.imageURL {
                                    if ImageStorageManager.shared.isLocalPath(imageURL) {
                                        // Local image from photo library
                                        if let uiImage = ImageStorageManager.shared.loadImage(from: imageURL) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 200)
                                                .clipped()
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 200)
                                        }
                                    } else {
                                        // Remote image from Pixabay
                                        AsyncImage(url: URL(string: imageURL)) { phase in
                                            buildImageContent(phase: phase)
                                        }
                                    }
                                } else {
                                    // Fallback to Lorem Picsum
                                    AsyncImage(url: URL(string: "https://picsum.photos/seed/\(note.id.uuidString)/600/300")) { phase in
                                        buildImageContent(phase: phase)
                                    }
                                }
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .frame(height: 200)
                                
                                VStack(alignment: .leading) {
                                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                
                                // Change image button (bottom right)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showPhotoLibrary = true
                                        }) {
                                            Image(systemName: "photo.badge.plus")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(Color.black.opacity(0.5))
                                                .clipShape(Circle())
                                        }
                                        .padding(12)
                                    }
                                }
                                .frame(height: 200)
                            }
                            .cornerRadius(15)
                            
                            // Note content editor
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Content")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextEditor(text: Binding(
                                    get: { note.content },
                                    set: { note.content = $0 }
                                ))
                                    .frame(minHeight: 300)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding()
                    }
                    .offset(x: deleteOffset)
                    .opacity(deleteOpacity)
                    .navigationTitle(note.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Color.appBackground, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showDeleteAlert = true }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .alert("Delete Note", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            deleteNote(note)
                        }
                    } message: {
                        Text("Are you sure you want to delete this note?")
                    }
                    .sheet(isPresented: $showPhotoLibrary) {
                        if let note = recentNote {
                            PhotoLibraryPicker { image in
                                updateNoteImage(note, image)
                            }
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.badge.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No recent note")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.headline)
                        
                        Text("Open a note to see it here")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.subheadline)
                    }
                    .navigationTitle("Recent Note")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Color.appBackground, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildImageContent(phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
            
        case .success(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
        case .failure:
            Rectangle()
                .fill(Color.red.opacity(0.3))
                .frame(height: 200)
            
        @unknown default:
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
        }
    }
    
    @ViewBuilder
    private func buildImageView(phase: AsyncImagePhase, note: NoteItem) -> some View {
        switch phase {
        case .empty:
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .cornerRadius(15)
            
        case .success(let image):
            ZStack(alignment: .bottomLeading) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .cornerRadius(15)
            
        case .failure:
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.red.opacity(0.3))
                    .frame(height: 200)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .cornerRadius(15)
            
        @unknown default:
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)
                
                VStack(alignment: .leading) {
                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .cornerRadius(15)
        }
    }
    
    func deleteNote(_ note: NoteItem) {
        // Delete associated image if it's local
        if let imagePath = note.imageURL, ImageStorageManager.shared.isLocalPath(imagePath) {
            ImageStorageManager.shared.deleteImage(at: imagePath)
        }
        
        isDeleting = true
        
        // Animate the deletion
        withAnimation(.easeIn(duration: 0.3)) {
            deleteOffset = -UIScreen.main.bounds.width
            deleteOpacity = 0.0
        }
        
        // Wait for animation to complete before deleting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            modelContext.delete(note)
            try? modelContext.save()
            userManager.mostRecentNoteId = nil
            UserDefaults.standard.removeObject(forKey: "mostRecentNoteId")
        }
    }
    
    private func updateNoteImage(_ note: NoteItem, _ image: UIImage) {
        // Delete old local image if it exists
        if let oldPath = note.imageURL, ImageStorageManager.shared.isLocalPath(oldPath) {
            ImageStorageManager.shared.deleteImage(at: oldPath)
        }
        
        // Save new image
        if let newPath = ImageStorageManager.shared.saveImage(image, withId: note.id) {
            note.imageURL = newPath
        }
    }
}
