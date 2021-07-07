# EmojiArt App 🎨

```swift
GeometryReader { geometry in
    ZStack {
        Color.white.overlay(
            OptionalImage(uiImage: document.backgroundImage)
                .scaleEffect(zoomScale)
                .position(convertFromEmojiCoordinates((0, 0), in: geometry))
        )
        .gesture(doubleTapToZoom(in: geometry.size))
        
        if document.backgroundImageFetchStatus == .fetching {
            ProgressView().scaleEffect(2)
        } else {
            ForEach(document.emojis) { emoji in
                Text(emoji.text)
                    .font(.system(size: fontSize(for: emoji)))
                    .scaleEffect(zoomScale)
                    .position(position(for: emoji, in: geometry))
            }
        }
        
    }
    .clipped()
    .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
        drop(providers: providers, at: location, in: geometry)
    }
    .gesture(panGesture.simultaneously(with: zoomGesture()))
    .alert(item: $identifiableAlert) { identifiableAlert in
        identifiableAlert.alert
    }
    .onChange(of: document.backgroundImageFetchStatus) { status in
        switch status {
        case .failed(let url):
            showFetchingBackgroundImageFailedAleft(url)
        default:
            break
        }
    }
}
```
