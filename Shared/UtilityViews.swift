//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct AnimatedActionButton: View {
    var title: String?
    var systemImage: String?
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }

    }
}

struct IdentifiableAlert: Identifiable {
    let id: String
    let alert: Alert
}
