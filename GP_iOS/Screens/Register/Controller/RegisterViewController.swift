//
//  RegisterViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit
import FHAlert

class RegisterViewController: UIViewController, GradProNavigationControllerProtocol {

    var viewModel: RegisterViewModel
    weak var coordinator: RegisterCoordinator?

    private let progressView: CircularProgressView = {
        let progressView = CircularProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private let currentStepLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()

    private let nextStepLabel: UILabel = { 
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()

    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let registerCourseStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.mySecondary
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .disabled,
            primaryButtonTitle: "",
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStepNumber(currentStep: viewModel.currentStep, totalSteps: 3)
        view.backgroundColor = UIColor.white
        bindWithViewModel()
        configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress()
    }

    func configure(
        cuurrentStepText: String,
        nextStepText: String
    ) {
        currentStepLabel.text = cuurrentStepText
        nextStepLabel.text = nextStepText
    }
    
    private func configureViews() {
        view.addSubview(progressView)
        view.addSubview(currentStepLabel)
        view.addSubview(nextStepLabel)
        view.addSubview(middleView)
        view.addSubview(footerView)

        addNavBar(with: String.LocalizedKeys.registerTitle.localized)

        middleView.addSubview(registerCourseStatusLabel)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.widthAnchor.constraint(equalToConstant: 75),
            progressView.heightAnchor.constraint(equalToConstant: 75),

            currentStepLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -15),
            currentStepLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 16),

            nextStepLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 15),
            nextStepLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 16),

            middleView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            registerCourseStatusLabel.centerYAnchor.constraint(equalTo: middleView.centerYAnchor, constant: -54),
            registerCourseStatusLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            registerCourseStatusLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),

            footerView.topAnchor.constraint(equalTo: middleView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        configureLayout()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { msg in
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
        }

        viewModel.onCourseRegistered = { [weak self] in
            self?.configureLayout()
        }
    }

    private func configureLayout() {
        footerView.isHidden = viewModel.currentStep == 4
        progressView.isHidden = (viewModel.currentStep == 4)
        registerCourseStatusLabel.isHidden = (viewModel.currentStep != 4)
        registerCourseStatusLabel.text = viewModel.requestStatus.getRegisterCourseStatusLabelText(step: viewModel.currentStep)
    }

    func disablePrimaryButton() {
        footerView.changePrimaryButtonType(type: .disabled)
    }

    func enablePrimaryButton() {
        footerView.changePrimaryButtonType(type: .primary)
    }

    func changePrimaryButtonTitle(text: String) {
        footerView.changePrimaryButtonText(text: text)
    }

    func updateProgress() {
        let currentStep = viewModel.currentStep
        let totalSteps = 3
        progressView.animateProgress(forStep: currentStep, totalSteps: totalSteps)
    }

    func setStepNumber(currentStep: Int, totalSteps: Int) {
        progressView.setStepNumber(currentStep: currentStep, totalSteps: totalSteps)
    }
}

extension RegisterViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        coordinator?.showNextStepViewController(registerViewModel: self.viewModel)
        viewModel.currentStep += 1
        viewModel.selectedIndexPath = nil
        if viewModel.currentStep == 4 {
            viewModel.requestStatus = .notSent
            middleView.showLoading(maskView: self.middleView)
            viewModel.registerCourse()
        }
    }
}
