//
//  ProjectDetailsViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 26/01/2024.
//

import UIKit.UIImage

class ProjectDetailsViewModel {
    
    let cellsModel = [
        LabelIconCellModel(
            icon: UIImage.SystemImages.projectType.image,
            prefixText: String.LocalizedKeys.projectType.localized,
            valueText: AppManager.shared.prevProject?.projectType ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.year.image,
            prefixText: String.LocalizedKeys.year.localized,
            valueText: AppManager.shared.prevProject?.date ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.choosePeer.image,
            prefixText: String.LocalizedKeys.studentsTitle.localized,
            valueText: AppManager.shared.prevProject?.students ?? ""
        ),
        LabelIconCellModel(
            icon: UIImage.SystemImages.supervisor.image,
            prefixText: String.LocalizedKeys.supervisorTitle.localized,
            valueText: AppManager.shared.prevProject?.supervisor ?? "",
            isLastCell: true
        )
    ]
}
