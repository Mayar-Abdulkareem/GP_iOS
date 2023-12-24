//
//  Footer.swift
//  GP_iOS
//
//  Created by FTS on 17/12/2023.
//

import UIKit

class FooterView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.tintColor = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = UIColor.clear
        
        addSubview(label)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setFooterLabelTitle(text: String) {
        label.text = text
        label.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func startActivityIndicator() {
        label.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
}
