//
//  SearchSuggestionViewModel.swift
//  Moviez
//
//  Created by Ankit Nandal on 09/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation

class SearchSuggestionViewModel {
    
    private var results:[String]? {
        return KSearchSuggestions.shared().results
    }
    
    func numberOfCells() -> Int {
        return results?.count ?? 0
    }
    
    func cellItems(indexPath:IndexPath) -> String? {
        return results?[indexPath.row]
    }
    
    func itemAtIndex(indexPath:IndexPath) -> String?{
      return results?[indexPath.row]
    }
}
