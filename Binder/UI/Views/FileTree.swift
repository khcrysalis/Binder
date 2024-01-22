//
//  FileTree.swift
//  Binder
//
//  Created by samara on 1/21/24.
//

import Foundation
import SwiftUI


struct FileTree: View {
    let urls: [URL]
    @Binding var refreshCollectionView: Bool
    
    var body: some View {
        ForEach(urls, id: \.self) { url in
            FileItem(url: url, refreshCollectionView: $refreshCollectionView)
        }
        .listStyle(SidebarListStyle())
    }
}

struct FileItem: View {
    let url: URL
    @State private var isExpanded: Bool = false
    @State private var sortedSubdirectories: [String] = []
    @Binding var refreshCollectionView: Bool

    @State private var imageFiles: [URL] = []

    private func updateImageFiles() {
        self.imageFiles = url.getAllImageFiles()
    }
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ForEach(sortedSubdirectories, id: \.self) { item in
                    FileItem(url: url.appendingPathComponent(item), refreshCollectionView: $refreshCollectionView)
                }
            },
            label: {
                NavigationLink(
                    destination: CollectionView(images: imageFiles, refresh: $refreshCollectionView)
                        .navigationTitle(imageFiles.first?.deletingLastPathComponent().lastPathComponent ?? "Binder"),
                    label: {
                        Label(
                            title: { Text(url.lastPathComponent) },
                            icon: { Image(systemName: "folder.fill") }
                        )
                    }
                )


            }
        )
        .onAppear {
            self.updateImageFiles()
            Task {
                await loadSubdirectories()
            }
        }
        .onChange(of: isExpanded) { newValue in
            if newValue {
                Task {
                    await loadSubdirectories()
                }
            }
        }
        .onChange(of: refreshCollectionView) { _ in
            self.updateImageFiles()
        }
    }
    
    private func loadSubdirectories() async {
        do {
            let subs = try FileManager.default.contentsOfDirectory(atPath: url.path)
                .filter {
                    let isDirectoryKey = try? URL(fileURLWithPath: url.appendingPathComponent($0).path).resourceValues(forKeys: [.isDirectoryKey])
                    return isDirectoryKey?.isDirectory == true && !$0.hasPrefix(".")
                }
            sortedSubdirectories = subs.sorted()
        } catch {
            print("Error loading subdirectories: \(error)")
        }
    }
}
