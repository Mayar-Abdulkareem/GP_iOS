//
//  HeaderCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/12/2023.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    static let identifier = "headerCollectionViewCellIdentifire"
    
    private let courseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.numberOfLines = 0
        label.text = AppManager.shared.course?.supervisorName
        label.font = UIFont.systemFont(ofSize: 12) 
        return label
    }()
    
    private let courseDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myLightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        addViewWithConstant(courseDetailView, constant: 8)
        courseDetailView.addSubview(courseLabel)
        courseDetailView.addSubview(descriptionLabel)

        /// Add properities
        if let course = AppManager.shared.course {
            courseLabel.text = course.courseName
            descriptionLabel.text = "Course ID: " + course.courseID + "\nSpervisor: " + course.supervisorName
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            courseLabel.leadingAnchor.constraint(equalTo: courseDetailView.leadingAnchor),
            courseLabel.trailingAnchor.constraint(equalTo: courseDetailView.trailingAnchor),
            courseLabel.centerYAnchor.constraint(equalTo: courseDetailView.centerYAnchor, constant: -10),
            courseLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: courseDetailView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: courseDetailView.trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: courseDetailView.centerYAnchor, constant: 20),
        ])
    }
}
