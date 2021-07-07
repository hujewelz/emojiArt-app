//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by huluobo on 2021/7/1.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct AnimatedActionButton: View {
    var title: String?
    var systemImage: String?
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }

    }
}

struct IdentifiableAlert: Identifiable {
    let id: String
    let alert: Alert
}

struct UndoButton: View {
    let undo: String?
    let redo: String?
    
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        let canUndo = undoManager?.canUndo ?? false
        let canRedo = undoManager?.canRedo ?? false
        if canUndo || canRedo {
            Button {
                if canUndo {
                    undoManager?.undo()
                } else {
                    undoManager?.redo()
                }
            } label: {
                if canUndo {
                    Image(systemName: "arrow.uturn.backward.circle")
                } else {
                    Image(systemName: "arrow.uturn.forward.circle")
                }
            }
            .contextMenu {
                if canUndo {
                    Button {
                        undoManager?.undo()
                    } label: {
                        Label(undo ?? "Undo", systemImage: "arrow.uturn.backward")
                    }
                }
                if canRedo {
                    Button {
                        undoManager?.redo()
                    } label: {
                        Label(redo ?? "Redo", systemImage: "arrow.uturn.forward")
                    }
                }
            }
        }
    }
}

extension UndoManager {
    var optionalUndoMenuItemTitle: String? {
        canUndo ? undoMenuItemTitle : nil
    }
    
    var optionalredoMenuItemTitle: String? {
        canRedo ? redoMenuItemTitle : nil
    }
}
