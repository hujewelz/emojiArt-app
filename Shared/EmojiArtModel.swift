//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import Foundation

typealias Location = (x: Int, y: Int)

struct EmojiArtModel: Codable {
    var background: Background = .blank
    var emojis: [Emoji] = []
    
    struct Emoji: Codable, Identifiable, Hashable {
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
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(json: data)
    }
    
    private var uniqueEmojiId: Int = 0
    
    mutating func addEmoji(text: String, at location: Location, size: Int) {
        uniqueEmojiId += 1
        let emoji = Emoji(id: uniqueEmojiId, text: text, x: location.x, y: location.y, size: size)
        emojis.append(emoji)
    }
}


extension EmojiArtModel {
    enum Background: Codable, Equatable {
        case blank
        case url(URL)
        case imageData(Data)
        
        enum CodingKeys: String, CodingKey {
            case url
            case imageData
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let url = try? container.decode(URL.self, forKey: .url) {
                self = .url(url)
            } else if let data = try? container.decode(Data.self, forKey: .imageData) {
                self = .imageData(data)
            } else {
                self = .blank
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .imageData(let data):
                try container.encode(data, forKey: .imageData)
            case .url(let url):
                try container.encode(url, forKey: .url)
            case .blank:
                break
            }
        }
        
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
