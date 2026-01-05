//
//  ProfileView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [NoteItem]
    @EnvironmentObject var userManager: UserManager
    @State private var showProfileImagePicker = false
    @State private var profileImage: UIImage?
    @State private var imageScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Image with tap to change
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.appPurple, lineWidth: 3)
                                    )
                                    .scaleEffect(imageScale)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.appPurple)
                                    .scaleEffect(imageScale)
                            }
                            
                            // Edit button
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    imageScale = 0.9
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        imageScale = 1.0
                                    }
                                }
                                
                                showProfileImagePicker = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.appPurple)
                                    .clipShape(Circle())
                            }
                            .offset(x: 5, y: 5)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 15) {
                            ProfileRow(label: "Name", value: userManager.userName)
                            ProfileRow(label: "Date of Birth", value: userManager.dateOfBirth.formatted(date: .long, time: .omitted))
                            ProfileRow(label: "Total Notes", value: "\(notes.count)")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .navigationTitle("Profile")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.appBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .sheet(isPresented: $showProfileImagePicker) {
                    ProfileImagePicker { image in
                        updateProfileImage(image)
                    }
                }
                .onAppear {
                    loadProfileImage()
                }
            }
        }
    }
    
    private func loadProfileImage() {
        profileImage = ProfileImageStorageManager.shared.loadProfileImage()
    }
    
    private func updateProfileImage(_ image: UIImage) {
        _ = ProfileImageStorageManager.shared.saveProfileImage(image)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            profileImage = image
        }
    }
}

// MARK: - Profile Row Component
struct ProfileRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.7))
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}
