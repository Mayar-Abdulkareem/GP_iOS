//
//  StoreItemDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit

class StoreItemDetailsViewController: UIViewController, GradProNavigationControllerProtocol {

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
        tableView.delegate = self
        
        return tableView
    }()
    
    var canShowEditButton: Bool {
        return (AppManager.shared.item?.regID == AuthManager.shared.regID)
    }
    
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
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        addNavBar(with: viewModel.item.title)
        addNavRightButton(title: "Edit",
                          completion: {
            [weak self] in
            
            let storeItem = AppManager.shared.item
            let item = Item(
                id: storeItem?.id ?? "",
                title: storeItem?.title,
                price: storeItem?.price,
                location: storeItem?.location,
                quantity: storeItem?.quantity,
                showPhoneNumber: storeItem?.showPhoneNumber
            )
            let addEditViewModel = StoreItemAddEditViewModel(viewType: .edit, item: item)
            let vc = StoreItemAddEditViewController(viewModel: addEditViewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

extension StoreItemDetailsViewController: UITableViewDataSource,
                                          UITableViewDelegate {
    
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
            
            let model = ItemDetailsImageCellModel(
                imageString: viewModel.itemImageURLString,
                isEditable: false
            )
            cell?.configure(model: model)
            
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < (viewModel.sections.count - 1) {
            let separatorView = UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: tableView.frame.width,
                    height: 1 / UIScreen.main.scale
                )
            )
            separatorView.backgroundColor = .separator
            return separatorView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section < (viewModel.sections.count - 1) ? 1 / UIScreen.main.scale : 0.0
    }
}
