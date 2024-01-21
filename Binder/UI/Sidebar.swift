//
//  Sidebar.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
import SwiftUI

struct FileTree: View {
    let url: URL?

    var body: some View {
        if let url = url {
            Section("Home") {
                List {
                    FileItem(url: url)
                }
            }
        }
    }
}

struct FileItem: View {
    let url: URL
    @State private var isExpanded: Bool = false

    var body: some View {
        Group {
            if isDirectory {
                DisclosureGroup(
                    isExpanded: $isExpanded,
                    content: {
                        if isExpanded {
                            ForEach(sortedSubdirectories, id: \.self) { item in
                                FileItem(url: url.appendingPathComponent(item))
                            }
                        }
                    },
                    label: {
                        NavigationLink(destination: DirectoryView(url: url), label: {
                            Label(
                                title: { Text(url.lastPathComponent) },
                                icon: { Image(systemName: "folder.fill") }
                            )
                        })
                    }
                )
            } else {
                Text(url.lastPathComponent)
            }
        }
    }

    private var isDirectory: Bool {
        return (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
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

struct DirectoryView: View {
    let url: URL

    var body: some View {
        Text("Directory View: \(url.lastPathComponent)")
    }
}
