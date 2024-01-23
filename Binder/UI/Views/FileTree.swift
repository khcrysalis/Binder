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
    @State private var isSubdirectoriesLoading = false
    @Binding var refreshCollectionView: Bool

    @State private var imageFiles: [URL] = []

    private func updateImageFiles() { self.imageFiles = url.getAllImageFiles() }
    
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
                await throttledLoadSubdirectories()
            }
        }
        .onChange(of: isExpanded) { newValue in
            if newValue {
                Task {
                    await throttledLoadSubdirectories()
                }
            }
        }
        .onChange(of: refreshCollectionView) { _ in
            self.updateImageFiles()
        }
    }
}

extension FileItem {
    private func throttledLoadSubdirectories() async {
        guard !isSubdirectoriesLoading else {
            return
        }

        isSubdirectoriesLoading = true
        await loadSubdirectories()
        isSubdirectoriesLoading = false
    }
    
    private actor SubdirectoriesManager {
        private var subdirectories: [String] = []

        func append(_ element: String) {
            subdirectories.append(element)
        }

        func getSortedSubdirectories() -> [String] {
            return subdirectories.sorted()
        }
    }

    private func loadSubdirectories() async {
        do {
            let subdirectoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)

            let subdirectoriesManager = SubdirectoriesManager()

            await withTaskGroup(of: Void.self) { group in
                for subitemURL in subdirectoryContents {
                    guard let isDirectoryKey = try? subitemURL.resourceValues(forKeys: [.isDirectoryKey]),
                          isDirectoryKey.isDirectory == true
                    else {
                        continue
                    }

                    group.addTask {
                        await subdirectoriesManager.append(subitemURL.lastPathComponent)
                    }
                }
            }

            sortedSubdirectories = await subdirectoriesManager.getSortedSubdirectories()
        } catch {
            print("Error loading subdirectories: \(error)")
        }
    }
}
