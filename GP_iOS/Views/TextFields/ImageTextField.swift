//
//  ImageTextField.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 25/12/2023.
//

import UIKit

class ImageTextField: UITextField {

    private let leftImage: UIImage?
    private let cornerRadius: CGFloat
    private let iconsTintColor: UIColor

    init(
        iconsTintColor: UIColor,
        leftImage: UIImage?,
        cornerRadius: CGFloat,
        isSecureTextEntry: Bool = false
    ) {

        self.iconsTintColor = iconsTintColor
        self.leftImage = leftImage
        self.cornerRadius = cornerRadius

        super.init(frame: .zero)
        self.isSecureTextEntry = isSecureTextEntry

        if isSecureTextEntry {
            addRightView()
        }

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.textFieldBackground
        font = UIFont.systemFont(ofSize: 15)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = cornerRadius
        leftViewMode = .always

        setupLeftView()
    }

    private func setupLeftView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.image = leftImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = iconsTintColor

        let leftPadding: CGFloat = 8
        var width = leftPadding + 20

        if borderStyle == .none || borderStyle == .line {
            width += 10
        }

        let view = UIView()
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            view.widthAnchor.constraint(equalToConstant: width)
        ])

        leftView = view
    }

    private func addRightView() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.SystemImages.fillEye.image, for: .normal)
        button.setImage(UIImage.SystemImages.slashFillEye.image, for: .selected)

        button.addAction(UIAction { [weak self] _ in
            self?.togglePasswordVisibility(button)
        }, for: .primaryActionTriggered)

        button.tintColor = iconsTintColor

        let view = UIView()
        view.addViewFillEntireView(button, leading: 10, trailing: 10)

        self.rightView = view
        self.rightViewMode = .always
    }

    private func togglePasswordVisibility(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
