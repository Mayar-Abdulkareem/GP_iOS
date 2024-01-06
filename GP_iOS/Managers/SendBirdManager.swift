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

    //var currentChannel: GroupChannel?

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

    func connectUser() {
        guard let regID = AuthManager.shared.regID,
              let name = AppManager.shared.profile?.name else { return }
        let image = AppManager.shared.profile?.profileImage
        self.setTheme()

        SendbirdChat.connect(userId: regID) { user, error in
            guard let user = user, error == nil else {
                return
            }

            SBUGlobals.currentUser = SBUUser(userId: regID, nickname: name, profileURL: image)
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

    func returnSBUGroupChannelListViewController() -> SBUGroupChannelListViewController {
        return SBUGroupChannelListViewController()
    }

    func updateUserInfo() {
        guard let name = AppManager.shared.profile?.name,
              let regID = AuthManager.shared.regID else { return }

        let params = UserUpdateParams()
        params.nickname = name

        if let imageUrlString = AppManager.shared.profile?.profileImage,
           let url = URL(string: imageUrlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading image data: \(error?.localizedDescription ?? "")")
                    return
                }
                params.profileImageData = data

                SendbirdChat.updateCurrentUserInfo(params: params) { bytesSent, totalBytesSent, totalBytesExpectedToSend in
                    // Handle progress updates if needed
                } completionHandler: { error in
                    DispatchQueue.main.async {
                        guard error == nil else {
                            print("Error updating user info: \(error?.localizedDescription ?? "")")
                            return
                        }
                        SBUGlobals.currentUser = SBUUser(userId: regID, nickname: name, profileURL: imageUrlString)
                    }
                }
            }
            task.resume()
        }
    }
}
