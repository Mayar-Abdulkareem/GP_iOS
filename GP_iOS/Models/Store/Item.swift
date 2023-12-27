//
//  Item.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 24/12/2023.
//

import UIKit

struct StoreImage: Codable {
    var contentType: String
    var data: String
}

struct StoreItem: Codable {
    var id: String
    var regID: String
    var title: String
    var price: String
    var quantity: String
    var location: String
    var image: StoreImage
    var name: String
    var email: String
    var phoneNumber: String
    var showPhoneNumber: Bool
    
    var uiImage: UIImage {
        if let data = Data(base64Encoded: image.data, options: .ignoreUnknownCharacters), let dataImage = UIImage(data: data) {
            return dataImage
        } else {
            var image = UIImage.SystemImages.cart.image
            image = image.withTintColor(.gray)
            return image
        }
    }
}

struct StoreResponse: Codable {
    var totalCount: Int
    var storeItems: [StoreItem]
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
