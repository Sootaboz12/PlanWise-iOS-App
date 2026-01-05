//
//  ImagePickerView.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//

import SwiftUI

struct ImagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let images: [PixabayImage]
    let onImageSelected: (String) -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(images) { image in
                            Button(action: {
                                onImageSelected(image.webformatURL)
                                dismiss()
                            }) {
                                AsyncImage(url: URL(string: image.previewURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 150)
                                            .overlay(
                                                ProgressView()
                                                    .tint(.white)
                                            )
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 150)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.red.opacity(0.3))
                                            .frame(height: 150)
                                            .cornerRadius(10)
                                            .overlay(
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(.white)
                                            )
                                    @unknown default:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 150)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
