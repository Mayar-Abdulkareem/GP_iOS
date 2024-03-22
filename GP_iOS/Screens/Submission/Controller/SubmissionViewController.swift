//
//  SubmissionViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit
import WebKit
import FHAlert

class SubmissionViewController: UIViewController, GradProNavigationControllerProtocol {

    private var viewModel = SubmissionViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .myPrimary

        tableView.register(
            SubmissionTitleTableViewCell.self,
            forCellReuseIdentifier: SubmissionTitleTableViewCell.identifier
        )

        tableView.register(
            SubmissionStatusViewController.self,
            forCellReuseIdentifier: SubmissionStatusViewController.identifier
        )

        tableView.register(
            LabelIconTableViewCell.self,
            forCellReuseIdentifier: LabelIconTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .delete,
            primaryButtonTitle: "",
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindWithViewModel()
        startLoading()
        viewModel.getSubmission()
        configureViews()
    }

    private func startLoading() {
        tableView.alpha = 0
        footerView.isHidden = true
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    private func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
            self.footerView.isHidden = false
        }
        view.hideLoading()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
        }

        viewModel.onSubmissionFetched = { [weak self] in
            self?.stopLoading()
            self?.configureViewType()
        }
    }

    private func configureViewType() {
        footerView.changePrimaryButtonType(type: .primary)
        if Role.getRole() == .supervisor {
            footerView.changePrimaryButtonType(type: .primary)
            footerView.changePrimaryButtonText(text: "GRADE")
            hideEditButton()
        } else {
            switch viewModel.tagType {
            case .notSubmitted:
                hideEditButton()
                footerView.changePrimaryButtonType(type: .primary)
                footerView.changePrimaryButtonText(text: "UPLOAD")
            case .submitted:
                addEditButton()
                footerView.isHidden = false
                footerView.changePrimaryButtonType(type: .delete)
                footerView.changePrimaryButtonText(text: "DELETE")
            }
        }
        if DateUtils.shared.isAssignmentDue(dateString: viewModel.assignment?.deadline ?? "") {
            footerView.isHidden = true
        }
        tableView.reloadData()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        configureNavBarTitle(title: String.LocalizedKeys.submissionTitle.localized)
        addSeparatorView()
    }

    private func handleFile(_ file: File) {
        guard let fileName = file.fileName, let contentType = file.contentType else {
            print("File name or content type is missing")
            return
        }

        if let content = file.content, !content.isEmpty {
            if contentType == "image/jpeg" || contentType == "image/png" {
                if let imageData = Data(base64Encoded: content) {
                    let image = UIImage(data: imageData)
                    displayImage(image)
                }
            } else if contentType == "application/pdf" {
                if let fileData = Data(base64Encoded: content) {
                    openPDF(fileData)
                }
            }
        }
    }

    func displayImage(_ image: UIImage?) {
        guard let imageToDisplay = image else { return }

        let imageViewController = ImageDisplayViewController(image: imageToDisplay)
        let navController = UINavigationController(rootViewController: imageViewController)
        navigationController?.present(navController, animated: true)
    }

    func openPDF(_ fileData: Data) {
        let pdfViewController = PDFDisplayViewController(data: fileData)
        let navController = UINavigationController(rootViewController: pdfViewController)
        navigationController?.present(navController, animated: true)
    }

    func viewText(text: String, canSupervisorEdit: Bool) {
        let viewController = ContentDisplayViewController(type: .showText(text, canSupervisorEdit))
        let navController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navController, animated: true)
    }

    func addEditButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
    }

    func hideEditButton() {
        self.navigationItem.rightBarButtonItem = nil
    }

    @objc func editButtonTapped() {
        let text = viewModel.submission?.text
        let viewController = ContentDisplayViewController(
            type: .editSubmission(fileName: viewModel.submission?.file?.fileName, text: text)
        )
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navController, animated: true)
    }
}

extension SubmissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch viewModel.cellTypes[indexPath.row] {

        case .status:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SubmissionStatusViewController.identifier,
                for: indexPath
            ) as? SubmissionStatusViewController
            cell?.configureCell(
                tagType: viewModel.tagType,
                isLastCell: viewModel.isLastCell(index: indexPath.row)
            )
            return cell ?? UITableViewCell()

        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LabelIconTableViewCell.identifier,
                for: indexPath
            ) as? LabelIconTableViewCell
            cell?.configureCell(model: viewModel.cellModels[indexPath.row])
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.cellTypes[indexPath.row] {
        case .descFile:
            guard let file = viewModel.assignment?.file else { return }
            handleFile(file)
        case .uploadedFile:
            guard let file = viewModel.submission?.file else { return }
            handleFile(file)
        case .uploadedText:
            guard let text = viewModel.submission?.text else { return }
            viewText(text: text, canSupervisorEdit: false)
        case .comments:
            guard let text = viewModel.submission?.supervisorComment else { return }
            viewText(text: text, canSupervisorEdit: false)
        default:
            return
        }
    }
}

extension SubmissionViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        if Role.getRole() == .supervisor {
            let viewController = ContentDisplayViewController(type: .showText(AppManager.shared.selectedSubmission?.supervisorComment ?? "", true))
            viewController.delegate = self
            let navController = UINavigationController(rootViewController: viewController)
            navigationController?.present(navController, animated: true)
        } else if viewModel.tagType == .notSubmitted {
            let viewController = ContentDisplayViewController(type: .addSubmission)
            viewController.delegate = self
            let navController = UINavigationController(rootViewController: viewController)
            navigationController?.present(navController, animated: true)
        } else {
            startLoading()
            viewModel.deleteSubmission()
        }
    }
}

extension SubmissionViewController: ContentDelegate {
    func saveSubmission(file: MyFile?, text: String?) {
        startLoading()
        if Role.getRole() == .supervisor && text != nil{
            viewModel.addSupervisorText(text: text)
        } else if file == nil && viewModel.tagType == .submitted {
            viewModel.editText(text: text)
        } else {
            viewModel.addSubmission(file: file, text: text)
        }
    }
}
