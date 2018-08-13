//
//  Extensions.swift
//  Moviez
//
//  Created by Ankit Nandal on 05/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import Foundation
import SDWebImage


extension UIImageView {
    
    func downloadImage(with url:String?) {
        if let imageStr = url , let urlPath = URL(string: imageStr) {
            sd_setImage(with: urlPath, completed: nil)
            self.backgroundColor = UIColor(hex:"555753")
        }
    }
}


extension String {
    
    var whiteSpaceTrimmed:String {
       return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}


extension UIViewController {
    
    func showAlert(with text:String?) {
        guard let alertText = text else {return}
        let alertController = UIAlertController(title: "Alert", message: alertText, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension Date {
    static func getFormattedDate(string: String , with:String, to: String = "MMM dd,yyyy") -> String?{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = with
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = to
        
        if let date = dateFormatterGet.date(from: string) {
            return dateFormatterPrint.string(from: date);
        }
        return nil
    }
}


fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"
extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            if let activityIndicatorView = objc_getAssociatedObject(self, &ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView {
                return activityIndicatorView
            } else {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                activityIndicatorView.activityIndicatorViewStyle = .white
                activityIndicatorView.color = .gray
                self.convert(self.bounds, to: nil)
                activityIndicatorView.center = CGPoint(x: self.center.x - 20 , y: self.center.y - 20)
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                objc_setAssociatedObject(self, &ActivityIndicatorViewAssociativeKey, activityIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue)
            objc_setAssociatedObject(self, &ActivityIndicatorViewAssociativeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
}
