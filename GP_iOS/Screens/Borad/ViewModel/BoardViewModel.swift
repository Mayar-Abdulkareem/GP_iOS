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
        guard let regID = AuthManager.shared.regID,
              let courseID = AppManager.shared.course?.courseID else { return }
        let route = BoardRouter.getBoard(regID: regID, courseID: courseID)
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
