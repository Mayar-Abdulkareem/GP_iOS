//
//  SearchCollectionViewCell.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "searchTableViewCellIdentifire"
    
    private let projectNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let viewWithShadow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myPrimary
        view.addShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewMoreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = String.LocalizedKeys.viewMoreTitle.localized
        
        let imageView = UIImageView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: 20, height: 25))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.SystemImages.viewMore.image
        imageView.tintColor = UIColor.mySecondary
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.myLightGray
        
        view.addSubview(separator)
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            separator.topAnchor.constraint(equalTo: view.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
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
        addViewFillEntireView(viewWithShadow, top: 8, bottom: 8, leading: 16, trailing: 16)
        viewWithShadow.addSubview(projectNameLabel)
        viewWithShadow.addSubview(yearLabel)
        viewWithShadow.addSubview(detailsLabel)
        viewWithShadow.addSubview(typeLabel)
        viewWithShadow.addSubview(viewMoreView)
        viewWithShadow.addSubview(typeLabel)
    }
    
    private func addConstraints() {
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            projectNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            projectNameLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 10),
            
            detailsLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            detailsLabel.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 10),
            detailsLabel.bottomAnchor.constraint(equalTo: viewMoreView.topAnchor, constant: -10),
            
            yearLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            yearLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 10),
            
            typeLabel.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -16),
            typeLabel.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 10),
            
            viewMoreView.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -2),
            viewMoreView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 0),
            viewMoreView.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: 0),
            viewMoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    func configureCell(model: PreviousProject) {
        projectNameLabel.text = model.name
        yearLabel.text = model.date
        typeLabel.text = model.projectType
        detailsLabel.text = String.LocalizedKeys.studentsTitle.localized + " " + model.students + "\n" + String.LocalizedKeys.supervisorTitle.localized + " " + model.supervisor
    }
}
