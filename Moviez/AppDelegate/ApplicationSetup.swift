//
//  ApplicationSetup.swift
//  Moviez
//
//  Created by Ankit Nandal on 09/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FTLinearActivityIndicator

class ApplicationSetup {
    
    static let shared = ApplicationSetup()
    
    private init() {
    }
    
    func config() {
        kNetworkAdapter.shared.startNetworkReachabilityObserver()
        let theme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: theme)
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()
    }
    
    func shouldShowNetworkActivity(_ shouldShow:Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = shouldShow
        }
    }
    
    
    
}
