//
//  HeaderCollectionViewCell.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 15/12/2023.
//

import UIKit

class AboutCourseCell: UICollectionViewCell {
    static let identifier = "aboutCourseCellIdentifire"

    private let courseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let courseDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.myPrimary
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        fillText()
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fillText()
        configureViews()
    }

    func fillText() {
        switch Role.getRole() {
        case .student:
            if let course = AppManager.shared.course {
                courseLabel.text = course.courseName
                descriptionLabel.text = "Course ID: " + course.courseID + "\nSpervisor: " + course.supervisorName
            }
        default:
            if let course = AppManager.shared.courseStudents {
                courseLabel.text = course.courseName
                descriptionLabel.text = "Course ID: " + course.courseID
            }
        }
    }

    private func configureViews() {
        backgroundColor = .myPrimary
        addViewWithConstant(courseDetailView, constant: 8)
        courseDetailView.addSubview(courseLabel)
        courseDetailView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            courseLabel.leadingAnchor.constraint(equalTo: courseDetailView.leadingAnchor),
            courseLabel.trailingAnchor.constraint(equalTo: courseDetailView.trailingAnchor),
            courseLabel.centerYAnchor.constraint(equalTo: courseDetailView.centerYAnchor, constant: -10),
            courseLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionLabel.leadingAnchor.constraint(equalTo: courseDetailView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: courseDetailView.trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: courseDetailView.centerYAnchor, constant: 20)
        ])
    }
}
