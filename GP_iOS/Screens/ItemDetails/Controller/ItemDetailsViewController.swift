//
//  ItemDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/12/2023.
//

import UIKit
import Kingfisher

class ItemDetailsViewController: UIViewController {

    private let viewModel: StoreViewModel

    weak var delegate: StoreViewController?

    private var isMyItem: Bool {
        return (AppManager.shared.item?.regID == AuthManager.shared.regID)
    }

    // MARK: Views

    private lazy var priceView = StoreCustomView(
        icon: UIImage.SystemImages.price.image,
        textFieldText: viewModel.viewType.priceTitleTextFieldText,
        textFieldPlaceHolder: viewModel.viewType.priceTitleTextFieldPlaceHolder,
        isEditable: viewModel.viewType == .addItem
    )
    private lazy var locationView = StoreCustomView(
        icon: UIImage.SystemImages.location.image,
        textFieldText: viewModel.viewType.locationTitleTextFieldText,
        textFieldPlaceHolder: viewModel.viewType.locationTitleTextFieldPlaceHolder,
        isEditable: viewModel.viewType == .addItem
    )
    private lazy var quantityView = StoreCustomView(
        icon: UIImage.SystemImages.number.image,
        textFieldText: viewModel.viewType.quantityTitleTextFieldText,
        isEditable: false
    )
    private lazy var nameView = StoreCustomView(
        icon: UIImage.SystemImages.name.image,
        textFieldText: AppManager.shared.item?.name
    )
    private lazy var emailView = StoreCustomView(
        icon: UIImage.SystemImages.email.image,
        textFieldText: AppManager.shared.item?.email,
        isCopyIconEnable: true
    )
    private lazy var phoneNumberView = StoreCustomView(
        icon: UIImage.SystemImages.phone.image,
        textFieldText: AppManager.shared.item?.phoneNumber
    )

    // MARK: Buttons

    private lazy var editButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.SystemImages.register.image
        configuration.imagePlacement = .all

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mySecondary
        button.isHidden = !isMyItem || (viewModel.page == .contactInfo) || (viewModel.viewType == .addItem) || (viewModel.state == .edit)

        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.state = .edit
            self?.editButton.isHidden = true
            self?.priceView.isEnableTextFileld(true)
            self?.locationView.isEnableTextFileld(true)
            self?.quantityView.isEnableTextFileld(false)
            self?.configureStepperMotor()
            self?.saveButton.isHidden = false
            self?.photoButton.isHidden = false
            self?.checkboxLabel.isHidden = false
            self?.checkboxButton.isHidden = false
            self?.itemTitleTextField.isEnabled = true
            self?.itemTitleTextField.borderStyle = .roundedRect
            self?.checkboxButton.isSelected = AppManager.shared.item?.showPhoneNumber ?? false
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
        button.isHidden = !isMyItem || (viewModel.viewType == .addItem)

        button.addAction(UIAction { [weak self] _ in
            //self?.delegate?.deleteButtonTapped()
        }, for: .primaryActionTriggered)
        return button
    }()

    private lazy var photoButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewModel.viewType.photoButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.backgroundColor = UIColor.myLightGray
        button.tintColor = UIColor.mySecondary
        button.layer.cornerRadius = 10
        button.isHidden = (viewModel.state == .normal)

        button.addAction(UIAction { [weak self] _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true, completion: nil)
        }, for: .primaryActionTriggered)

        return button
    }()

    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .mySecondary
        button.setImage(UIImage.SystemImages.circle.image, for: .normal)
        button.isHidden = (viewModel.state == .normal)

        button.setImage(UIImage.SystemImages.circleFill.image, for: .selected)
        button.addAction(UIAction { [weak self] _ in
            button.isSelected.toggle()
        }, for: .primaryActionTriggered)

        return button
    }()

    private lazy var saveButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.saveTitle.localized, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor.mySecondary
        button.tintColor = UIColor.myPrimary
        button.layer.cornerRadius = 10
        button.isHidden = (viewModel.page == .contactInfo) || (viewModel.state == .normal)

        button.addAction(UIAction { [weak self] _ in
            if let newQuantity = self?.quantityView.textField.text {
                self?.viewModel.item.quantity = newQuantity
            }
            self?.viewModel.item.title = self?.itemTitleTextField.text
            self?.viewModel.item.price = self?.priceView.textField.text
            self?.viewModel.item.location = self?.locationView.textField.text
            self?.viewModel.item.showPhoneNumber = self?.checkboxButton.isSelected
            //self?.delegate?.saveButtonTapped()
        }, for: .primaryActionTriggered)

        return button
    }()

    // MARK: StackViews

    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.isHidden = (viewModel.page == .contactInfo)
        return stackView
    }()

    private lazy var contactStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.isHidden = (viewModel.page == .itemInfo)
        return stackView
    }()

    // MARK: TextFields

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.boldSystemFont(ofSize: 15)
        textField.text = viewModel.viewType.title
        textField.isEnabled = false
        return textField
    }()

    private lazy var itemTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.boldSystemFont(ofSize: 15)
        textField.textColor = .mySecondary
        textField.tintColor = .mySecondary
        textField.borderStyle = viewModel.viewType.itemTitleTextFieldBorderStyle
        textField.placeholder = viewModel.viewType.itemTitleTextFieldPlaceHolder
        textField.text = viewModel.viewType.itemTitleTextFieldText
        textField.isEnabled = (viewModel.viewType == .addItem) || (viewModel.state == .edit)
        return textField
    }()

    // MARK: Image

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.mySecondary
        imageView.contentMode = .scaleAspectFit
        if viewModel.viewType == .itemDetails {
            let url = URL(string: AppManager.shared.item?.image ?? UIImage.SystemImages.cart.rawValue)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage.SystemImages.cart.image
        }
        return imageView
    }()

    // MARK: Label

    private lazy var checkboxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String.LocalizedKeys.shareMyPhoneNumber.localized
        label.isHidden = (viewModel.state == .normal)
        return label
    }()

    // MARK: Control

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [String.LocalizedKeys.itemInfo.localized, String.LocalizedKeys.contactInfo.localized])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.isHidden = (viewModel.viewType == .addItem)

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mySecondary]
        segmentControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(textAttributes, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return segmentControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberView.isHidden = AppManager.shared.item?.showPhoneNumber ?? false
        configureHeader()
        configureItemInfo()
        configureContactInfo()
        configureStepperMotor()
    }

    init(viewModel: StoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHeader() {
        view.backgroundColor = .myPrimary

        view.addSubview(titleTextField)
        view.addSubview(deleteButton)
        view.addSubview(segmentControl)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 15),
            deleteButton.heightAnchor.constraint(equalToConstant: 15),

            segmentControl.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            segmentControl.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureItemInfo() {
        view.addSubview(editButton)
        view.addSubview(itemImageView)
        view.addSubview(photoButton)
        view.addSubview(itemTitleTextField)
        view.addSubview(itemStackView)
        view.addSubview(checkboxButton)
        view.addSubview(checkboxLabel)
        view.addSubview(saveButton)

        itemStackView.addArrangedSubview(priceView)
        itemStackView.addArrangedSubview(locationView)
        itemStackView.addArrangedSubview(quantityView)

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editButton.widthAnchor.constraint(equalToConstant: 15),
            editButton.heightAnchor.constraint(equalToConstant: 15),

            itemImageView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 4),
            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 80),
            itemImageView.heightAnchor.constraint(equalToConstant: 80),

            photoButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4),
            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: 100),
            photoButton.heightAnchor.constraint(equalToConstant: 30),

            itemTitleTextField.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 4),
            itemTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            // itemTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            itemTitleTextField.widthAnchor.constraint(equalTo: quantityView.getTextFieldWidthAchor(), constant: 28),

            itemStackView.topAnchor.constraint(equalTo: itemTitleTextField.bottomAnchor, constant: 16),
            itemStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            itemStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            checkboxButton.topAnchor.constraint(equalTo: itemStackView.bottomAnchor, constant: 8),
            checkboxButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
            checkboxButton.heightAnchor.constraint(equalToConstant: 30),

            checkboxLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            checkboxLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),

            saveButton.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 8),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func configureContactInfo() {
        view.addSubview(contactStackView)

        contactStackView.addArrangedSubview(nameView)
        contactStackView.addArrangedSubview(emailView)
        contactStackView.addArrangedSubview(phoneNumberView)

        NSLayoutConstraint.activate([
            contactStackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            contactStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            contactStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

        phoneNumberView.isHidden = !(AppManager.shared.item?.showPhoneNumber ?? false)
    }

    private func configureStepperMotor() {
        let quantity = (viewModel.viewType == .itemDetails) ? viewModel.item.quantity ?? "1" : "1"
        let isStepperHidden = (viewModel.page == .contactInfo) || (viewModel.state == .normal)
        quantityView.showStepperValue(quantity: quantity, isHidden: isStepperHidden)
    }

    private func updateViews() {
        editButton.isHidden = (viewModel.page == .contactInfo) || !isMyItem || (viewModel.state == .edit)
        itemImageView.isHidden = (viewModel.page == .contactInfo)
        itemTitleTextField.isHidden = (viewModel.page == .contactInfo)
        itemStackView.isHidden = (viewModel.page == .contactInfo)
        saveButton.isHidden = (viewModel.page == .contactInfo) || (viewModel.state == .normal)
        contactStackView.isHidden = (viewModel.page == .itemInfo)

        photoButton.isHidden = (viewModel.state == .normal) || (viewModel.page == .contactInfo)
        checkboxButton.isHidden = (viewModel.state == .normal) || (viewModel.page == .contactInfo)
        checkboxLabel.isHidden = (viewModel.state == .normal) || (viewModel.page == .contactInfo)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.page = .itemInfo
        case 1:
            viewModel.page = .contactInfo
        default:
            break
        }
        updateViews()
    }

    //    private func configureViews() {
    //        view.backgroundColor = .myPrimary
    //
    //        view.addSubview(titleTextField)
    //        view.addSubview(deleteButton)
    //        view.addSubview(editButton)
    //
    //        view.addSubview(itemImageView)
    //        view.addSubview(photoButton)
    //
    //        view.addSubview(itemStackView)
    //        view.addSubview(contactStackView)
    //
    //        view.addSubview(checkboxButton)
    //        view.addSubview(checkboxLabel)
    //
    //        view.addSubview(saveButton)
    //
    //        configureStackviews()
    //
    //        NSLayoutConstraint.activate([
    //            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
    //            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //
    //            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
    //            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //            deleteButton.widthAnchor.constraint(equalToConstant: 50),
    //            deleteButton.heightAnchor.constraint(equalToConstant: 50),
    //
    //            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
    //            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            editButton.widthAnchor.constraint(equalToConstant: 50),
    //            editButton.heightAnchor.constraint(equalToConstant: 50),
    //
    //            itemImageView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
    //            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            itemImageView.widthAnchor.constraint(equalToConstant: 100),
    //            itemImageView.heightAnchor.constraint(equalToConstant: 100),
    //
    ////            itemImageView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
    ////            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    ////            itemImageView.widthAnchor.constraint(equalToConstant: 150),
    ////            itemImageView.heightAnchor.constraint(equalToConstant: 150),
    //
    //            photoButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8),
    //            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            photoButton.widthAnchor.constraint(equalToConstant: 100),
    //            photoButton.heightAnchor.constraint(equalToConstant: 30),
    //
    ////            changePhotoButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8),
    ////            changePhotoButton.centerXAnchor.constraint(equalTo: itemImageView.centerXAnchor),
    ////            changePhotoButton.widthAnchor.constraint(equalToConstant: 100),
    ////            changePhotoButton.heightAnchor.constraint(equalToConstant: 30),
    //
    //            itemStackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 8),
    //            itemStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            itemStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //
    //            checkboxButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            checkboxButton.topAnchor.constraint(equalTo: itemStackView.bottomAnchor, constant: 8),
    //            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
    //            checkboxButton.heightAnchor.constraint(equalToConstant: 30),
    //
    //            checkboxLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
    //            checkboxLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
    //
    //            contactStackView.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 8),
    //            contactStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            contactStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //
    ////            stackView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
    ////            stackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
    ////            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //
    //
    ////            checkboxButton.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
    ////            checkboxButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
    ////            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
    ////            checkboxButton.heightAnchor.constraint(equalToConstant: 30),
    //
    //            saveButton.topAnchor.constraint(equalTo: contactStackView.bottomAnchor, constant: 8),
    //            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            saveButton.widthAnchor.constraint(equalToConstant: 120)
    //        ])
    //
    //        if (!(AppManager.shared.item?.showPhoneNumber ?? false)) {
    //            phoneNumberView.isHidden = true
    //        }
    //        checkboxLabel.isHidden = true
    //        checkboxButton.isHidden = true
    //    }
    //
    //    private func configureStackviews() {
    //        itemStackView.addArrangedSubview(quantityView)
    //        itemStackView.addArrangedSubview(priceView)
    //        itemStackView.addArrangedSubview(locationView)
    //
    //        contactStackView.addArrangedSubview(nameView)
    //        contactStackView.addArrangedSubview(emailView)
    //        contactStackView.addArrangedSubview(phoneNumberView)
    //    }
}

extension ItemDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Delegate method for image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.item.image = selectedImage
            itemImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // Delegate method for canceling the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
