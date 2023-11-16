//
//  Coordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem - FTS on 05/11/2023.
//

import UIKit

/// Define the structure of a Coordinator
protocol Coordinator {
    
    /// To present the ViewController
    var navigationController: UINavigationController { get set }
    
    /// Keep track of child coordinators associated with the main coordinator.
    var childCoordinators: [Coordinator] { get set }
    
    /// Presenting the ViewController based on the flow
    func start()
}
