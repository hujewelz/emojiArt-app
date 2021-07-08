//
//  iOS.swift
//  EmojiArt (macOS)
//
//  Created by huluobo on 2021/7/8.
//

import SwiftUI

extension View {
    func plainButtonOnMacOnly() -> some View {
        self
    }
    
    @ViewBuilder
    func wrappedWithNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self
                    .navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    @ViewBuilder
    func dismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            self.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        } else {
            self
        }
    }
}

extension UIImage {
    var imageData: Data? { jpegData(compressionQuality: 1.0) }
}

struct Pasteboard {
    static var imageData: Data? {
        UIPasteboard.general.image?.imageData
    }
    
    static var imageURL: URL? {
        UIPasteboard.general.url?.imageURL
    }
}
