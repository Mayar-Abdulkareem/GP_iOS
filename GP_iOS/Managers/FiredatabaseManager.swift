//
//  FiredatabaseManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 11/01/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class FiredatabaseManager {
    static let shared = FiredatabaseManager()
    private var dbRef: DatabaseReference?

    private init() {}

    func configureFireDatabase() {
        FirebaseApp.configure()
        dbRef = Database.database().reference()
    }

    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                print("error signing in to firedatabase")
                return
            }
            print("Signed in anonymously")
        }
    }

    func sendRequest(from fromID: String, to toID: String, details: String) {
        let newRequestRef = dbRef?.child("requests").childByAutoId()
        let requestData = ["from": fromID, "to": toID, "details": details]
        newRequestRef?.setValue(requestData)
    }

    func listenForIncomingRequests() {
        guard let userID = AuthManager.shared.regID else { return }
        let requestsRef = dbRef?.child("requests").queryOrdered(byChild: "to").queryEqual(toValue: userID)
        requestsRef?.observe(.childAdded, with: { snapshot in
            guard let requestInfo = snapshot.value as? [String: Any],
                  let fromID = requestInfo["from"] as? String,
                  let details = requestInfo["details"] as? String else {
                return
            }

            NotificationManager.shared.showNotification(title: "New Request", body: "Yoy have a new request from \(fromID)")
        })
    }

    private func signInUser(withEmail email: String, password: String, completion: @escaping (Bool, Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    completion(false, true)
                } else {
                    print(error.localizedDescription)
                    completion(false, false)
                }
                return
            }
            completion(true, false)
        }
    }

    // Updated Sign Up User
    private func signUpUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Sign up successful
            print("Signed up successfully")
        }
    }

    public func connectUser(withEmail email: String, password: String) {
        // First, try to sign in
        signInUser(withEmail: email, password: password) { [weak self] success, isUserNotFound in
            if success {
                print("Signed in successfully")
            } else if isUserNotFound {
                // If user not found, try to sign up
                self?.signUpUser(withEmail: email, password: password)
            } else {
                // Other errors
                print("Error signing in")
            }
        }
    }
}
