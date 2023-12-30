//
//  LoginViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 26/11/2023.
//

import Alamofire

class LoginViewModel {

    // MARK: - Call Backs

    var onShowTopAlert: ((_ title: String, _ subTitle: String, _ type: TopAlertType) -> Void)?
    var onAuthSuccess: ((AccessToken) -> Void)?
    var onShowLoading: (() -> Void)?

    // MARK: - Methods

    /// Fetch user by credential (ID and password)
    func login(with credential: Credential) {
        guard !credential.regID.isEmpty && !credential.password.isEmpty else {
            onShowTopAlert?(
                String.LocalizedKeys.infoTitle.localized,
                String.LocalizedKeys.fillAllFieldsMsg.localized,
                .info
            )
            return
        }

        onShowLoading?()
        let route = LoginRouter.login(credential: credential)
        BaseClient.shared.performRequest(router: route, type: AccessToken.self) {[weak self] result in
            switch result {
            case .success(let accessToken):
                AuthManager.shared.userAccessToken = accessToken.accessToken
                AuthManager.shared.role = accessToken.role
                AuthManager.shared.regID = credential.regID
                self?.onAuthSuccess?(accessToken)
            case .failure(let error):
                switch error.responseCode {
                case 401:
                    self?.onShowTopAlert?(
                        String.LocalizedKeys.errorTitle.localized,
                        String.LocalizedKeys.unauthenticatedSubtitle.localized,
                        .failure
                    )
                default:
                    self?.onShowTopAlert?(
                        String.LocalizedKeys.errorTitle.localized,
                        error.localizedDescription,
                        .failure
                    )
                }
            }
        }
    }
}
