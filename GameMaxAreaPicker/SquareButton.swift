import UIKit



class SquareButton: CustomButton {

  override var area: CGFloat { return bounds.width * bounds.width }
  
  override func getOutlinePath() -> UIBezierPath {
    let outlinePath = UIBezierPath(rect: CGRect(
      x: halfLineWidth,
      y: halfLineWidth,
      width: bounds.size.width - 2 * halfLineWidth,
      height: bounds.size.height - 2 * halfLineWidth))
    
    //print("square area: \(area)")
    
    return outlinePath
  }
  
}
