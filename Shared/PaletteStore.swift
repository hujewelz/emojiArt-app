//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/2.
//

import SwiftUI

struct Palette: Identifiable, Codable, Hashable {
    let id: Int
    var name: String
    var emojis: String
}

class PaletteStore: ObservableObject {
    let name: String
    
    @Published var palettes: [Palette] = [] {
        didSet { storeInUserDefaults() }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if palettes.isEmpty {
            insertPallete(named: "Favorites", emojis: "๐น๐คก๐ธ๐โ ๏ธ๐ฝ๐ค๐๐ป๐๐ผ๐พ๐ฟ๐ซ๐ง ๐ง๐ผโโ๏ธ๐คฏ๐ถโ๐ซ๏ธ๐ฅถ๐๐๐โ๏ธ")
            insertPallete(named: "Animals", emojis: "๐ถ๐ฑ๐ญ๐น๐ฐ๐ฆ๐ป๐ผ๐ปโโ๏ธ๐จ๐ฏ๐ฆ๐ฎ๐ท๐ฝ๐ธ๐ต๐๐๐๐๐๐ง๐ฆ๐ฆ๐๐ฆ๐ด๐ฆ")
            insertPallete(named: "Faces", emojis: "๐๐๐๐๐๐๐ฅฒ๐คฃ๐๐๐ฅฐ๐๐๐๐๐๐๐๐คช๐คจ๐ฅธ๐๐ค๐ง๐คฉ๐ฅณ๐๐")
            insertPallete(named: "Nature", emojis: "๐๐๐๐๐๐๐๐๐๐๐ชโญ๏ธโ๏ธ๐ฅ๐ฅ๐๐๐ช")
            insertPallete(named: "Weather", emojis: "โ๏ธ๐คโ๏ธ๐ฅโ๏ธ๐ฆ๐งโ๐ฉ๐จโ๏ธโ๏ธโ๏ธ๐ฌ๐จ๐ง๐ฆโ๏ธโ๏ธ๐๐ซ")
            insertPallete(named: "Foods", emojis: "๐๐๐๐๐๐๐๐๐๐ซ๐๐๐๐ฅญ๐๐ฅฅ๐ฅ๐๐ฅ๐ง")
            insertPallete(named: "Activities", emojis: "โฝ๏ธ๐๐โพ๏ธ๐ฅ๐พ๐๐๐ฑ๐ช๐๐๐๐ช๐น๐ฅ๐ฅ๐คฟโธ๐๐ฅ๐๐ป๐๐ปโโ๏ธ")
        }
    }
    
    // MARK: - Intent
    
    func pallete(at index: Int) -> Palette {
        let safeIndex = min(max(index, 0), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePallete(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPallete(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max { $0.id < $1.id }?.id ?? 0) + 1
        let pallete = Palette(id: unique, name: name, emojis: emojis?.removingDuplicateCharacters ?? "")
        let safeIndex = min(max(index, 0), palettes.count)
        palettes.insert(pallete, at: safeIndex)
    }
    
    // MARK: - Private
    
    private var userDefaultsKey: String {
        "PalletStore." + name
    }
    
    private func storeInUserDefaults() {
        if let data = try? palettes.json() {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func restoreFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey)
           , let storedPallettes = try? Array<Palette>(json: data) {
            palettes = storedPallettes
        }
    }
}
