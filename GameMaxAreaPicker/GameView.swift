//
//  GameViewsContainer.swift
//  DesignPatternsInSwift
//
//  Created by Nathan Haley on 2/13/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import UIKit

class GameView: UIView {
  
  var isNewGame = true
  var shapeType = "circle"
  var score = 0
  var streak = 0
  
  var gameId: Int!
  
  var maxArea: CGFloat = 0.0

  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    if isNewGame {
        addViews(2)
    }
    
  }
  
  //Not using yet
  var views: [GameView] = []
  
  func addViews(addCount: Int) {
    
    print("Drawing for gameId: \(gameId)")
    
    let height = bounds.height / CGFloat(addCount)
    let width = bounds.width
    let shapeViewSideLength = min(width, height)
    maxArea = 0.0
    
    //Clear any previous views for clean slate
    for view in self.subviews {
      view.removeFromSuperview()
    }
    
    for i in 0..<addCount {

        let newView = UIView(frame: CGRect(x: 0, y: bounds.height / CGFloat(addCount) * CGFloat(i), width: width, height: height))

        newView.backgroundColor = UIColor.blackColor()

        let randomFactor = Utils.randomBetweenLower(0.3, andUpper: 0.8)

        addSubview(newView)

        let size = CGSize(width: shapeViewSideLength  * randomFactor, height: shapeViewSideLength  * randomFactor)

        let newFrame = CGRect(x: newView.center.x, y: 0, width: size.width, height: size.height)
        
        var newShapeButton: CustomButton!
        
        if shapeType == "circle" {
            newShapeButton = CircleButton(frame: newFrame)
        } else if shapeType == "square" {
            newShapeButton = SquareButton(frame: newFrame)
            rotateButton(newShapeButton)
        } else {
            let randomGame = Utils.randomBetweenLower(0, andUpper: 1)
            
            if randomGame > 0.50 {
                newShapeButton = CircleButton(frame: newFrame)
            } else {
                newShapeButton = SquareButton(frame: newFrame)
                rotateButton(newShapeButton)
            }
        }

        newView.addSubview(newShapeButton)

        newShapeButton.center = CGPoint(x: newView.bounds.midX, y: newView.bounds.midY)

        newShapeButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchDown)

        if newShapeButton.area > maxArea {
        maxArea = newShapeButton.area
        }

        newShapeButton.fillColor = Utils.randomColor()
        newShapeButton.outlineColor = Utils.randomColor()
        newShapeButton.halfLineWidth = 3.0

        //views.append(newView)
        
        isNewGame = false
    }
    
  }
  
  func buttonAction(sender:UIButton!) {
    
    checkAnswer(sender)
    
    NSNotificationCenter.defaultCenter().postNotificationName("buttonClick", object: nil)
    
    addViews(Int(Utils.randomBetweenLower(2, andUpper: 5)))
    
  }
  
  func checkAnswer(sender: AnyObject) {
    
    let tappedButton = sender as! CustomButton
    let answerCorrect = tappedButton.area == maxArea
    
    
    if answerCorrect {
      score++
      streak++
    } else {
      score--
      streak = 0
    }
    
    //print("score: \(score), streak: \(streak), maxArea: \(round(maxArea)), buttonTapped.area: \(round(tappedButton.area))")
    
    maxArea = 0.0
    
  }

    
 /*
    func buttonsMods() {
  
      let sideLengthMax: CGFloat = (min(topView.frame.size.height, topView.frame.size.width) - buttonPadding) * 0.9
  
      // Probably need way to handle if frame is somehow too small like 5, error?
      let sideLengthMin: CGFloat = sideLengthMax * 0.3
  
      buttonResize(topButton, heightConstrant: topButtonHeight, widthConstrant: topButtonWidth, sideLengthMin: sideLengthMin, sideLengthMax: sideLengthMax)
  
      buttonResize(bottomButton, heightConstrant: bottomButtonHeight, widthConstrant: bottomButtonWidth, sideLengthMin: sideLengthMin, sideLengthMax: sideLengthMax)
  
      rotateButton(topButton)
      rotateButton(bottomButton)
  
      //swapButtons(topButton, bottom: bottomButton)
  
    }
  
    //TODO: get to work, breaks constraints
    func swapButtons(top: CustomButton, bottom: CustomButton) {
      print("subviews: \(topView.subviews.count)")
      top.removeFromSuperview()
      bottom.removeFromSuperview()
      print("subviews: \(topView.subviews.count)")
      topView.addSubview(bottom)
      bottomView.addSubview(top)
      print("subviews: \(topView.subviews.count)")
  
    }
  
    func buttonResize(button: CustomButton, heightConstrant: NSLayoutConstraint!, widthConstrant: NSLayoutConstraint!, sideLengthMin: CGFloat, sideLengthMax: CGFloat) {
  
      let buttonSize = Utils.randomBetweenLower(sideLengthMin, andUpper: sideLengthMax)
  
      print("topButtonViewParent bounds: \(topView.bounds)")
      print("bottomButtonView bounds: \(bottomView.bounds)")
  
      heightConstrant.constant = buttonSize
      widthConstrant.constant = buttonSize
  
      button.fillColor = Utils.randomColor()
      button.outlineColor = Utils.randomColor()
  
  
  
      button.setNeedsDisplay()
  
    }

*/
  
  func rotateButton(button: CustomButton) {
    
    let degreesToRotate = Utils.randomDegreesToRotate()
    
    button.transform = CGAffineTransformMakeRotation(degreesToRotate)
    
  }
  
  
}
