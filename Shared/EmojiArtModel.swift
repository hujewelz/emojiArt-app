//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import Foundation

typealias Location = (x: Int, y: Int)

struct EmojiArtModel {
    var background: Background = .blank
    var emojis: [Emoji] = []
    
    struct Emoji: Identifiable, Hashable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.id = id
            self.text = text
            self.x = x  // offset from the center
            self.y = y  // offset from the center
            self.size = size
        }
    }
    
    init() { }
    
    private var uniqueEmojiId: Int = 0
    
    mutating func addEmoji(text: String, at location: Location, size: Int) {
        uniqueEmojiId += 1
        let emoji = Emoji(id: uniqueEmojiId, text: text, x: location.x, y: location.y, size: size)
        emojis.append(emoji)
    }
}


extension EmojiArtModel {
    enum Background: Equatable {
        case blank
        case url(URL)
        case imageData(Data)
        
        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }
        
        var data: Data? {
            switch self {
            case .imageData(let data): return data
            default: return nil
            }
        }
    }
}
