//
//  Item.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 24/12/2023.
//

import UIKit

struct StoreResponse: Codable {
    var totalCount: Int
    var storeItems: [StoreItem]
}

struct StoreItem: Codable {
    var id: String
    var regID: String
    var title: String
    var price: String
    var quantity: String
    var location: String
    var image: String
    var name: String
    var email: String
    var phoneNumber: String
    var showPhoneNumber: Bool
}

struct Item {
    var id: String
    var title: String?
    var price: String?
    var location: String?
    var image: UIImage?
    var quantity: String?
    var showPhoneNumber: Bool?
}
