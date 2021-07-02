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
            insertPallete(named: "Favorites", emojis: "👹🤡😸💀☠️👽🤖👇🏻🖕🏼😾😿🫀🧠🧖🏼‍♂️🤯😶‍🌫️🥶🌝🌕🌞☄️")
            insertPallete(named: "Animals", emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🐔🐧🐦🦆🐝🦉🐴🦄")
            insertPallete(named: "Faces", emojis: "😀😃😄😂😅😆🥲🤣😇😌🥰😍😘😗😛😙😝😜🤪🤨🥸😎🤓🧐🤩🥳😏😒")
            insertPallete(named: "Nature", emojis: "🌞🌝🌛🌚🌕🌖🌗🌘🌔🌓🪐⭐️☄️💥🔥🌟🌈🌪")
            insertPallete(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️☃️⛄️🌬💨💧💦☔️☂️🌊🌫")
            insertPallete(named: "Foods", emojis: "🍏🍎🍐🍊🍋🍌🍉🍇🍓🫐🍈🍒🍑🥭🍍🥥🥝🍅🥑🧅")
            insertPallete(named: "Activities", emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🎱🪀🏓🏒🏑🪃🏹🥊🥋🤿⛸🏂🥌🏄🏻🏄🏻‍♂️")
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
