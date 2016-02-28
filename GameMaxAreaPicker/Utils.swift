
import UIKit

class Utils {
    
    // MARK: Constants
  
    static let twoPi = CGFloat(M_PI * 2)
    
    static let standardRoundedCornerSize: CGFloat = 10.0
    
    
    // MARK: Random generators
    
    static func randomColor() -> UIColor {
        
        let red = randomBetweenLower(0, andUpper: 255.0) / 255
        let green = randomBetweenLower(0, andUpper: 255.0) / 255
        let blue = randomBetweenLower(0, andUpper: 255.0) / 255
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        return color
        
    }
    
    static func randomDegreesToRotate() -> CGFloat {
        
        return degreesToRadians(randomBetweenLower(0.0, andUpper: 360.0))
        
    }
    
    static func randomBetweenLower(lower: CGFloat, andUpper: CGFloat) -> CGFloat {
        
        return lower + CGFloat(arc4random_uniform(101)) / 100.0 * (andUpper - lower)
        
    }
    
    // MARK: Conversions
    
    static func degreesToRadians(degrees: CGFloat) -> CGFloat {
        
        return CGFloat(M_PI) * (degrees) / 180.0
    
    }
    
    // MARK: Targeted actions
    
    static func rotateView(view: UIView) {
        
        let degreesToRotate = Utils.randomDegreesToRotate()
        view.transform = CGAffineTransformMakeRotation(degreesToRotate)
        
    }
    
    static func roundCorners(view: UIView) {
        
        view.layer.cornerRadius = standardRoundedCornerSize
        view.clipsToBounds = true
        
    }
    
  
}
