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
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
        addViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        backgroundColor = UIColor.myLightGray
        addSubview(label)
        addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
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
