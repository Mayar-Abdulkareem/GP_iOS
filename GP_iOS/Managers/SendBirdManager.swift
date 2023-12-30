//
//  SendBirdManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/12/2023.
//

import UIKit
import SendbirdChatSDK
import SendbirdUIKit

class SendBirdManager {
    static let shared = SendBirdManager()

    private let appID = "6A40637C-F859-4DBC-86E4-15E2B553A67A"

    var currentChannel: GroupChannel?

    private init() {
        initSendBird()
    }

    func initSendBird() {
        let addID = appID
        SendbirdUI.initialize(applicationId: addID) {
        } migrationHandler: {
        } completionHandler: { _ in
        }
    }

    func connectUser(id: String, nickname: String, completion: ((SBUUser?, SBError?) -> Void)? = nil) {
        SBUGlobals.currentUser = SBUUser(userId: id, nickname: nickname)
        SendbirdChat.connect(userId: id) { user, error in
            guard let user = user, error == nil else {
                completion?(nil, error)
                return
            }

            SBUGlobals.currentUser = SBUUser(userId: id, nickname: nickname)

            completion?(SBUGlobals.currentUser, nil)
            self.setTheme()
            print("Connected as \(user.userId)")
        }
    }

    private func setTheme() {
        SBUColorSet.primary500 = .mySecondary
        SBUColorSet.primary400 = .mySecondary
        SBUColorSet.primary300 = .mySecondary
        SBUColorSet.primary200 = .mySecondary
        SBUColorSet.primary100 = .mySecondary

        SBUColorSet.secondary500 = .mySecondary
        SBUColorSet.secondary400 = .mySecondary
        SBUColorSet.secondary300 = .mySecondary
        SBUColorSet.secondary200 = .mySecondary
        SBUColorSet.secondary100 = .mySecondary

        let channelListTheme = SBUChannelListTheme()
        let channelCellTheme = SBUChannelCellTheme()
        let channelTheme = SBUChannelTheme()
        let messageInputTheme = SBUMessageInputTheme()
        let messageCellTheme = SBUMessageCellTheme()
        let channelSettingsTheme = SBUChannelSettingsTheme()
        let componentTheme = SBUComponentTheme()

        let newTheme = SBUTheme(
            channelListTheme: channelListTheme,
            channelCellTheme: channelCellTheme,
            channelTheme: channelTheme,
            messageInputTheme: messageInputTheme,
            messageCellTheme: messageCellTheme,
            channelSettingsTheme: channelSettingsTheme,
            componentTheme: componentTheme
        )

        SBUTheme.set(theme: newTheme)
    }
}
