//
//  LoginViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 26/11/2023.
//

import Alamofire

class LoginViewModel {
    
    // MARK: - Call Backs
    
    /// If the login failed
    var onShowError: ((_ msg: String) -> Void)?
    // If the login succeed
    var onAuthSuccess: ((AccessToken) -> ())?
    
    // MARK: - UseCases
    
    /// UseCase for fetching user by credential
    private let fetchUser = FetchUserUseCase()
    
    // MARK: - Methods
    
    /// Fetch user by credential (ID and password)
    func login(with credential: Credential) {
        guard !credential.regID.isEmpty && !credential.password.isEmpty else {
            onShowError?(String.LocalizedKeys.fillAllFieldsMsg.localized)
            return
        }
        
        fetchUser.execute(with: credential) { [weak self] result in
            switch result {
            case .success(let accessToken):
                AuthManager.shared.userAccessToken = accessToken.accessToken
                AuthManager.shared.role = accessToken.role
                AuthManager.shared.regID = credential.regID
                self?.onAuthSuccess?(accessToken)
            case .failure(let error):
                switch error.responseCode {
                case 401:
                    self?.onShowError?(String.LocalizedKeys.unauthenticatedSubtitle.localized)
                default:
                    self?.onShowError?(error.localizedDescription)
                }
            }
        }
    }
}
