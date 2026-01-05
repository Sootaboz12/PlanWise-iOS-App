//
//  NoteCardView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI

struct NoteCardView: View {
    let note: NoteItem
    @State private var showPhotoLibrary = false
    @State private var localImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image - use Pixabay image if available, otherwise fallback to Lorem Picsum
            if let imageURL = note.imageURL {
                if ImageStorageManager.shared.isLocalPath(imageURL) {
                    // Local image from photo library
                    if let uiImage = localImage ?? ImageStorageManager.shared.loadImage(from: imageURL) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .onAppear {
                                localImage = uiImage
                            }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .overlay(
                                Text("Image not found")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.caption)
                            )
                    }
                } else {
                    // Remote image from Pixabay
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 200)
                    .clipped()
                }
            } else {
                // Fallback to Lorem Picsum for notes created before Pixabay integration
                AsyncImage(url: URL(string: "https://picsum.photos/seed/\(note.id.uuidString)/400/200")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 200)
                .clipped()
            }
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 200)
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
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
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showPhotoLibrary) {
            PhotoLibraryPicker { image in
                updateNoteImage(image)
            }
        }
    }
    
    private func updateNoteImage(_ image: UIImage) {
        // Delete old local image if it exists
        if let oldPath = note.imageURL, ImageStorageManager.shared.isLocalPath(oldPath) {
            ImageStorageManager.shared.deleteImage(at: oldPath)
        }
        
        // Save new image
        if let newPath = ImageStorageManager.shared.saveImage(image, withId: note.id) {
            note.imageURL = newPath
            localImage = image // Update the local image immediately
        }
    }
}
