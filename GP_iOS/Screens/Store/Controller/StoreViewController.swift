//
//  StoreViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 27/11/2023.
//

import UIKit

class StoreViewController: UIViewController {

    weak var coordinator: StoreCoordinator?
    private var viewModel: StoreViewModel = StoreViewModel()

    private let mainView: UIView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search by Item Name"
        searchBar.layer.borderWidth = 0
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .mySecondary

        searchBar.delegate = self

        return searchBar
    }()

    private lazy var addButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.gray

        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.viewType = .addItem
            self.viewModel.page = .itemInfo
            self.viewModel.state = .edit
            
            let addEditViewModel = StoreItemAddEditViewModel(viewType: .add, item: Item(id: "", quantity: "1.0", showPhoneNumber: false))
            let vc = StoreItemAddEditViewController(viewModel: addEditViewModel)
            vc.delegate = self
            let navCont = UINavigationController(rootViewController: vc)
            navigationController?.present(navCont, animated: true)
        }, for: .primaryActionTriggered)

        return button
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(
            items: [
                String.LocalizedKeys.allItemsTitle.localized,
                String.LocalizedKeys.myItemsTitle.localized
            ]
        )
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.isHidden = (viewModel.viewType == .addItem)

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mySecondary]
        segmentControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(textAttributes, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return segmentControl
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .myPrimary

        collectionView.register(
            StoreCollectionViewCell.self,
            forCellWithReuseIdentifier: StoreCollectionViewCell.identifier
        )
        collectionView.register(
            FooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterView.identifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

        return collectionView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myPrimary
        configureViews()
        bindWithViewModel()
    }

    func startLoading() {
        self.collectionView.alpha = 0
        self.view.showLoading(maskView: self.view, hasTransparentBackground: true)
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = 1
        }
        self.view.hideLoading()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            DispatchQueue.main.async {
                TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
                self?.segmentControl.isEnabled = true
                self?.searchBar.isEnabled = true
            }
        }

        viewModel.onItemFetched = { [weak self] noItems in
            self?.stopLoading()
            DispatchQueue.main.async {
                if noItems {
                    self?.collectionView.setEmptyView(message: String.LocalizedKeys.noItemsMsg.localized)
                } else {
                    self?.collectionView.removeEmptyView()
                }
                self?.collectionView.reloadData()
                self?.segmentControl.isEnabled = true
                self?.searchBar.isEnabled = true
            }
        }
    }

    private func configureViews() {
        view.addSubview(searchBar)
        view.addSubview(addButton)
        view.addSubview(segmentControl)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            addButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -8),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalTo: searchBar.heightAnchor),
            addButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),

            segmentControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 35),

            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        segmentControl.isEnabled = false
        searchBar.isEnabled = false

        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.storeFilterModel.regID = nil
        case 1:
            viewModel.storeFilterModel.regID = AuthManager.shared.regID
        default:
            break
        }

        viewModel.storeFilterModel.page = 1
        startLoading()
        viewModel.fetchItems()
    }
}

extension StoreViewController: UICollectionViewDelegate, 
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoreCollectionViewCell.identifier,
            for: indexPath
        ) as? StoreCollectionViewCell
        cell?.configureCell(model: viewModel.getStoreCellModel(index: indexPath.item))

        if (indexPath.item == viewModel.items.count - 1) && (indexPath.item < (viewModel.totalItemsCount - 1)) {
            /// Check if the current item is the last one and it is loading
            viewModel.isLastResult = false
            viewModel.storeFilterModel.page += 1
            viewModel.fetchItems()
        } else if (indexPath.item == viewModel.items.count - 1) && (indexPath.item >= viewModel.totalItemsCount - 1) {
            /// Check if the current item is the last one and there are no more pages
            viewModel.isLastResult = true
        }

        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 16) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppManager.shared.item = viewModel.items[indexPath.row]
        let viewModel = ItemDetailsViewModel(item: viewModel.items[indexPath.row])
        let viewController = StoreItemDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView ?? FooterView()
        if viewModel.isLastResult {
            footer.setFooterLabelTitle(text: String.LocalizedKeys.noMoreResultsMsg.localized)
        } else {
            footer.startLoading()
        }

        return footer
    }

    private func refresh() {
        viewModel.storeFilterModel.page = 1
        startLoading()
        viewModel.fetchItems()
    }
}

extension StoreViewController: ItemDetailsDelegate {
    func refreshMyItems() {
        refresh()
    }
}

extension StoreViewController: ItemAddedOrUpdatedDelegate {
    func itemAddedOrUpdated() {
        refresh()
    }
}

extension StoreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.storeFilterModel.page = 1
        viewModel.storeFilterModel.title = searchText.isEmpty ? nil : searchText
        startLoading()
        viewModel.fetchItems()
    }
}
