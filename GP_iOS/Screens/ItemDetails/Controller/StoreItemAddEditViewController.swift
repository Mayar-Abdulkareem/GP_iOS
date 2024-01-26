//
//  StoreItemAddEditViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 17/01/2024.
//

import UIKit

class StoreItemAddEditViewController: UIViewController,
                                      GradProNavigationControllerProtocol {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.myPrimary
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(
            ItemAddEditTextTableViewCell.self,
            forCellReuseIdentifier: ItemAddEditTextTableViewCell.identifier
        )
        tableView.register(
            ItemDetailsImageTableViewCell.self,
            forCellReuseIdentifier: ItemDetailsImageTableViewCell.identifier
        )
        tableView.register(
            ItemAddEditQuantityTableViewCell.self,
            forCellReuseIdentifier: ItemAddEditQuantityTableViewCell.identifier
        )
        tableView.register(
            ItemAddEditCheckBoxTableViewCell.self,
            forCellReuseIdentifier: ItemAddEditCheckBoxTableViewCell.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .primary,
            primaryButtonTitle: viewModel.viewType.bottomButtonTitle,
            secondaryButtonType: .disabled,
            secondaryButtonTitle: nil
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        footerView.backgroundColor = .white
        return footerView
    }()
    
    let viewModel: StoreItemAddEditViewModel
    
    init(viewModel: StoreItemAddEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureNavBar()
        setupKeyboardNotificationCenterObservers()
    }
    
    private func configureViews() {
        view.backgroundColor = .myPrimary

        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureNavBar() {
        let title = viewModel.viewType.title
        switch viewModel.viewType {
        case .add:
            addNavBar(with: title)
        case .edit:
            configureNavBarTitle(title: title)
        }
    }
    
    private func setupKeyboardNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension StoreItemAddEditViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: (keyboardViewEndFrame.height - view.safeAreaInsets.bottom) + 20,
            right: 0
        )
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

extension StoreItemAddEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = viewModel.cells[indexPath.row]
        if let model = cellModel as? ItemDetailsImageCellModel,
           let cell = tableView.dequeueReusableCell(withIdentifier: ItemDetailsImageTableViewCell.identifier, for: indexPath) as? ItemDetailsImageTableViewCell {
            cell.configure(model: model)
            cell.delegate = self
            return cell
        } else if let model = cellModel as? ItemAddEditTextCellModel,
                  let cell = tableView.dequeueReusableCell(withIdentifier: ItemAddEditTextTableViewCell.identifier, for: indexPath) as? ItemAddEditTextTableViewCell {
            cell.configure(model: model)
            cell.delegate = self
            return cell
        } else if let model = cellModel as? ItemAddEditQuantityCellModel,
                  let cell = tableView.dequeueReusableCell(withIdentifier: ItemAddEditQuantityTableViewCell.identifier, for: indexPath) as? ItemAddEditQuantityTableViewCell {
            cell.configure(model: model)
            cell.quantityStepper.delegate = self
            return cell
        } else if let model = cellModel as? ItemAddEditCheckBoxCellModel,
                  let cell = tableView.dequeueReusableCell(withIdentifier: ItemAddEditCheckBoxTableViewCell.identifier, for: indexPath) as? ItemAddEditCheckBoxTableViewCell {
            cell.configure(model: model)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
}

extension StoreItemAddEditViewController: ItemDetailsImageTableViewCellDelegate {
    func didPressEditButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension StoreItemAddEditViewController: ItemAddEditTextTableViewCellDelegate {
    func didChangeText(fieldTypes: ItemAddEditTextCellType, value: String) {
        switch fieldTypes {
        case .name:
            viewModel.item.title = value
        case .price:
            viewModel.item.price = value
        case .location:
            viewModel.item.location = value
        }
    }
}

extension StoreItemAddEditViewController: ItemEditStepperViewDelegate {
    func didUpdateQuantity(newValue: Double) {
        viewModel.item.quantity = "\(newValue)"
    }
}

extension StoreItemAddEditViewController: ItemAddEditCheckBoxTableViewCellDelegate {
    func didUpdateCheckBox(isSelected: Bool) {
        viewModel.item.showPhoneNumber = isSelected
    }
}

extension StoreItemAddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Delegate method for image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.item.image = selectedImage
            let cell = tableView.visibleCells.first as? ItemDetailsImageTableViewCell
            cell?.itemImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // Delegate method for canceling the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension StoreItemAddEditViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        switch viewModel.viewType {
        case .add:
            dismiss(animated: true)
        case .edit:
            navigationController?.popViewController(animated: true)
        }
    }
}
