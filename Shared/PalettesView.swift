//
//  PalettesView.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/2.
//

import SwiftUI

struct PalettesView: View {
    @EnvironmentObject var store: PaletteStore
    @SceneStorage("PalettesView.CurrentChoosenPaletteIndex")
    private var current: Int = 0
    
    private var emojiFontSize: CGFloat = 40
    private var emojiFont: Font { .system(size: emojiFontSize) }
    
    var body: some View {
        if store.palettes.isEmpty {
            EmptyView()
        } else {
            HStack(spacing: 10) {
                paletteControlButton
                body(for: store.pallete(at: current))
            }
            .clipped()
            .padding()
        }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            paletteToEdit = store.palettes[current]
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPallete(named: "New", emojis: "", at: current)
            paletteToEdit = store.palettes[current]
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            current = store.removePallete(at: current)
        }
        AnimatedActionButton(title: "Manage", systemImage: "slider.vertical.3") {
            managing = true
        }
        gotoMenu
    }
    
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        current = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
        
    }
    
    private var paletteControlButton: some View {
        Button {
            withAnimation {
                current = (current +  1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .contextMenu { contextMenu }
    }
    
    @State private var managing = false
    @State private var paletteToEdit: Palette?
    
    private func body(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
                .font(.title3)
            ScrollingEmojisView(emoji: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id) // transition 对移除和添加的视图有效
        .transition(rollTransition)
//        .popover(isPresented: $editing) {
//            PaletteEditor(palette: $store.palettes[current])
//        }
        .popover(item: $paletteToEdit) { palette in
            PaletteEditor(palette: $store.palettes[palette])
        }
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
    
    private var rollTransition:  AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize)
        )
    }
}

struct ScrollingEmojisView: View {
    let emoji: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(emoji.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct PalettesView_Previews: PreviewProvider {
    static var previews: some View {
        PalettesView()
    }
}
