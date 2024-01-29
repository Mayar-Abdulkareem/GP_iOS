//
//  AdminTableViewController.swift
//  GP_iOS
//
//  Created by Bassam Hillo on 26/01/2024.
//

import UIKit
import FHAlert

class AdminTableViewController: UIViewController, GradProNavigationControllerProtocol {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()

    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(
            equalToConstant: 1 / UIScreen.main.scale
        ).isActive = true
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(
            AdminTableViewCell.self,
            forCellReuseIdentifier: AdminTableViewCell.identifier
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
                searchBar,
                separatorView,
                tableView,
                footerView
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.alpha = 0
        return stackView
    }()

    let viewModel: AdminTableViewModelProtocol

    init(viewModel: AdminTableViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        startLoading()
        bindViewModel()
        viewModel.getData()
    }

    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            guard let self else { return }
            stopLoading()
            tableView.reloadData()
        }

        viewModel.onShowError = { [weak self] message in
            guard let self else { return }
            stopLoading()
            TopAlertView.show(
                title: String.LocalizedKeys.errorTitle.localized,
                subTitle: message,
                type: TopAlertType.failure
            )
        }
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addViewFillEntireView(stackView)
        configureNavBar()
        configureFooterView()
    }

    private func configureNavBar() {
        let navTitle = viewModel.getNavTitle()
        configureNavBarTitle(title: navTitle)
        addSeparatorView()
//        addNavCloseButton()
    }

    private func configureFooterView() {
        if let footerButtonTitle = viewModel.getFooterButtonTitle() {
            footerView.configure(
                primaryButtonType: .primary,
                primaryButtonTitle: footerButtonTitle
            )
        } else {
            footerView.isHidden = true
        }
    }

    private func startLoading() {
        view.showLoading(maskView: stackView)
    }

    private func stopLoading() {
        view.hideLoading()

        UIView.animate(withDuration: 0.2) {
            self.stackView.alpha = 1
        }
    }
}

extension AdminTableViewController: UITableViewDataSource,
                                    UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.cells.count

        if count == 0 {
            tableView.setEmptyView(message: "No data to show")
        } else {
            tableView.removeEmptyView()
        }

        return viewModel.cells.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminTableViewCell.identifier,
            for: indexPath
        ) as? AdminTableViewCell

        let model = viewModel.cells[indexPath.row]
        let isLastCell = indexPath.row == viewModel.cells.count - 1
        cell?.configure(
            model: model,
            isLastCell: isLastCell
        )

        return cell ?? UITableViewCell()
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Amin cell selected")
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        nil
    }
}

extension AdminTableViewController: FooterButtonViewDelegate {
    func primaryButtonTapped() {
        viewModel.primaryButtonTapped()
    }

    func secondaryButtonTapped() {
        viewModel.secondaryButtonTapped()
    }
}

extension AdminTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }
}
