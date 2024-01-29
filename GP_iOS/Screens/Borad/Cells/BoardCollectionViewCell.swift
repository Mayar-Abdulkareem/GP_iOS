//
//  BoardCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/01/2024.
//

import UIKit
import UniformTypeIdentifiers

protocol BoardCollectionViewCellDelegate: AnyObject {
    func taskDidUpdate(with tasks: [Task], columnID: Int)
    func taskTapped(taskModel: TaskModel)
    func addColumn()
    func deleteColumn(columnIndexPath: Int)
    func editTitle(title: String, columnIndexPath: Int)
}

class BoardCollectionViewCell: UICollectionViewCell {

    static let identifier = "boardCollectionViewCell"
    private var column: Column?
    private var columnIndexPath: Int?
    private var taskIndexPath: Int?
    weak var delegate: BoardCollectionViewCellDelegate?

    private lazy var addColumnButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String.LocalizedKeys.addColumn.localized, for: .normal)
        button.tintColor = .mySecondary
        button.addTarget(self, action: #selector(addColumnButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var titleTextFiled: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.tintColor = .mySecondary
        return textField
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .myPrimary
        tableView.separatorStyle = .none

        tableView.register(
            BoardTableViewCell.self,
            forCellReuseIdentifier: BoardTableViewCell.identifier
        )

        tableView.dragInteractionEnabled = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self

        return tableView
    }()

    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .mySecondary
        button.setTitle(String.LocalizedKeys.addCard.localized, for: .normal)
        button.addTarget(self, action: #selector(addCardButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var deleteColumnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.LocalizedKeys.deleteColumn.localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myPrimary
        view.addShadow()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {

        contentView.addViewFillEntireView(
            viewWithShadow,
            top: 8,
            bottom: 8,
            leading: 8,
            trailing: 8
        )

        viewWithShadow.addSubview(titleTextFiled)
        viewWithShadow.addSubview(tableView)
        viewWithShadow.addSubview(addTaskButton)
        viewWithShadow.addSubview(addColumnButton)
        viewWithShadow.addSubview(deleteColumnButton)

        setupEnabled(isLastCell: false)
        titleTextFiled.delegate = self

        NSLayoutConstraint.activate([
            addColumnButton.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 16),
            addColumnButton.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),

            titleTextFiled.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 16),
            titleTextFiled.centerXAnchor.constraint(equalTo: viewWithShadow.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleTextFiled.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -16),

            addTaskButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            addTaskButton.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),

            deleteColumnButton.topAnchor.constraint(equalTo: addTaskButton.bottomAnchor, constant: 8),
            deleteColumnButton.centerXAnchor.constraint(equalTo: addTaskButton.centerXAnchor),
            deleteColumnButton.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -16),
        ])
    }

    func configureCell(with column: Column?, indexPath: Int) {
        setupEnabled(isLastCell: false)
        self.column = column
        self.columnIndexPath = indexPath
        titleTextFiled.text = column?.title
        tableView.reloadData()
    }

    func addColumn() {
        setupEnabled(isLastCell: true)
    }

    private func setupEnabled(isLastCell: Bool) {
        deleteColumnButton.isHidden = isLastCell || (Role.getRole() == .supervisor)
        titleTextFiled.isHidden = isLastCell
        tableView.isHidden = isLastCell
        addTaskButton.isHidden = isLastCell || (Role.getRole() == .supervisor)
        addColumnButton.isHidden = !isLastCell || (Role.getRole() == .supervisor)
    }

    @objc private func deleteButtonTapped() {
        guard let columnIndexPath = columnIndexPath else { return }
        delegate?.deleteColumn(columnIndexPath: columnIndexPath)
    }

    @objc private func addCardButtonTapped() {
        guard let columnIndexPath = columnIndexPath else { return }
        delegate?.taskTapped(taskModel: TaskModel(viewType: .add, task: nil, columnIndexPath: columnIndexPath, taskIndexPath: taskIndexPath))
    }

    @objc func addColumnButtonTapped() {
        delegate?.addColumn()
    }
}

extension BoardCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return column?.tasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath) as? BoardTableViewCell ?? BoardTableViewCell()
        cell.configureCell(with: column?.tasks?[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskIndexPath = indexPath.row
        guard let task = column?.tasks?[indexPath.row],
              let columnIndexPath = columnIndexPath,
              let taskIndexPath = taskIndexPath else { return }
        delegate?.taskTapped(taskModel: TaskModel(viewType: .read, task: task, columnIndexPath: columnIndexPath, taskIndexPath: taskIndexPath))
    }
}

extension BoardCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = column?.tasks?[indexPath.row]
        do {
            let data = try JSONEncoder().encode(task)
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: UTType.json.identifier)
            let dragItem = UIDragItem(itemProvider: itemProvider)

            session.localContext = (self, indexPath)
            return [dragItem]
        } catch {
            print("Failed to encode task: \(error)")
            return []
        }
    }
}

extension BoardCollectionViewCell: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let dropProposal: UITableViewDropProposal
        if tableView.hasActiveDrag {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        }

        return dropProposal
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)

        for item in coordinator.items {
            item.dragItem.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.json.identifier) { (data, error) in
                DispatchQueue.main.async {
                    guard let data = data, let taskBeingMoved = try? JSONDecoder().decode(Task.self, from: data) else {
                        print("Error occurred during drop: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    tableView.performBatchUpdates({
                        // Check if the drag is from the same tableView
                        if let sourceIndexPath = item.sourceIndexPath, tableView === coordinator.session.localDragSession?.localContext as? UITableView {
                            // Move within the same tableView
                            if sourceIndexPath != destinationIndexPath {
                                self.column?.tasks?.remove(at: sourceIndexPath.row)
                                self.column?.tasks?.insert(taskBeingMoved, at: destinationIndexPath.row)
                                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                            }
                        } else {
                            // Drag from a different tableView
                            // Insert task at the destination
                            if self.column?.tasks == nil {
                                self.column?.tasks = []
                            }
                            self.column?.tasks?.insert(taskBeingMoved, at: destinationIndexPath.row)
                            tableView.insertRows(at: [destinationIndexPath], with: .automatic)

                            // Remove task from the source tableView
                            if let sourceContext = coordinator.session.localDragSession?.localContext as? (BoardCollectionViewCell, IndexPath) {
                                let (sourceCell, sourceIndexPath) = sourceContext
                                sourceCell.column?.tasks?.remove(at: sourceIndexPath.row)
                                sourceCell.tableView.deleteRows(at: [sourceIndexPath], with: .automatic)

                                // Notify the source cell's delegate about the change
                                if let columnIndexPath = sourceCell.columnIndexPath, let column = sourceCell.column {
                                    sourceCell.delegate?.taskDidUpdate(with: column.tasks ?? [], columnID: columnIndexPath)
                                }
                            }
                        }
                    }) { _ in
                        // Notify the delegate of the destination cell
                        if let columnIndexPath = self.columnIndexPath, let column = self.column {
                            self.delegate?.taskDidUpdate(with: column.tasks ?? [], columnID: columnIndexPath)
                        }
                    }
                }
            }
        }
    }
}

extension BoardCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            guard let columnIndexPath = columnIndexPath else { return }
            delegate?.editTitle(title: text, columnIndexPath: columnIndexPath)
        }
    }
}

