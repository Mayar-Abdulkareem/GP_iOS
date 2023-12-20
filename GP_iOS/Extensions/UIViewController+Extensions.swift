//
//  UIViewController+Extensions.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 20/12/2023.
//

import UIKit

/// A tag used to identify the loading view in the view hierarchy.
let loadingViewTag = 987654321

// MARK: - Loadings
extension UIViewController {
    
    /**
     Shows a loading view with animation on top of the view controller's view.
     - Parameters:
     - maskView: The view that determines the size and position of the loading view.
     - hasTransparentBackground: A flag indicating whether the loading view's background should be clear or semi-transparent white. Default is `false`.
     - isBlackTransparentBackground: A flag indicating whether the loading view's background should be black and semi-transparent. Default is `false`.
     - decreaseBottomSafeArea: A flag indicating whether the bottom safe area should be decreased. Default is `false`.
     - duration: The duration of the animation when showing the loading view. Default is `0.1` seconds.
     - titleLabel: An optional title to display below the loading indicator. Default is `nil`.
     */
    func showLoading(maskView: UIView,
                     hasTransparentBackground: Bool = false,
                     isBlackTransparentBackground: Bool = false,
                     decreaseBottomSafeArea: Bool = false,
                     duration: TimeInterval = 0.1,
                     titleLabel: String? = nil,
                     forceAdd: Bool = false) {
        
        // Check if a loading view with the specified tag already exists
        guard self.view.viewWithTag(loadingViewTag) == nil || forceAdd else { return }
        
        // Create the main container view
        let mainContainerView = UIView()
        mainContainerView.tag = loadingViewTag
        
        if hasTransparentBackground {
            mainContainerView.backgroundColor = UIColor.clear
        } else {
            mainContainerView.backgroundColor = isBlackTransparentBackground ?
            UIColor.myAccent.withAlphaComponent(0.3) :
            UIColor.myPrimary.withAlphaComponent(0.9)
        }
        
        // Add the main container view as a subview and set constraints
        self.view.addSubview(mainContainerView)
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.topAnchor.constraint(equalTo: maskView.topAnchor).isActive = true
        mainContainerView.bottomAnchor.constraint(equalTo: maskView.bottomAnchor).isActive = true
        mainContainerView.leadingAnchor.constraint(equalTo: maskView.leadingAnchor).isActive = true
        mainContainerView.trailingAnchor.constraint(equalTo: maskView.trailingAnchor).isActive = true
        
        // Calculate bottom padding based on the bottom safe area
        let bottomSafeAreaPadding = view.safeAreaInsets.bottom
        let bottomPadding: CGFloat = decreaseBottomSafeArea ? bottomSafeAreaPadding : 0.0
        
        // Create the loading view
        let loadingView = UIActivityIndicatorView(style: .medium)
        loadingView.color =  isBlackTransparentBackground ? UIColor.myPrimary : UIColor.myAccent
        loadingView.startAnimating()
        
        // Add the loading view to the main container view and set constraints
        mainContainerView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor, constant: -bottomPadding).isActive = true
        
        if let title = titleLabel {
            let label = UILabel()
            mainContainerView.addSubview(label)
            label.font = UIFont.systemFont(ofSize: 12)
            label.text = title
            label.textColor = .gray
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: 8).isActive = true
            label.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor).isActive = true
        }
        
        // Set the initial alpha of the main container view to 0 and animate it to 1
        mainContainerView.alpha = 0
        UIView.animate(withDuration: duration) {
            mainContainerView.alpha = 1
        }
    }
    
    /**
     Removes the loading view from the view controller's view.
     - Parameter animated: A flag to indicate whether the removal should be animated or immediate. Default is `false`.
     */
    func hideLoading() {
        let loadingView = self.view.viewWithTag(loadingViewTag)
        
        // Fade out the loading view with animation
        loadingView?.alpha = 1.0
        UIView.animate(withDuration: 0.15) {
            loadingView?.alpha = 0.0
        } completion: { _ in
            loadingView?.removeFromSuperview()
        }
    }
    
    /**
     Checks if a loading view is currently displayed.
        - Returns: `true` if a loading view with the specified tag exists in the view controller's view, otherwise `false`.
     */
    func isLoading() -> Bool {
        return self.view.viewWithTag(loadingViewTag) != nil
    }
}
