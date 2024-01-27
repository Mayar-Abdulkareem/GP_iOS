//
//  AssignmentsViewModel.swift
//  GP_iOS
//
//  Created by MayarAbdulkareem on 21/01/2024.
//

import Foundation

class AssignmentsViewModel {

    var assignments = [Assignment]()

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onAssignmentsFetched: ((_ noAssignments: Bool) -> Void)?
    var onRequestAccepted: (() -> Void)?
    var onRequestDeclined: (() -> Void)?
    var onViewTypeSpecified: (() -> Void)?


    // MARK: - Methods

    func getAllAssignments() {
        guard let courseID = AppManager.shared.course?.courseID else { return }
        let route = SubmissionsRouter.getAssignments(courseID: courseID)
        BaseClient.shared.performRequest(router: route, type: [Assignment].self) { [weak self] result in
            switch result {
            case .success(let assignments):
                self?.assignments = assignments
                if (assignments.count == 0) {
                    self?.onAssignmentsFetched?(true)
                } else {
                    self?.onAssignmentsFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func formatDeadline(_ deadlineString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        if let date = isoFormatter.date(from: deadlineString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd-MM-yyyy 'at:' HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return deadlineString
        }
    }

    func getCellModel(index: Int) -> AssignmentCellModel {
        return AssignmentCellModel(
            title: assignments[index].title,
            date: formatDeadline(assignments[index].deadline)
        )
    }
}
