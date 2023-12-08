//
//  AuthManager.swift
//  GP_iOS
//
//  Created by FTS on 27/11/2023.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    
    @UserDefaultStorage(key: .accessToken)
    var userAccessToken: String?
    
    private init() {}
    
    var isUserAuthenticated: Bool {
        if AuthManager.shared.userAccessToken != nil {
            return true
        } else {
            return false
        }
    }   
}
