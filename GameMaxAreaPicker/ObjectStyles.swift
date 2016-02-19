//
//  ObjectStyles.swift
//  GameMaxAreaPicker
//
//  Created by Nathan Haley on 2/17/16.
//  Copyright © 2016 Nathan Haley. All rights reserved.
//

import UIKit

//Make rounded Corners enabled on storyboards for UIView elements
extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            clipsToBounds = true
        }
    }
}