//
//  EmojiArtApp.swift
//  Shared
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI

@main
struct EmojiArtApp: App { 
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    
    }
}
