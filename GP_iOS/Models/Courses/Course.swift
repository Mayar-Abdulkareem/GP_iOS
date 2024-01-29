//
//  Course.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import Foundation

struct Course: Codable {
    let courseID: String
    let supervisorID: String
    let courseName: String
    let supervisorName: String
}

struct StudentProfile: Codable {
    let regID: String
    let courses: [Course]
    var skillsVector: String
    let peer: String?
    let email: String
    let name: String
    let phoneNumber: String
    let GPA: String
    var profileImage: String?
    let registrationFinished: Bool?
    let peerRegistrationFinished: Bool?
}

struct SupervisorProfile: Codable {
    let regID: String
    let name: String
    let email: String
    var profileImage: String?
    let courseStudents: [CourseStudnet]?
}

struct CourseStudnet: Codable {
    let courseID: String
    let courseName: String
    var students: [StudentCourse]?
}

struct StudentCourse: Codable {
    let id: String
    let name: String
}
