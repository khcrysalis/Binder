//
//  Preferences.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
#warning("This is taken from https://github.com/NSAntoine/Antoine, thank you.")

/// A set of user controlled preferences.
enum Preferences {
        
    @CodableStorage(key: "thumbnailSize", defaultValue: 150, handler: nil)
    static var thumbnailSize: CGFloat?
    
    @CodableStorage(key: "AddedFolders", defaultValue: [])
    static var addedFolders: [String]
    
    @Storage(key: "UserPreferredLanguageCode", defaultValue: nil, callback: preferredLangChangedCallback)
    static var preferredLanguageCode: String?
}

fileprivate extension Preferences {
    // MARK: - Callbacks
    
    static func preferredLangChangedCallback(newValue: String?) {
        Bundle.preferredLocalizationBundle = .makeLocalizationBundle(preferredLanguageCode: newValue)
    }
}

