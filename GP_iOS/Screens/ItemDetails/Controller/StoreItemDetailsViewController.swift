//
//  StoreItemDetailsViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 13/01/2024.
//

import UIKit
import FHAlert

protocol ItemDetailsDelegate: AnyObject {
    func refreshMyItems()
}

class StoreItemDetailsViewController: UIViewController, GradProNavigationControllerProtocol {

    weak var delegate: ItemDetailsDelegate?

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

    lazy var footerView: FooterButtonView = {
        let footerView = FooterButtonView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        return footerView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                tableView,
                footerView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.alpha = 1
        return stackView
    }()
    
    let viewModel: ItemDetailsViewModel
    
    init(viewModel: ItemDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindWithViewModel()
        configureViews()
    }

    private func configureFooterView() {
        if let footerButtonTitle = viewModel.getFooterButtonTitle() {
            footerView.configure(
                primaryButtonType: .delete,
                primaryButtonTitle: footerButtonTitle
            )
        } else {
            footerView.isHidden = true
        }
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            DispatchQueue.main.async {
                TopAlertView.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: TopAlertType.failure)
            }
        }

        viewModel.onItemDeleted = { [weak self] in
            self?.stopLoading()
            self?.delegate?.refreshMyItems()
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }

    private func startLoading() {
        stackView.isHidden = true
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    private func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.stackView.isHidden = false
        }
        view.hideLoading()
    }

    private func configureViews() {
        view.backgroundColor = .myPrimary

        configureFooterView()
        view.addViewFillEntireView(stackView)

        addNavBar(with: viewModel.item.title)
        addBackButton()

        if viewModel.isMyItem {
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
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
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

extension StoreItemDetailsViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        startLoading()
        viewModel.deleteItem()
    }
}

extension StoreItemDetailsViewController: ItemAddedOrUpdatedDelegate {
    func itemAddedOrUpdated() {
        delegate?.refreshMyItems()
    }
}
