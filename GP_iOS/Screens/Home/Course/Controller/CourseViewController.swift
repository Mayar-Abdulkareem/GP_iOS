//
//  ProjectViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class CourseViewController: UIViewController {
    weak var coordinator: CourseCoordinator?
    var viewModel: HomeViewModel?

    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.myLightGray
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.identifier)
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
        navigationController?.showDefaultNavigationBar(title: String.LocalizedKeys.courseTitle.localized, withCloseButton: true)
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
        view.backgroundColor = UIColor.myLightGray
        
        view.addViewWithConstant(collectionView, constant: 8)
    }
}

extension CourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.courseCollectionViewCell.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: AboutCourseCell.identifier, for: indexPath) as! AboutCourseCell
            return headerCell
        } else {
            let courseCell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
            courseCell.configureCell(model: viewModel?.courseCollectionViewCell[indexPath.item - 1])
            return courseCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 1:
            coordinator?.showPeerViewController()
        case 2:
            coordinator?.showBoardViewController()
        case 3:
            coordinator?.showSubmissionsViewController()
        default:
            print("Something Is Wrong")
        }

        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedIndexPaths {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width, height: 80)
        } else {
            let cellWidth = (collectionView.bounds.width) / 2
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
}
