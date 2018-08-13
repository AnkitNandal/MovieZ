//
//  SearchViewModel.swift
//  Moviez
//
//  Created by Ankit Nandal on 09/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    /** Network adapter: It handles all network related tasks.
     */
    var networkAdapter:kNetworkAdapter!
    
    
    /** Model that holds movie data
     */
    var movieInfoModel:MovieInfo?
    
    
    /** Callback for completion of search result
     */
    var searchCompletionBlock: ((_ success:Bool,_ errorText:String?) -> Void)?
    
    /** Callback for refreshing of UI.
     */
    var refreshCallback: (() -> Void)?

    
    /** Pagination limit offset. Default is 6.
     */
    var limit:Int = 6
    
    
    /** Holds last searched term
     */
    var lastSearchTerm:String? {
        didSet{
            // For a new search, clean model.
            if oldValue != lastSearchTerm {
                self.movieInfoModel = nil
                refreshCallback?()
            }
        }
    }
    
    // MARK: - Initilizer
    init() {
        networkAdapter = kNetworkAdapter()
    }
    
    
    /**
     It fetches movies data related to the search term provided.
     
     - Parameters:
     - term: search term against which movies will be fetched
     */
    func fetchMovieResults(with term:String?) {
        
        guard let searchTerm = term  else {self.searchCompletionBlock?(true, nil);return }
        
        lastSearchTerm = searchTerm
        
        let pageHandler = getPageNumber()
        if pageHandler.lastPageReached {
            return
        }
        
        ApplicationSetup.shared.shouldShowNetworkActivity(true)
        networkAdapter.getMoviesSearchResult(searchTerm: searchTerm, pageNo: pageHandler.pageNo) {[weak self] (response, error) in
            ApplicationSetup.shared.shouldShowNetworkActivity(false)
            self?.handleSearchResult(data: response, isError: error)
        }
    }
    
    /**
     It handles response of search.
     
     - Parameters:
     - data: Search response that is received from API.
     - isError: Whether there is anuy error or not.
     
     */
    private func handleSearchResult(data:Any?,isError:Bool) {
        if let movieData = data as? MovieInfo, let totalCount = movieData.totalResults, totalCount > 0 {
            self.appendMovieList(data: movieData)
            DispatchQueue.main.async {
                self.searchCompletionBlock?(true, nil)
            }
        } else if let totalResult = (data as? MovieInfo)?.totalResults, totalResult == 0 {
            DispatchQueue.main.async {
                
                self.searchCompletionBlock?(false, Constants.Alert.noMoviesResultFound)
            }
        } else {
            DispatchQueue.main.async {
                self.searchCompletionBlock?(false, Constants.Alert.somethingWrong)
            }
        }
    }
    
    /**
     It handles response and takes appropriate action whether to refresh data model or add results to existing movie model in case it is via pagination.
     
     - Parameters:
     - data: Search response that is received from API.
     */
    private func appendMovieList(data:MovieInfo) {
        if self.movieInfoModel == nil {
            self.movieInfoModel = data
        } else {
            self.movieInfoModel?.page = data.page
            if let moreResults = data.results {
                self.movieInfoModel?.results?.append(contentsOf: moreResults)
            }
        }
    }
    
    /**
     It handles pagination logic whether we need to fetch more pages or not.
     
     - Returns:
     - pageNo: Page number to be fetched.
     -lastPageReached: Whether last page reached and we should shtop fetching for more pages.
     */
    private func getPageNumber() -> (pageNo:Int,lastPageReached:Bool) {
        if let page = self.movieInfoModel?.page , let totalPage = self.movieInfoModel?.totalPages {
            if page < totalPage {
                return (page + 1,false)
            }
            return (0,true)
        }
        return (1,false)
    }
    
    
    /**
     It tells when to trigger for more pages.
     
     - Parameters:
     - index: Which index path should trigger more fetching.
     */
    func shouldFetchMorePages(with index:IndexPath) {
        if index.row == (numberOfCells() - limit) {
            fetchMovieResults(with: lastSearchTerm)
        }
    }
}



// Search View Controller Data Source
extension SearchViewModel {
    func numberOfCells() -> Int{
        return movieInfoModel?.results?.count ?? 0
    }
    
    func cellItems(indexPath:IndexPath) -> MovieList? {
        return movieInfoModel?.results?[indexPath.row]
    }
}
