//
//  TaskViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/01/2024.
//



import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func addTask(task: Task, columnIndexPath: Int)
    func deleteTask(taskIndexPath: Int, columnIndexPath: Int)
    func editTask(task: Task, taskIndexPath: Int, columnIndexPath: Int)
}

class TaskViewController: UIViewController {

    private var viewModel = TaskViewModel()
    weak var delegate: TaskViewControllerDelegate?

    private lazy var editButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.register.image
        configuration.imagePlacement = .all

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mySecondary
        button.isHidden = viewModel.editButtonIsHidden

        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.taskModel.viewType = .edit
            self?.editButton.isHidden = true
            self?.setEnabled()
        }, for: .primaryActionTriggered)

        return button
    }()

    private lazy var deleteButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.trash.image
        configuration.imagePlacement = .all

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mySecondary
        button.isHidden = viewModel.deleteButtonIsHidden

        button.addAction(UIAction {
            [weak self] _ in
            guard let self = self,
                  let taskIndexPath = self.viewModel.taskModel.taskIndexPath else { return }
            self.delegate?.deleteTask(
                taskIndexPath: taskIndexPath,
                columnIndexPath: self.viewModel.taskModel.columnIndexPath
            )
            dismiss(animated: true)
        },for: .primaryActionTriggered)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Title"
        return label
    }()

    private lazy var titleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .myAccent
        textField.text = viewModel.titleTextFieldText
        textField.tintColor = .mySecondary
        textField.layer.borderColor = UIColor.mySecondary.cgColor
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        return textField
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Description"
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .myAccent
        textView.tintColor = .mySecondary
        textView.text = viewModel.descriptionTextViewText
        textView.layer.borderColor = UIColor.mySecondary.cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 5, bottom: 16, right: 5)
        textView.clipsToBounds = true
        return textView
    }()

    private lazy var saveButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.saveTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10

        button.addAction(UIAction {
            [weak self] _ in
            guard let self = self else { return }

            let titleText = self.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let descriptionText = self.descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)

            guard let title = titleText, !title.isEmpty,
                  let description = descriptionText, !description.isEmpty else {
                TopAlertManager.show(
                    title: String.LocalizedKeys.errorTitle.localized,
                    subTitle: String.LocalizedKeys.fillAllFields.localized,
                    type: .failure
                )
                return
            }
            let task = Task(title: title, description: description)
            if viewModel.taskModel.viewType == .add {
                self.delegate?.addTask(task: task, columnIndexPath: viewModel.taskModel.columnIndexPath)
            } else {
                guard let taskIndexPath = viewModel.taskModel.taskIndexPath else { return }
                      let columnIndexPath = viewModel.taskModel.columnIndexPath
                self.delegate?.editTask(task: task,taskIndexPath: taskIndexPath, columnIndexPath: columnIndexPath)
            }

            dismiss(animated: true)
        },for: .primaryActionTriggered)

        return button
    }()

    init(taskModel: TaskModel) {
        self.viewModel.taskModel = taskModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myPrimary
        setupViews()
    }

    private func setEnabled() {
        titleTextField.isEnabled = viewModel.titleTextFieldIsEnabled
        descriptionTextView.isEditable = viewModel.descriptionTextViewIsEditable
        descriptionTextView.isSelectable = viewModel.descriptionTextViewIsEditable
        saveButton.isHidden = viewModel.saveButtonIsHidden
    }


    private func setupViews() {
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)

        setEnabled()

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editButton.widthAnchor.constraint(equalToConstant: 20),
            editButton.heightAnchor.constraint(equalToConstant: 20),

            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}

