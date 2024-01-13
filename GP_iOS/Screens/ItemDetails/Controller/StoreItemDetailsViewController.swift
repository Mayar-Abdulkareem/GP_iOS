//
//  StoreItemDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit

class StoreItemDetailsViewController: UIViewController {
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.myPrimary
        tableView.separatorStyle = .none
        
        tableView.register(
            ItemDetailsTableViewCell.self,
            forCellReuseIdentifier: ItemDetailsTableViewCell.identifier
        )
        tableView.register(
            ItemDetailsImageTableViewCell.self,
            forCellReuseIdentifier: ItemDetailsImageTableViewCell.identifier
        )
        
        tableView.dataSource = self
        
        return tableView
    }()
    
    let viewModel: ItemDetailsViewModel
    
    init(viewModel: ItemDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBarTitle(title: viewModel.item.title)
        addNavCloseButton()
        
        view.addViewFillEntireView(tableView)
        
        view.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavBarTitle(title: String) {
        self.title = title
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mySecondary,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func addNavCloseButton() {
        let closeButton = UIBarButtonItem(
            title: "Close",
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        closeButton.tintColor = UIColor.mySecondary
        navigationItem.leftBarButtonItem = closeButton
    }
}

extension StoreItemDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .image:
            1
        case .itemInfo:
            viewModel.itemInfoCells.count
        case .contactInfo:
            viewModel.contactInfoCells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        if case .image = section {
            let cell = tableView.dequeueReusableCell(
                    withIdentifier: ItemDetailsImageTableViewCell.identifier,
                    for: indexPath
            ) as? ItemDetailsImageTableViewCell
            
            cell?.configure(imageString: viewModel.itemImageURLString)
            
            return cell ?? UITableViewCell()
        } else {
            let cellModel = if case .itemInfo = section {
                viewModel.itemInfoCells[indexPath.row]
            } else {
                viewModel.contactInfoCells[indexPath.row]
            }
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemDetailsTableViewCell.identifier,
                for: indexPath
            ) as? ItemDetailsTableViewCell
            
            cell?.configure(model: cellModel)
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].sectionTitle
    }
}
