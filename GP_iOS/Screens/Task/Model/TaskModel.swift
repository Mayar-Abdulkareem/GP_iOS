//
//  TaskModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/01/2024.
//

import Foundation

struct TaskModel {
    var viewType: TaskViewType
    let task: Task?
    let columnIndexPath: Int
    let taskIndexPath: Int?
}
