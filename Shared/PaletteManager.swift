//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/6.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(
                        destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                    }
                }
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    store.palettes.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable({
                presentationMode.wrappedValue.dismiss()
            })
            .toolbar {
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager().environmentObject(PaletteStore(named: "preview"))
    }
}
