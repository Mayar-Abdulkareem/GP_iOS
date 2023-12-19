//
//  SearchViewModel.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

import Alamofire

class SearchViewModel {
    
    // MARK: - Variables
    
    var totalPagesCount = 0
    var prevProjects = [PreviousProject]()
    var searchFilterModel = SearchFilterModel(page: 1, projectName: nil, projectType: [], sortByDate: nil)
    var selectedFilterRows: [IndexPath] = []
    var isSearching = false
    var isLastResult = false
    
    // MARK: - Call Backs
    
    /// If error happens
    var onShowError: ((_ msg: String) -> Void)?
    /// If the fetch previous projects completed successfully
    var onFetchPrevProjects: ((ProjectResponse) -> ())?
    
    // MARK: - UseCases
    
    /// UseCase for fetching previous projects
    private let fetchPrevProjects = FetchPrevProjectsUseCase()
    
    // MARK: - Methods
    
    /// Fetch previous projects
    func fetchPrevProjects(searchFilterModel: SearchFilterModel) {
        print(searchFilterModel)
        fetchPrevProjects.execute(searchFilterModel: searchFilterModel) { [weak self] result in
            switch result {
            case .success(let prevProjects):
                self?.onFetchPrevProjects?(prevProjects)
            case .failure(let error):
                self?.onShowError?(error.localizedDescription)
            }
        }
    }
    
    /// Static Filtering
    func updateFilter() {
        searchFilterModel.projectType = []
        searchFilterModel.sortByDate = nil
        //isFiltering = (selectedRows.isEmpty)
        for indexPath in selectedFilterRows {
            switch indexPath.section {
            case 0:
                /// For section 0, update sortByDate based on the row index
                if indexPath.row == 0 {
                    searchFilterModel.sortByDate = "desc"
                } else if indexPath.row == 1 {
                    searchFilterModel.sortByDate = "asc"
                }
            case 1:
                /// For section 1, append projectType based on the row index
                if indexPath.row == 0 {
                    searchFilterModel.projectType.append("Software")
                } else if indexPath.row == 1 {
                    searchFilterModel.projectType.append("Hardware")
                }
            default:
                break
            }
        }
        searchFilterModel.page = 1
        fetchPrevProjects(searchFilterModel: searchFilterModel)
    }
}
