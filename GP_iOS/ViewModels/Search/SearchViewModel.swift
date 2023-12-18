//
//  SearchViewModel.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

import Alamofire

class SearchViewModel {
    
    // MARK: - Variables
    
    //var page = 1
    var totalCount = 0
    var prevProjects = [PreviousProject]()
    var searchFilterModel = SearchFilterModel(page: 1, projectName: nil, projectType: [], sortByDate: nil)
    var selectedRows: [IndexPath] = []
    
    func updateFilter() {
        print("update")
        searchFilterModel.projectType = []
        searchFilterModel.sortByDate = nil
        for indexPath in selectedRows {
            switch indexPath.section {
            case 0:
                // For section 0, update sortByDate based on the row index
                if indexPath.row == 0 {
                    searchFilterModel.sortByDate = "desc"
                } else if indexPath.row == 1 {
                    searchFilterModel.sortByDate = "asc"
                }
            case 1:
                // For section 1, append projectType based on the row index
                if indexPath.row == 0 {
                    print("yes")
                    searchFilterModel.projectType.append("Software")
                } else if indexPath.row == 1 {
                    searchFilterModel.projectType.append("Hardware")
                }
                // Add more cases for additional rows if needed
            default:
                break
            }
        }
        searchFilterModel.page = 1
        fetchPrevProjects(searchFilterModel: searchFilterModel)
    }
    
    var filteredProjects = [PreviousProject]()
    var isFiltering = false
    
//    var rowsCount: Int {
//        return isFiltering ? filteredProjects.count : prevProjects.count
//    }
    
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
    
//    func searchProjects(with searchText: String) {
//        filteredProjects = prevProjects.filter { $0.name.lowercased().contains(searchText.lowercased()) }
////        onFetchPrevProjects?(FilteredPrevProjects(filteredProjects, totalCount: filteredProjects.count))
//    }
//    
//    func cancelSearch() {
//        filteredProjects = []
//    }
}
