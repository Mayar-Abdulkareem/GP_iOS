//
//  TopAlertManager.swift
//  Paycard
//
//  Created by Mayar Abdulkareem - FTS on 08/11/2023.
//  Copyright © 2023 R365. All rights reserved.
//

import UIKit

// MARK: - Top Alert Manager
class TopAlertManager {
    
    /// Shows a custom alert view at the top of the screen, removing any existing top alert views.
    /// - Parameters:
    ///  - title: The alert title.
    ///  - subTitle: The alert subtitle.
    ///  - type: The alert type.
    ///  - hasTopPadding: Bool to detrmine adding top padding to the view in case of view controller is presented not in full screen
    ///  - completion: A completion block to be executed after the alert is displayed.
    static func show(title: String,
                     subTitle: String,
                     type: TopAlertType,
                     hasTopPadding: Bool = false,
                     completion: (() -> Void)? = nil) {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let currentTopAlertViews = window.subviews.filter({ $0 is TopAlertView })
        currentTopAlertViews.forEach({ $0.removeFromSuperview() })
        
        let alertView = TopAlertView()
        
        alertView.configureView(title: title,
                                subTitle: subTitle,
                                type: type)
        
        addTopAlertView(view: alertView,
                        hasTopPadding: hasTopPadding,
                        in: window)
        
        alertView.displayView(duration: 3) {
            completion?()
        }
    }
    
    /// Add top alert view to the window.
    /// - Parameters:
    ///   - view: The alert view to add.
    ///   - hasTopPadding: Bool to detrmine adding top padding to the view in case of view controller is presented not in full screen
    ///   - window: The window to add the alert view to.
    private static func addTopAlertView(view: UIView,
                                        hasTopPadding: Bool,
                                        in window: UIWindow) {
        view.layer.zPosition = 99
        view.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(view)
        
        let topPadding: CGFloat = hasTopPadding ? 20 : 0
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: window.layoutMarginsGuide.topAnchor, constant: topPadding),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
        ])
    }
}
