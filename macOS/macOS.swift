//
//  macOS.swift
//  EmojiArt (macOS)
//
//  Created by huluobo on 2021/7/8.
//

import SwiftUI

typealias UIImage = NSImage

typealias PaletteManager = EmptyView

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}

extension View {
    func wrappedWithNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        self
    }
    
    func plainButtonOnMacOnly() -> some View {
        self.buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
    }
}


extension UIImage {
    var imageData: Data? { tiffRepresentation }
}

struct Pasteboard {
    static var imageData: Data? {
        NSPasteboard.general.data(forType: .tiff) ?? NSPasteboard.general.data(forType: .png)
    }
    
    static var imageURL: URL? {
        (( NSURL(from: NSPasteboard.general)) as URL?)?.imageURL
    }
}

struct NoImagePicker: View {
    static var isCameraAvailable = false
    static var isLibraryAvailable = false
    
    let pickerType: PickerType
    let handlePickedImage: (UIImage?) -> Void
    
    enum PickerType {
        case camera
        case photoLibrary
    }
    
    var body: some View { EmptyView() }
}

typealias ImagePicker = NoImagePicker
