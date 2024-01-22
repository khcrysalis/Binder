//
//  AboutView.swift
//  Binder
//
//  Created by samara on 1/21/24.
//

import Foundation
import SwiftUI

// MARK: - About panel for "About Binder"


struct AboutView: View {
    var info = Bundle.main.infoDictionary!
    
    var body: some View {
        HStack {
            if let appIcon = getAppIcon() {
                Image(nsImage: appIcon)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text((info["CFBundleName"] as? String) ?? "")
                    .font(Font.system(size: 33))
                
                Text("Version \(info["CFBundleShortVersionString"] as? String ?? "0.0")")
                    .font(.system(size: 14))
                    .opacity(0.5)
                    .padding(.bottom, 10)
                
                Text((info["NSHumanReadableCopyright"] as? String) ?? "")
                    .font(.system(size: 12))
                    .opacity(0.5)
                
                Divider()
                CreditsView()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .shadow(color: Color.accentColor.opacity(0.7), radius: 50, x: 0, y: 0)
        }
        .frame(minWidth: 600)
    }
    
    func getAppIcon() -> NSImage? {
        if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
           let iconImage = NSImage(contentsOfFile: iconPath) {
            return iconImage
        }
        return nil
    }
}


// MARK: - Credits section



struct Person {
    var name: String
    var icon: URL
    var role: String
    var link: URL
}

let credits = [
    Person(name: "Samara", icon: URL(string: "https://github.com/ssalggnikool.png")!, role: "The maker", link: URL(string: "https://github.com/ssalggnikool")!),
    Person(name: "HAHALOSAH", icon: URL(string: "https://github.com/HAHALOSAH.png")!, role: "Bug fixes (thank you lots)", link: URL(string: "https://github.com/HAHALOSAH")!),
]

fileprivate struct CreditsView: View {
    @State private var loadedImages: [String: NSImage] = [:]
    
    var body: some View {
        ForEach(credits, id: \.name) { person in
            Link(destination: person.link) {
                HStack {
                    if let image = loadedImages[person.icon.absoluteString] {
                        
                        Image(nsImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                    } else {
                        ProgressView()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 10)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.headline)
                            .foregroundColor(Color(NSColor.labelColor))
                        Text(person.role)
                            .font(.subheadline)
                            .foregroundColor(Color(NSColor.secondaryLabelColor))
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7))
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.accentColor.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                        )
                )
                .padding(.vertical, 5)
                .onAppear {
                    loadImage(for: person.icon)
                }
            }
        }
    }
    
    private func loadImage(for url: URL) {
        guard loadedImages[url.absoluteString] == nil else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = NSImage(data: data) {
                DispatchQueue.main.async {
                    loadedImages[url.absoluteString] = image
                }
            }
        }.resume()
    }
}
