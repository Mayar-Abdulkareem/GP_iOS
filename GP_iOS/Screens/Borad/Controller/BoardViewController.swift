//
//  BoardViewController.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 10/12/2023.
//

import UIKit
import UniformTypeIdentifiers

class BoardViewController: UIViewController {
    weak var coordinator: BoardCoordinator?
    private var viewModel = BoardViewModel()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionViewLayout.minimumLineSpacing = 16
        collectionViewLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.myLightGray
        collectionView.dragInteractionEnabled = true


        collectionView.register(
            BoardCollectionViewCell.self,
            forCellWithReuseIdentifier: BoardCollectionViewCell.identifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self

        return collectionView
    }()

    func startLoading() {
        collectionView.alpha = 0
        view.showLoading(maskView: view, hasTransparentBackground: true)
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = 1
        }
        view.hideLoading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.myPrimary
        navigationController?.showDefaultNavigationBar(
            title: String.LocalizedKeys.boardTitle.localized,
            withCloseButton: false
        )
        view.backgroundColor = UIColor.myLightGray

        bindWithViewModel()
        configureViews()
        startLoading()
        viewModel.getBoard()
    }

    private func bindWithViewModel() {
        viewModel.onShowError = { [weak self] msg in
            self?.stopLoading()
            TopAlertManager.show(title: String.LocalizedKeys.errorTitle.localized, subTitle: msg, type: .failure)
        }

        viewModel.onBoardFetched = { [weak self]  in
            self?.stopLoading()
            self?.collectionView.reloadData()
        }
    }

    private func configureViews() {
        setupBackButton()
        setupSaveButton()

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func setupBackButton() {
        self.navigationItem.hidesBackButton = true

        let newBackButton = UIBarButtonItem(title: String.LocalizedKeys.backButtonTitle.localized, style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    private func setupSaveButton() {
        let clearButton = UIBarButtonItem(
            title: String.LocalizedKeys.saveTitle.localized,
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = clearButton
    }

    func showUnsavedChangesAlert() {
        let alert = UIAlertController(
            title: String.LocalizedKeys.discardChanges.localized,
            message: String.LocalizedKeys.discardChangesMessage.localized,
            preferredStyle: .alert
        )

        let discardAction = UIAlertAction(title: String.LocalizedKeys.discard.localized, style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(discardAction)

        let cancelAction = UIAlertAction(title: String.LocalizedKeys.cancel.localized, style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    @objc func saveButtonTapped() {
        startLoading()
        viewModel.saveBoard()
        viewModel.hasUnsavedChanges = false
    }

    @objc func backButtonPressed() {
        if viewModel.hasUnsavedChanges {
            showUnsavedChangesAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension BoardViewController: UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return (viewModel.board?.columns?.count ?? 0) + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BoardCollectionViewCell.identifier,
            for: indexPath
        ) as? BoardCollectionViewCell ?? BoardCollectionViewCell()
        // Check if the current cell is the last cell (for "Add Column" button)
        if indexPath.row == viewModel.board?.columns?.count {
            // This is the last cell, which should show the "Add Column" button
            cell.addColumn()
        } else {
            // This is a regular column cell
            cell.configureCell(with: viewModel.board?.columns?[indexPath.row], indexPath: indexPath.row)
        }
        cell.delegate = self
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let cellWidth = collectionView.bounds.width - 32
        let cellHeight = collectionView.bounds.height - 32
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//extension BoardViewController: UICollectionViewDragDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        guard let column = viewModel.board?.columns?[indexPath.item] else {
//            return []
//        }
//
//        do {
//            let data = try JSONEncoder().encode(column)
//            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: UTType.json.identifier)
//            let dragItem = UIDragItem(itemProvider: itemProvider)
//
//            let removeColumnClosure: (Column) -> Void = { [weak self] column in
//                self?.viewModel.board?.columns?.remove(at: indexPath.item)
////                self?.viewModel.removeColumnByID(with: column.id)
//            }
//
//            session.localContext = (collectionView, indexPath, removeColumnClosure)
//
//            return [dragItem]
//        } catch {
//            print("Failed to encode column: \(error)")
//            return []
//        }
//    }
//}
//
//extension BoardViewController: UICollectionViewDropDelegate {
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        guard let destinationIndexPath = coordinator.destinationIndexPath else {
//            print("Destination index path is nil.")
//            return
//        }
//
//        for item in coordinator.items {
//            item.dragItem.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.json.identifier) { (data, error) in
//                DispatchQueue.main.async {
//                    guard let data = data,
//                          let columnBeingMoved = try? JSONDecoder().decode(Column.self, from: data) else {
//                        print("Error occurred during drop: \(error?.localizedDescription ?? "Unknown error")")
//                        return
//                    }
//
//                    if let sourceContext = coordinator.session.localDragSession?.localContext as? (UICollectionView, IndexPath, (Column) -> Void),
//                       sourceContext.0 == collectionView {
//                        // Reordering within the same collection view
//                        let sourceIndex = sourceContext.1.item
//                        self.viewModel.board?.columns?.remove(at: sourceIndex)
//                        self.viewModel.board?.columns?.insert(columnBeingMoved, at: destinationIndexPath.item)
//                        collectionView.performBatchUpdates({
//                            collectionView.moveItem(at: IndexPath(item: sourceIndex, section: 0), to: destinationIndexPath)
//                        }, completion: nil)
//                    }
//                }
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        let intent: UICollectionViewDropProposal.Intent
//        if let indexPath = destinationIndexPath, collectionView.cellForItem(at: indexPath) != nil {
//            intent = .insertAtDestinationIndexPath
//        } else {
//            intent = .insertIntoDestinationIndexPath
//        }
//
//        return UICollectionViewDropProposal(operation: session.localDragSession == nil ? .copy : .move, intent: intent)
//    }
//}

extension BoardViewController: BoardCollectionViewCellDelegate {
    func editTitle(title: String, columnIndexPath: Int) {
        viewModel.board?.columns?[columnIndexPath].title = title
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
    
    func deleteColumn(columnIndexPath: Int) {
        viewModel.board?.columns?.remove(at: columnIndexPath)
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
    
    func taskTapped(taskModel: TaskModel) {
        coordinator?.showTaskViewController(taskModel: taskModel)
    }
    
    func taskDidUpdate(with tasks: [Task], columnID indexPath: Int) {
        viewModel.board?.columns?[indexPath].tasks = tasks
        viewModel.hasUnsavedChanges = true
    }

    func addColumn() {
        guard let columns = viewModel.board?.columns else { return }
        viewModel.board?.columns?.append(Column(title: "Column \(columns.count + 1)", tasks: []))
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
}

extension BoardViewController: TaskViewControllerDelegate {
    func editTask(task: Task, taskIndexPath: Int, columnIndexPath: Int) {
        viewModel.board?.columns?[columnIndexPath].tasks?[taskIndexPath] = task
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
    
    func deleteTask(taskIndexPath: Int, columnIndexPath: Int) {
        viewModel.board?.columns?[columnIndexPath].tasks?.remove(at: taskIndexPath)
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
    
    func addTask(task: Task, columnIndexPath: Int) {
        viewModel.board?.columns?[columnIndexPath].tasks?.append(task)
        collectionView.reloadData()
        viewModel.hasUnsavedChanges = true
    }
}
