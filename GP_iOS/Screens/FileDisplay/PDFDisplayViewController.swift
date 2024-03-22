//
//  PDFDisplayViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 23/01/2024.
//

import UIKit
import PDFKit

class PDFDisplayViewController: UIViewController, GradProNavigationControllerProtocol {

    private let pdfView = PDFView()

    init(data: Data) {
        super.init(nibName: nil, bundle: nil)

        if let document = PDFDocument(data: data) {
            pdfView.document = document
            pdfView.autoScales = true
        } else {
            print("Failed to load the PDF document.")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        addNavBar(with: "PDF Viewer")
    }
}
