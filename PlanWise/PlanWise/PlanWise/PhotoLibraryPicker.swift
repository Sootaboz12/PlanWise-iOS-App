//
//  PhotoLibraryPicker.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//

import SwiftUI
import UIKit
import PhotosUI

// MARK: - UIImagePickerController Wrapper
struct PhotoLibraryPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let onImageSelected: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
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
        let parent: PhotoLibraryPicker
        
        init(_ parent: PhotoLibraryPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageSelected(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Image Storage Helper
class ImageStorageManager {
    static let shared = ImageStorageManager()
    
    private init() {}
    
    /// Save image to documents directory and return the file path
    func saveImage(_ image: UIImage, withId id: UUID) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileName = "\(id.uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            // Return the full file URL path
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    /// Load image from local file path
    func loadImage(from path: String) -> UIImage? {
        // Handle both full paths and just filenames
        var fullPath = path
        
        // If path doesn't start with /, it might be just a filename
        if !path.hasPrefix("/") {
            let fileManager = FileManager.default
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                fullPath = documentsDirectory.appendingPathComponent(path).path
            }
        }
        
        let image = UIImage(contentsOfFile: fullPath)
        
        if image == nil {
            print("Failed to load image from path: \(fullPath)")
        }
        
        return image
    }
    
    /// Delete image from documents directory
    func deleteImage(at path: String) {
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: path)
    }
    
    /// Check if a path is a local file path (not a URL)
    func isLocalPath(_ path: String) -> Bool {
        return path.hasPrefix("/") && !path.hasPrefix("http")
    }
}
