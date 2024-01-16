//
//  SelectPeerViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/01/2024.
//

import Foundation

enum PeerRequestViewType {
    case sendRequest
    case pending
    case accepted
}

class SelectPeerViewModel {

    // MARK: - Call Backs

    var onShowError: ((_ msg: String) -> Void)?
    var onRequestSent: (() -> Void)?

    // MARK: - Methods


}
