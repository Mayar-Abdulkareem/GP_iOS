//
//  BoardViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/01/2024.
//

import Foundation

class BoardViewModel {

    var hasUnsavedChanges = false
    var board: Board?

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onBoardFetched: (() -> Void)?

    // MARK: - Methods

    func getBoard() {

        var regID: String?
        var courseID: String?
        var supervisorID: String?
        switch Role.getRole() {
        case .student:
            regID = AuthManager.shared.regID
            courseID = AppManager.shared.course?.courseID
            supervisorID = AppManager.shared.course?.supervisorID
        case .supervisor:
            regID = AppManager.shared.selectedStudent
            courseID = AppManager.shared.courseStudents?.courseID
            supervisorID = AuthManager.shared.regID
        case .none:
            fatalError()
        }

        guard let regID = regID,
              let courseID = courseID,
              let supervisorID = supervisorID else { return }

        let route = BoardRouter.getBoard(regID: regID, courseID: courseID, supervisorID: supervisorID)
        BaseClient.shared.performRequest(router: route, type: Board.self) { [weak self] result in
            switch result {
            case .success(let board):
                self?.board = board
                self?.onBoardFetched?()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    func saveBoard() {
        guard let board = board else { return }
        let route = BoardRouter.saveOrder(board: board)
        BaseClient.shared.performRequest(router: route, type: String.self) { [weak self] result in
            switch result {
            case .success:
                self?.getBoard()
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
}
