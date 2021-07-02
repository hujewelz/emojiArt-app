//
//  EmojiArtApp.swift
//  Shared
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
