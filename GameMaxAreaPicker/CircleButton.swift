
import UIKit



class CircleButton: CustomButton {
  
  override var area: CGFloat { return (bounds.width * 0.5) * (bounds.width * 0.5) * CGFloat(M_PI) }

  
  override func getOutlinePath() -> UIBezierPath {
    let outlinePath = UIBezierPath(ovalInRect: CGRect(
      x: halfLineWidth,
      y: halfLineWidth,
      width: bounds.size.width - 2 * halfLineWidth,
      height: bounds.size.height - 2 * halfLineWidth))
    
    //print("circle area: \(area)")
    
    return outlinePath
  }
  
}
