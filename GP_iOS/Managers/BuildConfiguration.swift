//
//  BuildConfiguration.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 20/12/2023.
//

import Foundation

enum Environment: String {
    case dev = "Debug"
    case prod = "Release"
}

final class BuildConfiguration {
    static let shared = BuildConfiguration()

    let environment: Environment

    var baseURL: String {
        switch environment {
        case .dev:
            return "http:/localhost:3001"
        case .prod:
            return "http://gradpro2-855153665.eu-central-1.elb.amazonaws.com"
        }
    }

    private init() {
        let currentConfiguration = Bundle.main.object(
            forInfoDictionaryKey:
                "Configuration"
        ) as? String
        guard let currentConfiguration = currentConfiguration else {
            self.environment = Environment.dev
            return
        }
        let environment = Environment(rawValue: currentConfiguration)!
        self.environment = environment
    }
}
