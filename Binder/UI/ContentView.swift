//
//  ContentView.swift
//  Binder
//
//  Created by samara on 1/19/24.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var selectedURL: URL?
    @State private var refreshCollectionView = false

    var body: some View {
        NavigationView {
            Sidebar(selectedURL: $selectedURL, refreshCollectionView: $refreshCollectionView)
            
            Text("Select a folder in the sidebar")
                .foregroundColor(.secondary)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    toggleSidebar()
                }) {
                    Image(systemName: "sidebar.leading")
                }
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    updateThumbnailSize()
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            }
            ToolbarItem(placement: .automatic) {
                Slider(value: .init(get: {
                    Preferences.thumbnailSize!
                }, set: { newValue in
                    Preferences.thumbnailSize = newValue
                    updateThumbnailSize()
                }), in: 50...500, step: 50)
                .frame(width: 150)
            }
        }
        .background(VisualEffectView().ignoresSafeArea())
    }
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    private func updateThumbnailSize() {
        refreshCollectionView.toggle()
    }
}
