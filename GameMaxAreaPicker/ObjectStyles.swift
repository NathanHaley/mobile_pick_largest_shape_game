
import UIKit

//Makes rounded Corners enabled on storyboards for UIView elements
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