//
//  UIViewControllerExt.swift
//  WatchMovie
//
//  Created by user on 6/10/20.
//

import UIKit

extension UIViewController {
    
    class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
    
    class func identifier() -> String {
        return String(describing: self) + "ID"
    }
    
    class func instantiateViewController() -> UIViewController {
        return UIStoryboard.home().instantiateViewController(withIdentifier: String(describing: self) + "ID")
    }
    
    class func instantiateViewController(from storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self) + "ID")
    }
}
