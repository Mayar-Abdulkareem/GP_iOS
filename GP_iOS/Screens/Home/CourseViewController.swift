//
//  ProjectViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit

class CourseViewController: UIViewController {
    weak var coordinator: CourseCoordinator?

    private let courseCollectionViewCell = [
        CourseCollectionViewCellModel(title: String.LocalizedKeys.choosePeerTitle.localized, icon: UIImage.SystemImages.choosePeer.image),
        CourseCollectionViewCellModel(title: String.LocalizedKeys.boardTitle.localized, icon: UIImage.SystemImages.board.image),
        CourseCollectionViewCellModel(title: String.LocalizedKeys.submissionTitle.localized, icon: UIImage.SystemImages.submission.image),
    ]

    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.myLightGray
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: CourseCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
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
        view.backgroundColor = UIColor.myLightGray
        addViews()
        addConstraints()
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

    private func addViews() {
        view.addSubview(collectionView)
    }

    private func addConstraints() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /// Set tableView constraints
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
}

extension CourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseCollectionViewCell.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as! HeaderCollectionViewCell
            return headerCell
        } else {
            let courseCell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.identifier, for: indexPath) as! CourseCollectionViewCell
            courseCell.configureCell(model: courseCollectionViewCell[indexPath.item - 1])
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
