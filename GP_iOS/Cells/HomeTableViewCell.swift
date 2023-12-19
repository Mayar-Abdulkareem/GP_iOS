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
    let background: UIColor
    let titleColor: UIColor
}

class HomeTableViewCell: UITableViewCell {
    static let identifier = "homeTableViewCellIdentifire"
    
    private let courseNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        addViewFillEntireView(
            viewWithShadow,
            top: 10,
            bottom: 10,
            leading: 20,
            trailing: 20
        )
        
        viewWithShadow.addSubview(courseNameLabel)
        viewWithShadow.addSubview(supervisorNameLabel)
        viewWithShadow.addShadow()
    }
    
    private func addConstraints() {
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            courseNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            courseNameLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 20),
            
            supervisorNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            supervisorNameLabel.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 0),
            supervisorNameLabel.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -20)
        ])
    }
    
    func configureCell(model: HomeTableViewCellModel) {
        viewWithShadow.backgroundColor = model.background
        courseNameLabel.text = model.name
        supervisorNameLabel.text = model.supervisor
        courseNameLabel.textColor = model.titleColor
    }
}
