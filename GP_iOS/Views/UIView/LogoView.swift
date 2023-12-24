//
//  Logo.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/11/2023.
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
        imageView.tintColor = UIColor.myPrimary
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()
    
    private var heightAndWidth: CGFloat
    
    init(
        symbolImage: UIImage = UIImage.SystemImages.graduationCap.image,
        logoText: String = String.LocalizedKeys.logoText.localized,
        heightAndWidth: CGFloat = 30,
        logoTextSize: CGFloat = 30,
        weight: UIFont.Weight = .bold
    ) {
        self.heightAndWidth = heightAndWidth
        super.init(frame: .zero)
        configureViews()
        symbolImageView.image = symbolImage
        textLabel.text = logoText
        textLabel.font = UIFont.systemFont(ofSize: logoTextSize, weight: weight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        
        addViewFillEntireView(stackView)
        
        if UIView.userInterfaceLayoutDirection(for: stackView.semanticContentAttribute) == .rightToLeft {
            stackView.addArrangedSubview(textLabel)
            stackView.addArrangedSubview(symbolImageView)
        } else {
            stackView.addArrangedSubview(symbolImageView)
            stackView.addArrangedSubview(textLabel)
        }
        
        NSLayoutConstraint.activate([
            symbolImageView.widthAnchor.constraint(equalToConstant: heightAndWidth),
            symbolImageView.heightAnchor.constraint(equalToConstant: heightAndWidth),
        ])
    }
}