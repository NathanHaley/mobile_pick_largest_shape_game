
import UIKit
import CoreData


class CircleButton: CustomButton {
    
    override var area: CGFloat { return (bounds.width * 0.5) * (bounds.width * 0.5) * CGFloat(M_PI) }
    
    
    override func getOutlinePath() -> UIBezierPath {
        let outlinePath = UIBezierPath(ovalInRect: CGRect(
            x: halfLineWidth,
            y: halfLineWidth,
            width: bounds.size.width - 2 * halfLineWidth,
            height: bounds.size.height - 2 * halfLineWidth))
        
        return outlinePath
    }
    
}



class SquareButton: CustomButton {
    
    override var area: CGFloat { return bounds.width * bounds.width }
    
    override func getOutlinePath() -> UIBezierPath {
        let outlinePath = UIBezierPath(rect: CGRect(
            x: halfLineWidth,
            y: halfLineWidth,
            width: bounds.size.width - 2 * halfLineWidth,
            height: bounds.size.height - 2 * halfLineWidth))
        
        return outlinePath
    }
    
}



class CustomButton: UIButton {
  var fillColor: UIColor = UIColor.grayColor()
  var outlineColor: UIColor = UIColor.blackColor()
  var halfLineWidth: CGFloat = 3.0 //Controls border width
    var originalSize: CGSize = CGSize(width: 0.0, height: 0.0)
  
  var areaFactor: CGFloat!
  var area: CGFloat { return 0.0}
    

  
  
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
