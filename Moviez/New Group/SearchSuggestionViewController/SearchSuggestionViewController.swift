//
//  SearchSuggestionViewController.swift
//  Moviez
//
//  Created by Ankit Nandal on 09/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit

protocol SearchSuggestionDelegate: class {
    func didTappedSearchSuggestion(with text:String)
}

class SearchSuggestionViewController: ParentViewController {
    
    var searchSuggestionViewModel:SearchSuggestionViewModel!
    
    weak var delegate:SearchSuggestionDelegate?
    
    
    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigs()
    }
    
    func showSuggestions() {
        self.tableView.reloadData()
    }
    
    func initialConfigs() {
        initNBindViewModel ()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchSuggestionCellIdentifier)
    }
    
    func initNBindViewModel () {
        searchSuggestionViewModel = SearchSuggestionViewModel()
    }
}

extension SearchSuggestionViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionCellIdentifier, for: indexPath)
        cell.contentView.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .gray
        cell.textLabel?.text = searchSuggestionViewModel.cellItems(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSuggestionViewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let term = searchSuggestionViewModel.itemAtIndex(indexPath: indexPath) else {return}
      delegate?.didTappedSearchSuggestion(with: term)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

fileprivate let SearchSuggestionCellIdentifier = "SearchSuggestionCell"
