//
//  Logo.swift
//  GP_iOS
//
//  Created by FTS on 19/11/2023.
//

import UIKit

/// A custom logo view
/// - Parameters:
///  - symbolImage: The logo image
///  - logoText: The logo title (Label text)
class LogoView: UIView {
    
    let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(resource: .primary)
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        return sv
    }()
    
    init(symbolImage: UIImage, logoText: String) {
        super.init(frame: .zero)
        addViews()
        setUpConstraints()
        symbolImageView.image = symbolImage
        textLabel.text = logoText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        
        addSubview(stackView)
        
        if UIView.userInterfaceLayoutDirection(for: stackView.semanticContentAttribute) == .rightToLeft {
            stackView.addArrangedSubview(textLabel)
            stackView.addArrangedSubview(symbolImageView)
        } else {
            stackView.addArrangedSubview(symbolImageView)
            stackView.addArrangedSubview(textLabel)
        }
        
        [self, symbolImageView, textLabel, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 30),
            symbolImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
