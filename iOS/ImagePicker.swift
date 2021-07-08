//
//  ImagePicker.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/8.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
   
    static var isCameraAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }
    static var isLibraryAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.photoLibrary) }
    
    let pickerType: PickerType
    let handlePickedImage: (UIImage?) -> Void
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = pickerType.sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: (UIImage?) -> Void
        
        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            handlePickedImage(image)
        }
    }

    enum PickerType {
        case camera
        case photoLibrary
        
        var sourceType: UIImagePickerController.SourceType {
            switch self {
            case .camera:
                return .camera
            case .photoLibrary:
                return .photoLibrary
            }
        }
    }
}
