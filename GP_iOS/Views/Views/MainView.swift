//
//  HeaderView.swift
//  GP_iOS
//
//  Created by FTS on 27/11/2023.
//

import UIKit

class MainView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.header
        return imageView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.loginBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let logoView: UIView = {
        let view = LogoView(heightAndWidth: 20, logoTextSize: 20, weight: .regular)
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(headerImageView)
        addSubview(backgroundImageView)
        addSubview(logoView)
        addSubview(titleLabel)
    }
    
    private func addConstraints() {
        
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            logoView.centerYAnchor.constraint(equalTo: headerImageView.centerYAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            titleLabel.centerYAnchor.constraint(equalTo: headerImageView.centerYAnchor, constant: 50)
        ])
    }
}
