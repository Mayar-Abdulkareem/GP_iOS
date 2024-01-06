//
//  RegisterViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit

class RegisterViewController: UIViewController {

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
        label.font = UIFont.boldSystemFont(ofSize: 15)
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

    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.filterTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10

        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let coordinator = self.coordinator else { return }
            self.coordinator?.showBackStepViewController(registerViewModel: self.viewModel)
            self.viewModel.currentStep -= 1
        }, for: .primaryActionTriggered)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.filterTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10

        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let coordinator = self.coordinator else { return }
            self.coordinator?.showNextStepViewController(registerViewModel: self.viewModel)
            self.viewModel.currentStep += 1
            self.viewModel.selectedIndexPath = nil
            if self.viewModel.currentStep == 4 {
                self.viewModel.requestStatus = .notSent
                self.middleView.showLoading(maskView: self.middleView)
                self.viewModel.registerCourse()
            }
        }, for: .primaryActionTriggered)
        return button
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
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.registerTitle.localized,
            withCloseButton: true
        )
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
        nextStepText: String,
        leftButtonText: String,
        leftButtonEnable: Bool = false,
        rightButtonText: String,
        rightButtonEnable: Bool = false
    ) {
        currentStepLabel.text = cuurrentStepText
        nextStepLabel.text = nextStepText
        leftButton.setTitle(leftButtonText, for: .normal)
        leftButton.isEnabled = leftButtonEnable
        rightButton.setTitle(rightButtonText, for: .normal)
        rightButton.isEnabled = rightButtonEnable
    }
    
    private func configureViews() {
        view.addSubview(progressView)
        view.addSubview(currentStepLabel)
        view.addSubview(nextStepLabel)
        view.addSubview(middleView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)

        middleView.addSubview(registerCourseStatusLabel)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.widthAnchor.constraint(equalToConstant: 100),
            progressView.heightAnchor.constraint(equalToConstant: 100),

            currentStepLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -10),
            currentStepLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 8),

            nextStepLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 10),
            nextStepLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 8),

            middleView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            registerCourseStatusLabel.centerYAnchor.constraint(equalTo: middleView.centerYAnchor, constant: -54),
            registerCourseStatusLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            registerCourseStatusLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),

            leftButton.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 8),
            leftButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            leftButton.widthAnchor.constraint(equalToConstant: 100),


            rightButton.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 8),
            rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            rightButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            rightButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    //    if self.viewModel.currentStep != 4 {
            configureLayout()
    //    }
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { msg in
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
        }

        viewModel.onCourseRegistered = { [weak self] in
            //self?.middleView.hideLoading()
            self?.configureLayout()
        }
    }

    private func configureLayout() {
        //middleView.hideLoading()
        rightButton.isHidden = (viewModel.currentStep == 4)
        leftButton.isHidden = (viewModel.currentStep == 4)
        progressView.isHidden = (viewModel.currentStep == 4)
        registerCourseStatusLabel.isHidden = (viewModel.currentStep != 4)
        registerCourseStatusLabel.text = viewModel.requestStatus.getRegisterCourseStatusLabelText(step: viewModel.currentStep)
    }

    func enableRightButton(isEnabled: Bool) {
        rightButton.isEnabled = isEnabled
    }

    func enableLeftButton(isEnabled: Bool) {
        leftButton.isEnabled = isEnabled
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
