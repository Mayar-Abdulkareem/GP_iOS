//
//  BoardTableViewCell.swift
//  GP_iOS
//
//  Created by FTS on 06/01/2024.
//

import UIKit

class BoardTableViewCell: UITableViewCell {

    static let identifier = "boardTableViewCell"

    private var task: Task?

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .myAccent
        textField.isEnabled = false
        return textField
    }()

    private let viewWithShadow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow()
        view.backgroundColor = .myPrimary
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        selectionStyle = .none
        
        contentView.addViewFillEntireView(
            viewWithShadow,
            top: 8,
            bottom: 8,
            leading: 16,
            trailing: 16
        )
        viewWithShadow.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: viewWithShadow.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: viewWithShadow.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: viewWithShadow.topAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: viewWithShadow.bottomAnchor, constant: -16)
        ])
    }

    func configureCell(with task: Task?) {
        self.task = task
        textField.text = task?.title
    }
}
