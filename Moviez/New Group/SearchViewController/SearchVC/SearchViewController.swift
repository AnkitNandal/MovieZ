//
//  SearchViewController.swift
//  Moviez
//
//  Created by Ankit Nandal on 04/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    /** Search Controller which is used for searching.
     */
    fileprivate lazy var searchController = { () -> UISearchController in
        let searchSuggestionViewController = UIStoryboard.searchSuggestionViewController()
        searchSuggestionViewController.delegate = self
        let sc = UISearchController(searchResultsController: searchSuggestionViewController)
        sc.searchBar.placeholder = Constants.searchPlaceHolder
        sc.searchResultsUpdater = self;
        sc.searchBar.barTintColor = .black
        sc.searchBar.barStyle = .default
        sc.searchBar.delegate = self
        return sc
    }()
    
    /** SearchViewModel which holds all data manipulation/show logic.
     */
    var searchViewModel:SearchViewModel!
    
    
    //MARK:- ViewController Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SearchViewController {
    /**
     All intitlization which are required at controller loading.
     */
    func initialConfigs() {
        initNBindViewModel()
        setupSearchBar()
        setupNavBar()
        setupTableView()
    }
    
    /**
     Setup Table view.
     */
    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: MovieListCell.xib, bundle: nil), forCellReuseIdentifier: MovieListCell.identifier)
    }
    
    /**
     Setup Search Bar.
     */
    func setupSearchBar() {
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    /**
     Bind View Model to Controller to receive callbacks.
     */
    func initNBindViewModel () {
        searchViewModel = SearchViewModel()
        
        // Called when search results are fetched
        searchViewModel.searchCompletionBlock = {[weak self] success,errorText in
            self?.tableView.reloadData()
            if success {
            } else {
                self?.showAlert(with: errorText)
            }
        }
        
        // Called when UI needs to be refreshed
        searchViewModel.refreshCallback = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /**
     Setup Navigation Bar.
     */
    func setupNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.topItem?.title = Constants.searchControllerNavigationTitle
    }
}

// MARK: - Table view data source and delegate
extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        searchViewModel.shouldFetchMorePages(with: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as! MovieListCell
        if let info = searchViewModel.cellItems(indexPath: indexPath) {
            cell.config(info: info)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.numberOfCells()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}



//MARK: SEARCH BAR DELEGATE
extension SearchViewController : UISearchBarDelegate,UISearchResultsUpdating,SearchSuggestionDelegate {
    
    func didTappedSearchSuggestion(with text: String) {
        getDataFromSearchTerm(text: text)
        searchController.isActive = false
        searchController.searchBar.text = text
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        (searchController.searchResultsController as? SearchSuggestionViewController)?.showSuggestions()
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
        let searchText = searchBar.text
        getDataFromSearchTerm(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
    }
    
    private func getDataFromSearchTerm(text:String?) {
        searchViewModel.fetchMovieResults(with: text)
        searchController.isActive = false
    }
}
