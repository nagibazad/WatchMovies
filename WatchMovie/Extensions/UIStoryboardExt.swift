//
//  UIStoryboardExt.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

extension UIStoryboard {
    
    class func home() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
    class func details() -> UIStoryboard {
        return UIStoryboard(name: "Details", bundle: Bundle.main)
    }
    
    class func favourite() -> UIStoryboard {
        return UIStoryboard(name: "Favourite", bundle: Bundle.main)
    }
}
