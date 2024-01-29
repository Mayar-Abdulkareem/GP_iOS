//
//  ProjectViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class CourseViewController: UIViewController, GradProNavigationControllerProtocol {
    weak var coordinator: CourseCoordinator?
    var viewModel: HomeViewModelProtocol?

    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.myPrimary
        collectionView.register(
            CourseCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseCollectionViewCell.identifier
        )
        collectionView.register(AboutCourseCell.self, forCellWithReuseIdentifier: AboutCourseCell.identifier)
        return collectionView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configureViews()
    }

    /// Make sure when I navigate back no cell is selected hence no gray color
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedIndexPaths {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }

    private func configureViews() {
        view.backgroundColor = UIColor.myPrimary
        
        addBackButton()
        view.addViewWithConstant(collectionView, constant: 8)
        addNavBar(with: String.LocalizedKeys.courseTitle.localized)
    }
}

extension CourseViewController: UICollectionViewDelegate, 
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.getCoursesCellsModel().count ?? 0) + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if indexPath.item == 0 {
            let headerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AboutCourseCell.identifier,
                for: indexPath
            ) as? AboutCourseCell ?? AboutCourseCell()
            return headerCell
        } else {
            let courseCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CourseCollectionViewCell.identifier,
                for: indexPath
            ) as? CourseCollectionViewCell ?? CourseCollectionViewCell()
            courseCell.configureCell(model: viewModel?.getCoursesCellsModel()[indexPath.item - 1])
            return courseCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 1:
            coordinator?.showBoardFlow()
        case 2:
            coordinator?.showAssignmentsViewController()
        case 3:
            coordinator?.showRequestsViewController()
        case 4:
            coordinator?.showPeerFlow()
        default:
            print("Something Is Wrong")
        }

        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedIndexPaths {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width, height: 80)
        } else {
            let cellWidth = (collectionView.bounds.width) / 2
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
}
