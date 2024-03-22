//
//  AppManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 11/12/2023.
//

import Foundation

class AppManager {
    static let shared = AppManager()

    // Courses
    var course: Course?
    var courseStudents: CourseStudnet?

    var prevProject: PreviousProject?
    var item: StoreItem?

    // Profile
    var profile: StudentProfile?
    var supervisorProfile: SupervisorProfile?
    
    var categories: [Category] = []
    var assignment: Assignment?
    var selectedSubmission: SupervisorSubmissoins?
    var selectedStudent: String?

    private init() {}
}
