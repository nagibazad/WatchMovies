//
//  UIViewExt.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation
import UIKit

extension UIView {
    class func nib() -> UINib {
        return UINib.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func identifier() -> String {
        let id = String(describing: self) + "ID"
        return id
    }
}
