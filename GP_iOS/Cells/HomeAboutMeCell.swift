//
//  HomeAboutMeCell.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 19/12/2023.
//

import UIKit

class HomeAboutMeCell: UITableViewCell {
    static let identifier = "HomeAboutMeCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .mySecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "We help you organize your work and increase your progress with our humble system. On each launch, you're one step closer to graduating! Good luck Graduate"
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage.project
        return image
    }()
    
    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureViews() {
        addViewFillEntireView(
            viewWithShadow,
            top: 20,
            bottom: 0,
            leading: 20,
            trailing: 20
        )
        
        viewWithShadow.addSubview(nameLabel)
        viewWithShadow.addSubview(descLabel)
        viewWithShadow.backgroundColor = .white
        viewWithShadow.addShadow()
                        
        viewWithShadow.addSubview(image)
        viewWithShadow.addSubview(nameLabel)
        viewWithShadow.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor),
            image.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor),
            image.widthAnchor.constraint(equalToConstant: 170),
            image.heightAnchor.constraint(equalToConstant: 170),
            
            nameLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 30),
            nameLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -30),
            nameLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -10),
            
            descLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 180),
            descLabel.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -30),
            descLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -30),
        ])
    }
        
    func configureCell(name: String) {
        nameLabel.text = "Welcome Graduate \(name)"
    }
}
