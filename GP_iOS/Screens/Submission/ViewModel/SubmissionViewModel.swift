//
//  SubmissionViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit

enum SubmissionCellType: Int, CaseIterable {
    case title
    case descFile
    case opened
    case due
    case status
    case uploadedFile
    case uploadedText
    case comments
}

//class SubmissionViewModel {
//
//}
//
//class StudentSubmissionViewModel: SubmissionViewModel {
//
//}

//class SupervisorSubmissoinViewModel: SubmissionViewModel {
//
//}

class SubmissionViewModel {

    var cellTypes: [SubmissionCellType] = SubmissionCellType.allCases
    var tagType = TagType.notSubmitted
    var submission: Submission?
    let assignment: Assignment?

    var cellModels: [LabelIconCellModel] { return [
        LabelIconCellModel(
            icon: UIImage.SystemImages.document.image,
            prefixText: "Assignment Name",
            valueText: assignment?.title ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.document.image,
            prefixText: "Description File",
            valueText: getDescFileName(),
            isMoreIconHidden: assignment?.file?.fileName == nil || assignment?.file?.fileName == ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.year.image,
            prefixText: "Opened",
            valueText: DateUtils.shared.convertToDate(date: assignment?.opened ?? "")
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.year.image,
            prefixText: "Due",
            valueText: DateUtils.shared.convertToDate(date: assignment?.deadline ?? "")
        ),
        LabelIconCellModel(
            icon:  UIImage.SystemImages.year.image,
            prefixText: "",
            valueText: ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.upload.image,
            prefixText: "Uploaded File",
            valueText: getUploadedFileName(),
            isMoreIconHidden: submission?.file?.fileName == nil || submission?.file?.fileName == ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.uploadedText.image,
            prefixText: "Uploaded Text",
            valueText: submission?.text ?? "No text is added",
            isMoreIconHidden: submission?.text == nil
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.uploadedText.image,
            prefixText: "Supervisor Comment",
            valueText: submission?.supervisorComment ?? "No comment",
            isMoreIconHidden: submission?.supervisorComment == nil || submission?.supervisorComment == "",
            isLastCell: true
        )
    ]}

    init() {
        assignment = AppManager.shared.assignment
    }

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onSubmissionFetched: (() -> Void)?

    // MARK: - Methods

    func updateCellTypes() {
        switch tagType {
        case .submitted:
            cellTypes = SubmissionCellType.allCases
        case .notSubmitted:
            cellTypes = Array(SubmissionCellType.allCases.prefix(5))
        }
    }

    func isLastCell(index: Int) -> Bool {
        if index == (cellTypes.count - 1) {
            return true
        } else {
            return false
        }
    }

    func getUploadedFileName() -> String {
        if submission?.file?.fileName == "" || submission?.file?.fileName == nil {
            return "No uploaded file"
        } else {
            return submission?.file?.fileName ?? ""
        }
    }

    func getDescFileName() -> String {
        if assignment?.file?.fileName == "" || assignment?.file?.fileName == nil {
            return "No uploaded file"
        } else {
            return assignment?.file?.fileName ?? ""
        }
    }

    func getSubmission() {
        var studentID: String?
        var courseID: String?
        switch Role.getRole() {
        case .student:
            studentID = AuthManager.shared.regID
            courseID = AppManager.shared.course?.courseID
        case .supervisor:
            studentID = AppManager.shared.selectedSubmission?.studentID
            courseID = AppManager.shared.courseStudents?.courseID
        case .none:
            fatalError()
        }
        guard let studentID = studentID,
              let courseID = courseID,
              let assignmentID = AppManager.shared.assignment?.id else { return }
        let route = SubmissionsRouter.getSubmission(studentID: studentID, courseID: courseID, assignmentID: assignmentID)
        BaseClient.shared.performRequest(router: route, type: Submission.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.submission = data
                if (data.id == nil) {
                    self?.tagType = .notSubmitted
                } else {
                    self?.tagType = .submitted
                }
                self?.updateCellTypes()
                self?.onSubmissionFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func deleteSubmission() {
        guard let submissionID = submission?.id else { return }
        let route = SubmissionsRouter.deleteSubmission(submissionID: submissionID)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.submission = nil
                self?.tagType = .notSubmitted
                self?.updateCellTypes()
                self?.onSubmissionFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func editText(text: String?) {
        guard let submissionID = submission?.id,
              let text = text else { return }
        let route = SubmissionsRouter.editText(submissionId: submissionID, text: text)
        BaseClient.shared.performRequest(router: route, type: Submission.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.submission = data
                if (data.id == nil) {
                    self?.tagType = .notSubmitted
                } else {
                    self?.tagType = .submitted
                }
                self?.updateCellTypes()
                self?.onSubmissionFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func addSupervisorText(text: String?) {
        guard let submissionID = AppManager.shared.selectedSubmission?.id,
              let text = text else { return }
        let route = SubmissionsRouter.addSupervisorComment(submissionID: submissionID, comment: text)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.getSubmission()
//                self?.submission = data
//                if (data.id == nil) {
//                    self?.tagType = .notSubmitted
//                } else {
//                    self?.tagType = .submitted
//                }
//                self?.updateCellTypes()
//                self?.onSubmissionFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func addSubmission(file: MyFile?, text: String?) {
        guard let regID = AuthManager.shared.regID,
              let courseID = AppManager.shared.course?.courseID,
              let assignmentID = AppManager.shared.assignment?.id else { return }
        let mySubmission = MySubmission(
            assignmentID: assignmentID,
            studentID: regID,
            courseID: courseID,
            text: text
        )
        let route = SubmissionsRouter.addSubmission(mySubmission: mySubmission)
        let parameters = [
            "assignmentID": mySubmission.assignmentID,
            "studentID": mySubmission.studentID,
            "courseID": mySubmission.courseID,
            "text": mySubmission.text
        ]

        BaseClient.shared.uploadFile(
            router: route,
            file: file,
            parameters: parameters,
            type: Submission.self
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.submission = data
                if (data.id == nil) {
                    self?.tagType = .notSubmitted
                } else {
                    self?.tagType = .submitted
                }
                self?.updateCellTypes()
                self?.onSubmissionFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
