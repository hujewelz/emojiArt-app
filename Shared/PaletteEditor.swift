//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/2.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojisSection
        }
        .frame(minWidth: 600, minHeight: 650)
        .navigationTitle(palette.name)
    }
    
    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    private var addEmojisSection: some View {
        Section(header: Text("Add emojis")) {
            TextField("Add Emojis", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    private var removeEmojisSection: some View {
        Section(header: Text("Remove emojis")) {
            let emojies = palette.emojis.map(String.init)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojies, id: \.self) { emoji in
                    Text(emoji)
                        .font(.title)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll { String($0) == emoji }
                            }
                        }
                }
                .padding(.vertical, 4)
            }
            .padding(.vertical)
        }
    }
}

//struct PaletteEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteEditor()
//    }
//}
