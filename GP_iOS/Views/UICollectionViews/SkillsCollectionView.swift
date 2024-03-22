////
////  SkillsCollectionView.swift
////  GP_iOS
////
////  Created by Mayar Abdulkareem on 02/01/2024.
////
//
//import UIKit
//
//class SkillsCollectionView: UICollectionView {
//    var categoriesWithSkills: [(category: String, skills: [String])] = [] {
//        didSet {
//            reloadData()
//        }
//    }
//
//    init(skills: [(category: String, skills: [String])]) {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        super.init(frame: .zero, collectionViewLayout: layout)
//        self.categoriesWithSkills = skills
//        contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        layout.minimumInteritemSpacing = 8
//        configure()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configure() {
//        register(SkillCollectionViewCell.self, forCellWithReuseIdentifier: SkillCollectionViewCell.identifier)
//        register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
//        dataSource = self
//        delegate = self
//        backgroundColor = .none
//    }
//}
//
//extension SkillsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return categoriesWithSkills.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categoriesWithSkills[section].skills.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = dequeueReusableCell(withReuseIdentifier: SkillCollectionViewCell.identifier, for: indexPath) as! SkillCollectionViewCell
//        let skills = categoriesWithSkills[indexPath.section].skills
//        cell.configureCell(with: skills[indexPath.item])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let skill = categoriesWithSkills[indexPath.section].skills[indexPath.item]
//        let cellWidth = skill.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 25
//        return CGSize(width: cellWidth, height: 44)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader else {
//            return UICollectionReusableView()
//        }
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeaderView.reuseIdentifier, for: indexPath) as? CategoryHeaderView ?? CategoryHeaderView()
//
//        let category = categoriesWithSkills[indexPath.section].category
//        headerView.titleLabel.text = category
//
//        return headerView
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 50) // Adjust the height as needed
//    }
//}
