//
//  SearchViewModel.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 16/12/2023.
//

import Alamofire
import UIKit

class SearchViewModel {

    // MARK: - Variables

    private(set) var totalPrevProjectsCount = 0
    private(set) var prevProjects = [PreviousProject]()
    var categories: [(String, [String])] = [(CategoryType.date.rawValue, DateOptions.allCases.map { $0.rawValue })]
    var searchFilterModel = SearchFilterModel(page: 1, projectName: nil, projectType: [], sortByDate: nil)
    var selectedFilterRows: [IndexPath] = []
    var previousSelection: [IndexPath] = []
    var isLastResult = false

    // MARK: - Call Backs

    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch previous projects completed successfully
    var onPreviousProjectsFetched: ((_ noPrevProject: Bool) -> Void)?

    // MARK: - Computed properties
    var getFilterButtonIcon: UIImage {
        if selectedFilterRows.isEmpty {
            return UIImage.SystemImages.filter.image
        } else {
            return UIImage.SystemImages.filterFill.image
        }
    }

    // MARK: - Methods

    /// Fetch all types of the previous projects
    func fetchProjectTypes() {
        let route = SearchRouter.getProjectTypes
        BaseClient.shared.performRequest(router: route, type: [String].self) { [weak self] result in
            switch result {
            case .success(let types):
                guard let self = self else { return }
                self.categories.append((CategoryType.type.rawValue, types))
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    /// Fetch previous projects
    func fetchPrevProjects() {
        let route = SearchRouter.getPrevProjects(searchFilterModel: searchFilterModel)
        BaseClient.shared.performRequest(router: route, type: ProjectResponse.self) { [weak self] result in
            switch result {
            case .success(let prevProjects):
                if self?.searchFilterModel.page == 1 {
                    self?.prevProjects = prevProjects.previousProjects
                } else {
                    self?.prevProjects += prevProjects.previousProjects
                }
                self?.totalPrevProjectsCount = prevProjects.totalCount
                if self?.prevProjects.count == 0 {
                    self?.onPreviousProjectsFetched?(true)
                } else {
                    self?.onPreviousProjectsFetched?(false)
                }
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }

    /// Static Filtering
    func updateFilter() {
        searchFilterModel.projectType = []
        searchFilterModel.sortByDate = nil
        for indexPath in selectedFilterRows {
            switch indexPath.section {
            case 0:
                /// For section 0, update sortByDate based on the row index
                if indexPath.row == 0 {
                    searchFilterModel.sortByDate = SortType.desc.rawValue
                } else if indexPath.row == 1 {
                    searchFilterModel.sortByDate = SortType.asc.rawValue
                }
            case 1:
                /// For section 1, append projectType based on the row index
                searchFilterModel.projectType.append(categories[1].1[indexPath.row])
            default:
                break
            }
        }
        searchFilterModel.page = 1
    }
}
