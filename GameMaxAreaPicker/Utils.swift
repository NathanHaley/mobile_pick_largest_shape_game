import Foundation
import UIKit

class Utils {
  
  static let twoPi = CGFloat(M_PI * 2)
  
  static func randomBetweenLower(lower: CGFloat, andUpper: CGFloat) -> CGFloat {
    return lower + CGFloat(arc4random_uniform(101)) / 100.0 * (andUpper - lower)
  }
  
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
  
  static func degreesToRadians(degrees: CGFloat) -> CGFloat { return CGFloat(M_PI) * (degrees) / 180.0 }
  
}
