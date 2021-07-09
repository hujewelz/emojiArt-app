//
//  EmojiView.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/9.
//

import SwiftUI

struct EmojiView: View {
    var emoji: EmojiArtModel.Emoji
//    @Binding var selected: EmojiArtModel.Emoji?
    
    var changeOffset: (CGSize) -> Void
//    var changeScale: (CGFloat) -> Void
    
//    var isSelected: Bool { selected == emoji }
    
    var body: some View {
        Text(emoji.text)
            .font(.system(size: fontSize(for: emoji)))
//            .padding(isSelected ? 8 : 0)
//            .background(isSelected ? Color.red : Color.clear)
//            .highPriorityGesture(tapGesture)
            .gesture(panGesture)
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                changeOffset(value.translation)
            }
    }
    
    @State private var steadyZoomScale: CGFloat = 1
    @State private var gestureZoomScale: CGFloat = 1.0

//    private var scaleGesture: some Gesture {
//        MagnificationGesture()
//            .onChanged { scale in
//                gestureZoomScale = scale / steadyZoomScale
//                steadyZoomScale = scale
//                changeScale(gestureZoomScale)
//            }
//            .onEnded { scale in
//                steadyZoomScale = 1.0
//            }
//    }
    
//    private var tapGesture: some Gesture {
//        TapGesture(count: 1).onEnded { _ in
//            selected = emoji
//        }
//    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
}
