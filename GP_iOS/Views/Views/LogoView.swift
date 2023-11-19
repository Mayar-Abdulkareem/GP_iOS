//
//  Logo.swift
//  GP_iOS
//
//  Created by FTS on 19/11/2023.
//

import UIKit

class LogoView: UIView {
    let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    init(symbolName: String, logoText: String) {
        super.init(frame: .zero)
        
        symbolImageView.image = UIImage(systemName: symbolName)
        textLabel.text = logoText
        textLabel.textAlignment = .center
        
        addSubview(symbolImageView)
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
