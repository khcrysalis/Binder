//
//  Sidebar.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    @Binding var selectedURL: URL?
    @Binding var refreshCollectionView: Bool
    
    var body: some View {
        Section() {
            FileTree(title: "Downloads", urls: [FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!], refreshCollectionView: $refreshCollectionView)
            FileTree(title: "Desktop", urls: [FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!], refreshCollectionView: $refreshCollectionView)
            
        }
    }
}

struct FileTree: View {
    let title: String
    let urls: [URL]
    @Binding var refreshCollectionView: Bool
    
    var body: some View {
        List {
            ForEach(urls, id: \.self) { url in
                FileItem(url: url, refreshCollectionView: $refreshCollectionView)
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct FileItem: View {
    let url: URL
    @State private var isExpanded: Bool = false
    @Binding var refreshCollectionView: Bool
    
    var imageFiles: [URL] { return url.getAllImageFiles() }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ForEach(sortedSubdirectories, id: \.self) { item in
                    FileItem(url: url.appendingPathComponent(item), refreshCollectionView: $refreshCollectionView)
                }
            },
            label: {
                NavigationLink(destination: CollectionView(images: imageFiles, refresh: $refreshCollectionView)
                    .navigationTitle(imageFiles.first?.deletingLastPathComponent().lastPathComponent ?? "Binder"),
                               label: {
                    Label(
                        title: { Text(url.lastPathComponent) },
                        icon: { Image(systemName: "folder.fill") }
                    )
                })
            }
        )
    }
    
    private var subdirectories: [String] {
        return isExpanded ?
        (try? FileManager.default.contentsOfDirectory(atPath: url.path)
            .filter {
                let isDirectoryKey = try? URL(fileURLWithPath: url.appendingPathComponent($0).path).resourceValues(forKeys: [.isDirectoryKey])
                return isDirectoryKey?.isDirectory == true && !$0.hasPrefix(".")
            }
        ) ?? [] : []
    }
    
    private var sortedSubdirectories: [String] {
        return subdirectories.sorted()
    }
}

struct Header: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.bold(.footnote)())
            .textCase(.none)
            .foregroundStyle(.secondary)
            .padding(.bottom, 5)
    }
}
