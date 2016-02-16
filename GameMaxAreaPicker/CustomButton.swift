
import UIKit


class CustomButton: UIButton {
  var fillColor: UIColor = UIColor.grayColor()
  var outlineColor: UIColor = UIColor.blackColor()
  var halfLineWidth: CGFloat = 3.0
  
  var areaFactor: CGFloat!
  var area: CGFloat { return CGFloat(M_PI) * areaFactor * areaFactor / 4.0 }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.opaque = false
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override func drawRect(rect: CGRect) {
    
    
    outlineColor.setStroke()
    
    let outlinePath = getOutlinePath()
    outlinePath.lineWidth = 2.0 * halfLineWidth
    
    outlinePath.stroke()
    
    fillColor.setFill()
    outlinePath.fill()
    
    
  }
  
  //Blank placeholder, implemented in subclasses
  func getOutlinePath() -> UIBezierPath {
    
    return UIBezierPath()
    
  }

  
}
