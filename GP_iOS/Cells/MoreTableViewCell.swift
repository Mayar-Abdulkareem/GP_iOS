//
//  MoreTableViewCell.swift
//  GP_iOS
//
//  Created by FTS on 28/11/2023.
//

import UIKit

struct MoreCellModel {
    let title: String
    let icon: UIImage
}

class MoreTableViewCell: UITableViewCell {
    
    static let identifier = "moreCellIdentifire"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.darkGray
        //imageView.backgroundColor = UIColor.myGray
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.myAccent
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        addConstraints()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addViews() {
        addSubview(stackView)
        /// Add properities
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func addConstraints() {
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            //self.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(moreCellModel: MoreCellModel) {
        //print(moreCellModel.icon)
        //print(moreCellModel.title)
        iconImageView.image = moreCellModel.icon.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        titleLabel.text = moreCellModel.title
    }

}
