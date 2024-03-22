//
//  ProfileViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit
import Kingfisher
import FHAlert

class ProfileViewController: UIViewController, GradProNavigationControllerProtocol {

    private var viewModel: ProfileViewModelProtocol

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .myGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.SystemImages.camera.image, for: .normal)
        button.tintColor = .mySecondary
        button.backgroundColor = .myPrimary
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addAction(UIAction { [weak self] _ in
            self?.handleEditProfilePicture()
        }, for: .primaryActionTriggered)
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = AppManager.shared.profile?.name
        label.numberOfLines = 0
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .myPrimary

        tableView.register(
            LabelIconTableViewCell.self,
            forCellReuseIdentifier: LabelIconTableViewCell.identifier
        )

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    init() {
        switch Role.getRole() {
        case .student:
            viewModel = StudentProfileViewModel()
        case .supervisor:
            viewModel = SupervisorProfileViewModel()
        case .none:
            fatalError()
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.getProfile()
        startLoading()
        bindWithViewModel()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
        }

        viewModel.onProfileFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.stopLoading()
                self?.nameLabel.text = self?.viewModel.getName()
                self?.tableView.reloadData()

                if let image = self?.viewModel.image {
                    let url = URL(string: image)
                    self?.profileImageView.kf.setImage(with: url)
                } else {
                    self?.profileImageView.image = UIImage.SystemImages.personFill.image
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        //profileImageView.layer.borderWidth = 1 / UIScreen.main.scale
        profileImageView.layer.borderColor = UIColor.myGray.cgColor
        profileImageView.clipsToBounds = true
    }

    private func setupViews() {
        view.backgroundColor = UIColor.myPrimary

        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(nameLabel)
        view.addSubview(tableView)

        addNavBar(with: String.LocalizedKeys.profileTitle.localized)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -5),
            editButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -5),

            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),

            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func startLoading() {
        tableView.alpha = 0
        hideElements(isHidden: true)
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    private func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        hideElements(isHidden: false)
        view.hideLoading()
    }

    private func hideElements(isHidden: Bool) {
        profileImageView.isHidden = isHidden
        editButton.isHidden = isHidden
        nameLabel.isHidden = isHidden
    }

    func handleEditProfilePicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let actionSheet = UIAlertController(
            title: String.LocalizedKeys.profilePic.localized,
            message: String.LocalizedKeys.chooseSrc.localized,
            preferredStyle: .actionSheet
        )

        actionSheet.view.tintColor = UIColor.mySecondary

        actionSheet.addAction(
            UIAlertAction(title: String.LocalizedKeys.camera.localized,
                          style: .default,
                          handler: {
                              [weak self] _ in
                              imagePickerController.sourceType = .camera
                              self?.present(imagePickerController, animated: true)
                          })
        )

        actionSheet.addAction(
            UIAlertAction(title: String.LocalizedKeys.photoLibrary.localized,
                          style: .default,
                          handler: {
                              [weak self] _ in
                              imagePickerController.sourceType = .photoLibrary
                              self?.present(imagePickerController, animated: true)
                          })
        )

        actionSheet.addAction(
            UIAlertAction(title: String.LocalizedKeys.removePhoto.localized,
                          style: .destructive,
                          handler: {
                              [weak self] _ in
                              guard let self = self else { return }
                              self.view.showLoading(maskView: self.view)
                              self.hideElements(isHidden: true)
                              AppManager.shared.profile?.profileImage = nil
                              self.viewModel.removeProfileImage()
                          })
        )

        actionSheet.addAction(
            UIAlertAction(
                title: String.LocalizedKeys.cancel.localized,
                style: .cancel,
                handler: nil
            )
        )

        self.present(actionSheet, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?

        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker {
            viewModel.updateProfile(image: selectedImage)
            view.showLoading(maskView: view)
            hideElements(isHidden: true)
        }

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellsModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LabelIconTableViewCell.identifier,
            for: indexPath
        ) as? LabelIconTableViewCell
        cell?.configureCell(model: viewModel.cellsModel[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
