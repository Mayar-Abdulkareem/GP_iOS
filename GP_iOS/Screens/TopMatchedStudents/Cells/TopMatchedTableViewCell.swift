//
//  TopMatchedTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import UIKit

struct TopMatchedCellModel {
    let peer: Peer
    let isLastCell: Bool
}

class TopMatchedTableViewCell: UITableViewCell {

    static let identifier = "TopMatchedTableViewCell"

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

    private let peerSimilarityLabel: UILabel = {
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
        contentView.addSubview(peerSimilarityLabel)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            peerIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            peerIDLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            peerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            peerNameLabel.topAnchor.constraint(equalTo: peerIDLabel.bottomAnchor, constant: 8),

            peerSimilarityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            peerSimilarityLabel.topAnchor.constraint(equalTo: peerNameLabel.bottomAnchor, constant: 8),
            peerSimilarityLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
        ])
    }

    func configureCell(with model: TopMatchedCellModel) {
        peerIDLabel.attributedText = StringManager.shared.createAttributedText(
            prefix: "Peer ID: ",
            value: model.peer.regID
        )
        peerNameLabel.attributedText = StringManager.shared.createAttributedText(
            prefix: "Peer Name: ",
            value: model.peer.name
        )
        peerSimilarityLabel.attributedText = StringManager.shared.createAttributedText(
            prefix: "Peer Similarity: ",
            value: model.peer.similarity + "%"
        )
        separatorView.isHidden = model.isLastCell
    }
}
