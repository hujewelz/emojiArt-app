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
