//
//  LoginViewModel.swift
//  GP_iOS
//
//  Created by FTS on 26/11/2023.
//

import Foundation
import Alamofire

class LoginViewModel {
    
    var onShowError: ((_ msg: String) -> Void)?
    var onAuthSuccess: ((AccessToken) -> ())?
    
    func login(with credential: Credential) {
        
        guard !credential.regID.isEmpty && !credential.password.isEmpty else {
            onShowError?(String.LocalizedKeys.fillAllFieldsMsg.localized)
            return
        }
        
        BaseClient.shared.performRequest(
            type: AccessToken.self,
            router: LoginRouter.login(credential: credential)
        ) { [weak self] result in
            switch result {
            case .success(let accessToken):
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
