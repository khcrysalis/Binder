//
//  BinderApp.swift
//  Binder
//
//  Created by samara on 1/19/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    private var aboutBoxWindowController: NSWindowController?
        func showAboutPanel() {
            if aboutBoxWindowController == nil {
                let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable,/* .resizable,*/ .titled]
                let window = NSWindow()
                window.styleMask = styleMask
                window.titlebarAppearsTransparent = true
                window.contentView = NSHostingView(rootView: AboutView())
                aboutBoxWindowController = NSWindowController(window: window)
            }
            aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
        }
}

@main
struct BinderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var info = Bundle.main.infoDictionary!
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        }.commands {
            SidebarCommands()
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                    
                }) {
                    Text("About \(info["CFBundleName"] as? String ?? "")")
                }
            }
        }
        .windowStyle(DefaultWindowStyle())
    }
}
