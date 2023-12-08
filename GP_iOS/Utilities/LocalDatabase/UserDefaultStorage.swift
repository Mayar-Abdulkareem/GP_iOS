//
//  UserDefaultStorage.swift
//  GP_iOS
//
//  Created by FTS on 06/11/2023.
//

import Foundation

/// Keys used in the project for UserDefaults
enum UserDefaultsKeys: String {
    case accessToken
}

/// Storing and rerieving values for UserDefaults.
@propertyWrapper
class UserDefaultStorage<T> {
    
    /// The key used to store and retrieve values in UserDefaults.
    private let key: String
    
    /// Storage instance
    private let storage: UserDefaults
    
    /// - Parameters:
    ///   - key: The key used to store and retrieve values in UserDefaults.
    ///   - storage: The referance for UserDefaults.
    init(key: UserDefaultsKeys,
         storage: UserDefaults = .standard) {
        self.key = key.rawValue
        self.storage = storage
    }
    
    /// The value that will be stored and retrieved.
    var wrappedValue: T? {
        get {
            /// Read value from the storage.
            return storage.object(forKey: key) as? T
        }
        set {
            /// Write value to the storage
            storage.set(newValue, forKey: key)
        }
    }
}
