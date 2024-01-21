//
//  Attributes.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
import AppKit

extension NSImage {
    func thumbnailImage() -> NSImage? {
        let thumbnailSize = NSSize(width: 150, height: 150)

        let aspectRatio = size.width / size.height
        let thumbnailWidth = min(thumbnailSize.width, size.width)
        let thumbnailHeight = thumbnailWidth / aspectRatio

        let thumbnailRect = NSRect(x: 0, y: 0, width: thumbnailWidth, height: thumbnailHeight)
        let thumbnail = NSImage(size: thumbnailRect.size)

        thumbnail.lockFocus()
        defer { thumbnail.unlockFocus() }

        draw(in: thumbnailRect, from: .zero, operation: .sourceOver, fraction: 1.0)

        return thumbnail
    }
}

extension URL {
    func getAllImageFiles() -> [URL] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let imageFiles = fileURLs.filter { $0.isImageFile() }
            return imageFiles.sorted { $0.lastPathComponent.lowercased() < $1.lastPathComponent.lowercased() }
        } catch {
            print("Error while getting image files: \(error)")
            return []
        }
    }

    func isImageFile() -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "jp2"]
        return imageExtensions.contains(self.pathExtension.lowercased())
    }
}
