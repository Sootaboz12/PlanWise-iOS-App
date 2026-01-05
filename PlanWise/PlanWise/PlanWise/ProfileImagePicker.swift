//
//  ProfileImagePicker.swift
//  PlanWise
//
//  Created by user278444 on 11/27/25.
//


//
//  ProfileImagePicker.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//

import SwiftUI
import UIKit
import PhotosUI

// MARK: - Profile Image Picker with Crop
struct ProfileImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let onImageSelected: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // Enable cropping
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ProfileImagePicker
        
        init(_ parent: ProfileImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Use edited image if available (cropped), otherwise use original
            if let editedImage = info[.editedImage] as? UIImage {
                parent.onImageSelected(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.onImageSelected(originalImage)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Profile Image Storage Manager
class ProfileImageStorageManager {
    static let shared = ProfileImageStorageManager()
    
    private let profileImageKey = "profileImagePath"
    
    private init() {}
    
    /// Save profile image to documents directory
    func saveProfileImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileName = "profile_image.jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            let path = fileURL.path
            
            // Save path to UserDefaults
            UserDefaults.standard.set(path, forKey: profileImageKey)
            
            return path
        } catch {
            print("Error saving profile image: \(error)")
            return nil
        }
    }
    
    /// Load profile image from storage
    func loadProfileImage() -> UIImage? {
        guard let path = UserDefaults.standard.string(forKey: profileImageKey) else {
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    /// Delete profile image
    func deleteProfileImage() {
        guard let path = UserDefaults.standard.string(forKey: profileImageKey) else {
            return
        }
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: path)
        
        UserDefaults.standard.removeObject(forKey: profileImageKey)
    }
}