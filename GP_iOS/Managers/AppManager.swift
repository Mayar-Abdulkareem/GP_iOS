//
//  AppManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 11/12/2023.
//

import Foundation

class AppManager {
    static let shared = AppManager()
    var course: Course?
    var prevProject: PreviousProject?
    
    private init() {}
}
