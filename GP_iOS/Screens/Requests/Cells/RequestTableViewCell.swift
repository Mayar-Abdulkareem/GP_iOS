//
//  RrquestTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 19/01/2024.
//

import UIKit

struct RequestCellModel {
    let peerID: String
    let peerName: String
    let isLastCell: Bool
}

class RequestTableViewCell: UITableViewCell {

    static let identifier = "RequestTableViewCell"

    private let peerIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let peerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myGray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureViews() {
        selectionStyle = .none

        contentView.addSubview(peerIDLabel)
        contentView.addSubview(peerNameLabel)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            peerIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            peerIDLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            peerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            peerNameLabel.topAnchor.constraint(equalTo: peerIDLabel.bottomAnchor, constant: 8),
            peerNameLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }

    func configureCell(with model: RequestCellModel) {
        peerIDLabel.attributedText = StringManager.shared.createAttributedText(prefix: "Peer ID: ", value: model.peerID)
        peerNameLabel.attributedText = StringManager.shared.createAttributedText(prefix: "Peer Name: ", value: model.peerName)
        separatorView.isHidden = model.isLastCell
    }
}
