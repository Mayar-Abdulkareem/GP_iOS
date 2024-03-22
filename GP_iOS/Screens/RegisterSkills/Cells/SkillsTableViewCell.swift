//
//  SkillsTableViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 02/01/2024.
//

import UIKit

protocol SkillsTableViewCellDelegate: AnyObject {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView, section: Int?) -> Void
}

class SkillsTableViewCell: UITableViewCell {

    static let identifier = "skillTableViewCellIdentifire"

    var delegate: SkillsTableViewCellDelegate?
    var section: Int?

    private lazy var tagsView = {
        let view = TagListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tagBackgroundColor = UIColor.myPrimary
        view.textColor = UIColor.myAccent
        view.textFont = UIFont.systemFont(ofSize: 14)
        view.cornerRadius = 8
        view.addShadow()
        view.alignment = .leading
        view.tagSelectedBackgroundColor = .mySecondary
        view.paddingX = 9
        view.paddingY = 8
        view.marginX = 6
        view.marginY = 6

        view.delegate = self

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        tagsView.delegate = self
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
        configureViews()
    }

    private func configureViews() {
        backgroundColor = .myPrimary
        contentView.addViewFillEntireView(
            tagsView,
            top: 8,
            bottom: 8,
            leading: 16,
            trailing: 16
        )
    }

    func configureCell(skills: [Skills], section: Int) {
        tagsView.removeAllTags()
        tagsView.addTags(skills)
        self.section = section
    }
}

extension SkillsTableViewCell: TagListViewDelegate {
    @objc func  tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        delegate?.tagPressed(title, tagView: tagView, sender: sender, section: section)
    }
}
