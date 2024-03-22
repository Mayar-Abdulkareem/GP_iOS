//
//  RegisterCoordinator.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import UIKit

class RegisterCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: MoreCoordinator?
    var navController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    ///  Start the ``RegisterCoordinator``
    func start() {
        showRegisterViewController()
    }

    func showRegisterViewController() {
        let registerViewModel = RegisterViewModel()
        registerViewModel.setStep()
        registerViewModel.onRequestFetched = { [weak self] in
            var viewController: RegisterViewController?
            switch registerViewModel.currentStep {
            case 1:
                viewController = StepOneViewController(viewModel: registerViewModel)
            case 2:
                viewController = StepTwoViewController(viewModel: registerViewModel)
            case 3:
                viewController = StepThreeViewController(viewModel: registerViewModel)
            case 4:
                viewController = RegisterViewController(viewModel: registerViewModel)
            default:
                viewController = RegisterViewController(viewModel: registerViewModel)
            }
            guard let viewController = viewController else { return }
            viewController.coordinator = self
            self?.navController = UINavigationController(rootViewController: viewController)
            guard let navController = self?.navController else { return }
            navController.modalPresentationStyle = .fullScreen
            self?.navigationController.present(navController, animated: true)
        }
    }

    func showNextStepViewController(registerViewModel: RegisterViewModel) {
        var viewController: RegisterViewController?
        switch registerViewModel.currentStep {
        case 1:
            viewController = StepTwoViewController(viewModel: registerViewModel)
        case 2:
            viewController = StepThreeViewController(viewModel: registerViewModel)
        case 3:
            viewController = RegisterViewController(viewModel: registerViewModel)
        default:
            viewController = RegisterViewController(viewModel: registerViewModel)
        }
        guard let viewController = viewController else { return }
        viewController.coordinator = self
        navController?.pushViewController(viewController, animated: true)
    }

    func showBackStepViewController(registerViewModel: RegisterViewModel) {
        var viewController: RegisterViewController?
        switch registerViewModel.currentStep {
        case 2:
            viewController = StepOneViewController(viewModel: registerViewModel)
        case 3:
            viewController = StepTwoViewController(viewModel: registerViewModel)
        default:
            viewController = StepOneViewController(viewModel: registerViewModel)
        }
        guard let viewController = viewController else { return }
        viewController.coordinator = self
        navController?.pushViewController(viewController, animated: true)
    }
}
