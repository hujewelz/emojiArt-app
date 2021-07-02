//
//  EmojiDocument.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI

final class EmojiArtDocument: ObservableObject {
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus: BackgroundImageFetchStatus = .idle
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet { autosave() }
    }
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    init() {
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageIfNeeded()
        } else {
            emojiArt = EmojiArtModel()
        }
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
        fetchBackgroundImageIfNeeded()
    }
    
    func addEmoji(_ emoji: String, at location: Location, size: Int) {
        emojiArt.addEmoji(text: emoji, at: location, size: size)
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
    
    // MARK: - Private
    
    private func fetchBackgroundImageIfNeeded() {
        backgroundImage = nil
        switch emojiArt.background {
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                            self?.backgroundImageFetchStatus = .idle
                            self?.backgroundImage = UIImage(data: data)
                        }
                    }
                }
            }
        case .blank:
            break
        }
    }
    
    private var autosaveTimer: Timer?
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false, block: { _ in
            self.autosave()
        })
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch {
            print("Save emojoArt with error: ", error)
        }
    }
}

extension EmojiArtDocument {
    struct Autosave {
        static let filename = "Autosave.emojiart"
        static var url: URL? {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return directory?.appendingPathComponent(filename)
        }
        static let coalescingInterval = 5.0
    }
}
