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
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "View More"
        
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
    
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fill
//        return stackView
//    }()
    
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
 //       viewWithShadow.addSubview(stackView)
        viewWithShadow.addSubview(projectNameLabel)
        viewWithShadow.addSubview(yearLabel)
        viewWithShadow.addSubview(detailsLabel)
        viewWithShadow.addSubview(typeLabel)
        viewWithShadow.addSubview(viewMoreView)
//        stackView.addArrangedSubview(yearLabel)
//        stackView.addArrangedSubview(projectNameLabel)
        //stackView.addArrangedSubview(typeLabel)
        /// Add properities
        viewWithShadow.addShadow()
    }
    
    private func addConstraints() {
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            viewWithShadow.heightAnchor.constraint(equalToConstant: 150),
            
            //stackView.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -30),
//            stackView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 10),
//            stackView.heightAnchor.constraint(equalToConstant: 25),
//            stackView.widthAnchor.constraint(equalTo: viewWithShadow.widthAnchor, constant: -16),
            
            projectNameLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            projectNameLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -30),
            
            //detailsLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            detailsLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 10),
            detailsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            //yearLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            yearLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: -30),
            
            viewMoreView.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -2),
            viewMoreView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 0),
            viewMoreView.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: 0),
            viewMoreView.heightAnchor.constraint(equalToConstant: 30)
//            detailsLabel.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),
//            detailsLabel.centerYAnchor.constraint(equalTo: viewWithShadow.centerYAnchor, constant: 20),
        ])
    }
    
    func configureCell(model: PreviousProject) {
        projectNameLabel.text = model.name
        yearLabel.text = model.date
        //typeLabel.text = model.projectType
        detailsLabel.text = "Students: " + model.students + "\nSupervisor: " + model.supervisor
    }
}
