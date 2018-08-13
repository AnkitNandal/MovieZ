//
//  Theme.swift
//  Moviez
//
//  Created by Ankit Nandal on 26/07/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit
enum Theme: Int {
    case light, dark
    
    var mainColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
    
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0.9, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .light:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 41.0/255.0, green: 41.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        }
    }
}

let SelectedThemeKey = "SelectedTheme"

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? Int {
            return Theme(rawValue: storedTheme)!
        } else {
            return .dark
        }
    }
    
    static func applyTheme(theme: Theme) {
       UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
        UINavigationBar.appearance().barStyle = theme.barStyle
    }
}




