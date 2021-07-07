//
//  EmojiDocument.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static let emojiart = UTType(exportedAs: "me.jewelz.EmojiArt.emojiart")
}

final class EmojiArtDocument: ReferenceFileDocument {
    static var readableContentTypes: [UTType] { [.emojiart] }
    static var writableContentTypes: [UTType] { [.emojiart] }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImageIfNeeded()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
        
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus: BackgroundImageFetchStatus = .idle
    
    @Published private(set) var emojiArt: EmojiArtModel
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    init() {
        emojiArt = EmojiArtModel()
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set backgoundImage", whit: undoManager) {
            emojiArt.background = background
            fetchBackgroundImageIfNeeded()
        }
    }
    
    func addEmoji(_ emoji: String, at location: Location, size: Int, undoManager: UndoManager?) {
        undoablyPerform(operation: "Add Emoji: \(emoji)", whit: undoManager) {
            emojiArt.addEmoji(text: emoji, at: location, size: size)
        }
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", whit: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", whit: undoManager) {
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
    // MARK: - Private
    
    private var imageFetchCanclanble: AnyCancellable?
    
    private func fetchBackgroundImageIfNeeded() {
        backgroundImage = nil
        switch emojiArt.background {
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            imageFetchCanclanble?.cancel()
        
            imageFetchCanclanble = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
                }
        case .blank:
            break
        }
    }
    
    private func undoablyPerform(operation: String, whit undoManager: UndoManager?, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, whit: undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }
}
