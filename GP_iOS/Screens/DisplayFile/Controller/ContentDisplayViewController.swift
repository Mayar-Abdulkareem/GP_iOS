//
//  ContentDisplayViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

enum ViewControllerType {
    case showText(String, Bool)
    case addSubmission
    case editSubmission(fileName: String?,text: String?)
}

protocol ContentDelegate: AnyObject {
    func saveSubmission(file: MyFile?, text: String?)
}

class ContentDisplayViewController: UIViewController, GradProNavigationControllerProtocol {
    private var type: ViewControllerType

    private var uploadedFile: MyFile?

    weak var delegate: ContentDelegate?

    // Text View

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.tintColor = .mySecondary
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .myPrimary
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.addShadow()

        textView.delegate = self

        return textView
    }()

    private lazy var charCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    // Upload

    private lazy var viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myPrimary
        view.addShadow()
        return view
    }()

    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.SystemImages.upload.image, for: .normal)
        button.tintColor = .mySecondary
        button.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        return button
    }()

    private lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var uploadedFileName: String? {
        didSet {
            updateUploadFileView()
        }
    }

    // Footer

    private lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView(
            primaryButtonType: .disabled,
            primaryButtonTitle: "Save",
            secondaryButtonType: .disabled,
            secondaryButtonTitle: "Delete File"
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()


    init(type: ViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myPrimary
        addNavBar(with: "")
        configureTextView()
        configureForType()
    }

    private func configureForType() {
        switch type {
        case .addSubmission:
            configureUploadFile()
            configureAddSubmission()
        case .editSubmission(let file, let text):
            uploadedFileName = file
            configureUploadFile()
            if let myText = text {
                textView.text = myText
            } else {
                textView.text = "Enter the text ..."
                textView.textColor = .lightGray
            }
            textView.isEditable = true
        case .showText(let text, let canSupervisorEdit):
            configureShowText(text: text, canSupervisorEdit: canSupervisorEdit)
        }
    }

    // Text View

    /// add text view with counter under it
    func configureTextView() {
        view.addSubview(textView)
        view.addSubview(charCountLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.heightAnchor.constraint(equalToConstant: 200),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            charCountLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            charCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            charCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    /// update the count whenever text changes
    func updateCharCount(count: Int) {
        charCountLabel.text = "\(count)/120"
    }

    // Uploading

    // add the view, upload button, file name label
    func configureUploadFile() {
        view.addSubview(viewWithShadow)
        viewWithShadow.addSubview(uploadButton)
        viewWithShadow.addSubview(fileNameLabel)

        NSLayoutConstraint.activate([
            viewWithShadow.topAnchor.constraint(equalTo: charCountLabel.bottomAnchor, constant: 24),
            viewWithShadow.heightAnchor.constraint(equalToConstant: 100),
            viewWithShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewWithShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            uploadButton.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            uploadButton.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -20),

            fileNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            fileNameLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 20),
        ])
        configureFooterView()
        updateUploadFileView()
    }

    func configureFooterView() {
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }


    func updateUploadFileView() {
        if let fileName = uploadedFileName, uploadedFileName != "" {
            uploadButton.setImage(UIImage.SystemImages.document.image, for: .normal)
            fileNameLabel.text = fileName
        } else {
            uploadButton.setImage(UIImage.SystemImages.upload.image, for: .normal)
            fileNameLabel.text = "Upload File"
        }

        if uploadedFileName != nil && uploadedFileName != "" {
            footerView.changePrimaryButtonType(type: .primary)
            footerView.changeSecondaryButtonType(type: .delete)
        }
        if !textView.text.contains("Enter the text ...") && !textView.text.isEmpty {
            footerView.changePrimaryButtonType(type: .primary)
        }
    }

    func configureShowText(text: String, canSupervisorEdit: Bool) {
        if text.isEmpty {
            textView.text = "Enter the text ..."
            textView.textColor = .lightGray
        } else {
            textView.text = text
        }
        let charCount = min(text.count, 120)
        updateCharCount(count: charCount)

        if canSupervisorEdit {
            textView.isEditable = true
            configureFooterView()
            footerView.changePrimaryButtonType(type: .primary)
            footerView.changePrimaryButtonText(text: "SAVE")
            footerView.showSecondary(isHidden: true)
        }
    }

    func configureAddSubmission() {
        // Text View
        textView.isEditable = true
        textView.text = "Enter the text ..."
        textView.textColor = UIColor.lightGray

        updateCharCount(count: 0)

        // Upload
        updateUploadFileView()
    }

    @objc func handleUploadTap() {
        let types: [UTType] = [.pdf, .image, .plainText]

        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}

extension ContentDisplayViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        let text = (!textView.text.contains("Enter the text ...") && !textView.text.isEmpty) ? textView.text : nil
        dismiss(animated: true)
        delegate?.saveSubmission(file: uploadedFile, text: text)
    }

    func secondaryButtonTapped() {
        footerView.changePrimaryButtonType(type: .disabled)
        footerView.changeSecondaryButtonType(type: .disabled)
        uploadedFileName = nil
        uploadedFile = nil
        updateUploadFileView()
    }
}

extension ContentDisplayViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let charCount = min(textView.text.count, 120)
        if charCount == 120 {
            textView.isEditable = false
        } else {
            textView.textColor = .black
        }
        updateUploadFileView()
        updateCharCount(count: charCount)
    }
}

extension ContentDisplayViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }

        let shouldStopAccessing = selectedFileURL.startAccessingSecurityScopedResource()

        let fileToUpload = MyFile(
            fileName: selectedFileURL.lastPathComponent,
            fileURL: selectedFileURL.absoluteString,
            contentType: mimeType(for: selectedFileURL)
        )

        uploadedFileName = selectedFileURL.lastPathComponent

        if shouldStopAccessing {
            selectedFileURL.stopAccessingSecurityScopedResource()
        }

        uploadedFile = fileToUpload
    }

    private func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension
        return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
}
