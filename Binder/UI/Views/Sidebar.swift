//
//  Sidebar.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    @Binding var refreshCollectionView: Bool
    @State private var showingFolderPicker: Bool = false
    @State private var addedFoldersChanged = UUID()
    
    var body: some View {
        List {
            Section(header: Header(title: "Homes")) {
                FileTree(urls: [FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!], refreshCollectionView: $refreshCollectionView)
                FileTree(urls: [FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!], refreshCollectionView: $refreshCollectionView)
                FileTree(urls: [FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!], refreshCollectionView: $refreshCollectionView)
            }
            
            Section(header: Header(title: "Added Folders")) {
                ForEach(Preferences.addedFolders, id: \.self) { folderPath in
                    if let folderURL = URL(string: folderPath) {
                        FileTree(urls: [folderURL], refreshCollectionView: $refreshCollectionView)
                            .contextMenu {
                                Button(action: {
                                    removeFolderFromPreferences(folderPath: folderPath)
                                }) {
                                    Text("Remove")
                                }
                            }
                    }
                }
            }
        }
        .id(addedFoldersChanged)
        
        Button(action: {
            selectFolder()
        }) {
            Spacer()
            Label("Add Folder", systemImage: "plus")
                .padding(.vertical, 8)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.accentColor.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        )
        .buttonStyle(.plain)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
    
    func selectFolder() {
        let folderPicker = NSOpenPanel()
        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = false
        folderPicker.allowsMultipleSelection = false
        
        folderPicker.begin { response in
            if response == .OK, let pickedFolder = folderPicker.urls.first {
                addFolderToPreferences(folderURL: pickedFolder)
                addedFoldersChanged = UUID()
            }
        }
    }
    
    func addFolderToPreferences(folderURL: URL) {
        var existingFolders = Preferences.addedFolders
        
        if !existingFolders.contains(folderURL.path) {
            existingFolders.append(folderURL.path)
            
            Preferences.addedFolders = existingFolders
        }
    }
    
    func removeFolderFromPreferences(folderPath: String) {
        var existingFolders = Preferences.addedFolders
        
        if let index = existingFolders.firstIndex(of: folderPath) {
            existingFolders.remove(at: index)
            
            Preferences.addedFolders = existingFolders
            addedFoldersChanged = UUID()
        }
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
