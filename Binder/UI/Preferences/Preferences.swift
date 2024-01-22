//
//  Preferences.swift
//  Binder
//
//  Created by samara on 1/20/24.
//

import Foundation
/// A set of user controlled preferences.
enum Preferences {
    
    #warning("meow")
    
    @CodableStorage(key: "thumbnailSize", defaultValue: 150, handler: nil)
    static var thumbnailSize: CGFloat?
    
    @CodableStorage(key: "AddedFolders", defaultValue: [])
    static var addedFolders: [String]
}
