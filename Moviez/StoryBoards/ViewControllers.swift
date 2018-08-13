//
//  ViewControllers.swift
//  Moviez
//
//  Created by Ankit Nandal on 13/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit


//MARK:- UIStoryboard Extension
extension UIStoryboard {
    
    class func main() -> UIStoryboard{
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    // SearchSuggestionViewController
    class func searchSuggestionViewController() -> SearchSuggestionViewController{
        return UIStoryboard.main().instantiateViewController(withIdentifier: "SearchSuggestionViewController") as! SearchSuggestionViewController
    }
    
}
