//
//  ProfileViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 28/11/2023.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    private let viewModel = ProfileViewModel()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .myGray
        imageView.contentMode = .scaleAspectFit
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

    private let regID = LabelIconView(
        icon: UIImage.SystemImages.regID.image,
        prefix: String.LocalizedKeys.regID.localized + " ",
        text: AppManager.shared.profile?.regID ?? "",
        imageSize: 35,
        fontSize: 18
    )

    private let email = LabelIconView(
        icon: UIImage.SystemImages.email.image,
        prefix: String.LocalizedKeys.email.localized + " ",
        text: AppManager.shared.profile?.email ?? "",
        imageSize: 35,
        fontSize: 18
    )

    private let phoneNumber = LabelIconView(
        icon: UIImage.SystemImages.phone.image,
        prefix: String.LocalizedKeys.phoneNumber.localized + " ",
        text: AppManager.shared.profile?.phoneNumber ?? "",
        imageSize: 35,
        fontSize: 18
    )

    private let GPA = LabelIconView(
        icon: UIImage.SystemImages.GPA.image,
        prefix: String.LocalizedKeys.gpa.localized + " ",
        text: AppManager.shared.profile?.GPA ?? "",
        imageSize: 35,
        fontSize: 18
    )

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 70
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.profileTitle.localized,
            withCloseButton: true
        )
        view.backgroundColor = UIColor.myLightGray
        setupViews()
        viewModel.getProfile()
        hideElements(isHidden: true)
        view.showLoading(maskView: view, hasTransparentBackground: false)
        bindWithViewModel()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.view.hideLoading()
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
        }

        viewModel.onProfileFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.hideElements(isHidden: false)
                self?.view.hideLoading()
                guard let profile = AppManager.shared.profile else { return }
                self?.nameLabel.text = profile.name
                self?.regID.changeText(text: profile.regID)
                self?.email.changeText(text: profile.email)
                self?.phoneNumber.changeText(text: profile.phoneNumber)
                self?.GPA.changeText(text: profile.GPA)

                if let image = AppManager.shared.profile?.profileImage {
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
        profileImageView.clipsToBounds = true
    }

    private func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(nameLabel)
        view.addSubview(stackView)

        stackView.addArrangedSubview(regID)
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(phoneNumber)
        stackView.addArrangedSubview(GPA)

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

            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func hideElements(isHidden: Bool) {
        profileImageView.isHidden = isHidden
        editButton.isHidden = isHidden
        nameLabel.isHidden = isHidden
        stackView.isHidden = isHidden
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
