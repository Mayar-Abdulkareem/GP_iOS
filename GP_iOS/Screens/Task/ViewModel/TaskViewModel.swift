//
//  TaskViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/01/2024.
//

import Foundation

class TaskViewModel {

    // MARK: - Variables
    var taskModel = TaskModel(viewType: .read, task: Task(title: "", description: ""), columnIndexPath: 0, taskIndexPath: 0)

    var editButtonIsHidden: Bool {
        switch taskModel.viewType {
        case .read:
            return false
        case .edit:
            return true
        case .add:
            return true
        }
    }

    var deleteButtonIsHidden: Bool {
        switch taskModel.viewType {
        case .read:
            return false
        case .edit:
            return false
        case .add:
            return true
        }
    }

    var titleTextFieldIsEnabled: Bool {
        switch taskModel.viewType {
        case .read:
            return false
        case .edit:
            return true
        case .add:
            return true
        }
    }

    var descriptionTextViewIsEditable: Bool {
        switch taskModel.viewType {
        case .read:
            return false
        case .edit:
            return true
        case .add:
            return true
        }
    }

    var titleTextFieldText: String? {
        switch taskModel.viewType {
        case .read:
            return taskModel.task?.title
        case .edit:
            return taskModel.task?.title
        case .add:
            return nil
        }
    }

//    var titleTextFieldPlaceholder: String? {
//        switch taskModel.viewType {
//        case .read:
//            return nil
//        case .edit:
//            return nil
//        case .add:
//            return "Enter the title"
//        }
//    }

    var descriptionTextViewText: String? {
        switch taskModel.viewType {
        case .read:
            return taskModel.task?.description
        case .edit:
            return taskModel.task?.description
        case .add:
            return nil
        }
    }

    var saveButtonIsHidden: Bool {
        switch taskModel.viewType {
        case .read:
            return true
        case .edit:
            return false
        case .add:
            return false
        }
    }
}
