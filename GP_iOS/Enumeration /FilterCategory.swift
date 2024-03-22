//
//  SortType.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 23/12/2023.
//

import Foundation

enum CategoryType: String {
    case date = "Date"
    case type = "Type"
}

enum DateOptions: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}

enum SortType: String {
    case desc
    case asc
}
