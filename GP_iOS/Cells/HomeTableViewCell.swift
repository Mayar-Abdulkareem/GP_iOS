//
//  CourseCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 09/12/2023.
//

import UIKit

struct HomeTableViewCellModel {
    let name: String
    let supervisor: String
}

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "homeTableViewCellIdentifire"
    
    private let courseNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let supervisorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let viewWithShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        addViewFillEntireView(viewWithShadow, top: 20, bottom: 20, leading: 30, trailing: 30)
        viewWithShadow.addSubview(courseNameLabel)
        viewWithShadow.addSubview(supervisorNameLabel)
        /// Add properities
        viewWithShadow.addShadow()
    }
    
    private func addConstraints() {
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            viewWithShadow.heightAnchor.constraint(equalToConstant: 90),
            
            courseNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            courseNameLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -20),
            courseNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            supervisorNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            supervisorNameLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 20),
            supervisorNameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configureCell(model: HomeTableViewCellModel) {
        courseNameLabel.text = model.name
        supervisorNameLabel.text = model.supervisor
    }
}
