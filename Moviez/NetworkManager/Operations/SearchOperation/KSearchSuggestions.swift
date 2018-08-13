//
//  SearchSuggestions.swift
//  Moviez
//
//  Created by Ankit Nandal on 09/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation

class KSearchSuggestions {
    
    private static var sharedSearchSuggestionManager: KSearchSuggestions = {
        let suggestions = KSearchSuggestions.getSearchSuggestions() as? [String]
        let searchSuggestionsObj = KSearchSuggestions(searchResults: suggestions)
        return searchSuggestionsObj
    }()
    
    var results:[String]?{
        didSet {
          self.handleResultsCount()
        }
    }

    // Initialization
    private init(searchResults:[String]?) {
     self.results = searchResults
     NotificationCenter.default.addObserver(self, selector: #selector(self.cacheSuggestions), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }

    // MARK: - Accessors
    class func shared() -> KSearchSuggestions{
        return sharedSearchSuggestionManager
    }
    
    // Hold only last 10 results.
    func handleResultsCount() {
        if let count = results?.count, count  == 11 {
            results?.removeLast()
        }
    }
    
    // Cahce suggestion array when app quits.
    @objc func cacheSuggestions() {
        guard let suggestions = results else {return}
        UserDefaults.saveToPreferences(with: "SearchSuggestions", data: suggestions)
    }
}

extension KSearchSuggestions {
    
    func saveSearchSuggestions(for term:String) {
        let searchTerm = term.lowercased()
        
        if let suggestions = results, suggestions.count > 0 {
            if results?.contains(where: {$0.caseInsensitiveCompare(searchTerm) == .orderedSame}) == true {
                results = results?.filter{$0.lowercased() != searchTerm }
            }
            results?.insert(searchTerm.capitalized, at: 0)
        } else {
            results = [searchTerm.capitalized]
        }
    }
    
    class func getSearchSuggestions() -> Any? {
        return UserDefaults.getSearchSuggestions(for: "Search")
    }
    
}


extension UserDefaults {
    static func saveToPreferences(with key:String, data:Any) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getSearchSuggestions(for key:String) -> Any?{
        return UserDefaults.standard.value(forKey: key)
    }
}
