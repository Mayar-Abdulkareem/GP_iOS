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
        sv.spacing = 10
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
        addViews()
        setUpConstraints()
        symbolImageView.image = symbolImage
        textLabel.text = logoText
        textLabel.font = UIFont.systemFont(ofSize: logoTextSize, weight: weight)
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
        
        [symbolImageView, textLabel, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: heightAndWidth),
            symbolImageView.heightAnchor.constraint(equalToConstant: heightAndWidth),
        ])
    }
}
