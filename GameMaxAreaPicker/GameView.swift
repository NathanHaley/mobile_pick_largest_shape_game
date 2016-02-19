//
//  GameViewsContainer.swift
//  DesignPatternsInSwift
//
//  Created by Nathan Haley on 2/13/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var gc: GameViewController!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        addShapes(gc.shapeCountRandom,shapeType: gc.gameBoardType)
        
    }
    
    func addShapes(addCount: Int, shapeType: String = "circles") {
        
        print("pageIndex: \(gc.pageIndex)")
        
        print("addShapes(addCount: \(addCount), shapeType: String = \(shapeType))")
        
        let height = bounds.height / CGFloat(addCount)
        let shapeCenterX = bounds.midX
        
        //Reset maxArea
        gc.turnMaxArea = 0.0
        
        //Clear any previous views for clean slate
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for i in 0..<addCount {
            
            let randomFactor = Utils.randomBetweenLower(0.3, andUpper: 0.8)
            let randomSideLength = height * randomFactor
            let xyOffset = 0.5 * randomSideLength
            
            let shapeCenterY = (height * CGFloat(i)) + (0.5 * sqrt(randomSideLength * randomSideLength))
            
            let x = shapeCenterX - xyOffset
            let y = shapeCenterY - xyOffset
            
            //print("y: \(y), randomSideLength: \(randomSideLength)")
            
            let newFrame = CGRect(x: x, y: y, width: randomSideLength, height: randomSideLength)
            
            var newShapeButton: CustomButton!
            
            if gc.gameBoardType == "circles" {
                newShapeButton = CircleButton(frame: newFrame)
            } else if gc.gameBoardType == "squares" {
                newShapeButton = SquareButton(frame: newFrame)
            } else {
                let randomGame = Utils.randomBetweenLower(0, andUpper: 1)
                
                if randomGame > 0.50 {
                    newShapeButton = CircleButton(frame: newFrame)
                } else {
                    newShapeButton = SquareButton(frame: newFrame)
                }
            }
            
            newShapeButton.center = CGPoint(x: shapeCenterX, y: shapeCenterY)
            
            addSubview(newShapeButton)
            
            newShapeButton.addTarget(self, action: "tappedShapeAction:", forControlEvents: UIControlEvents.TouchDown)
            
            //Find/set the area from the largest shape
            if newShapeButton.area > gc.turnMaxArea  {
                gc.turnMaxArea = newShapeButton.area
            }
            
            //Apply visuals
            newShapeButton.fillColor = Utils.randomColor()
            newShapeButton.outlineColor = Utils.randomColor()
            newShapeButton.halfLineWidth = 3.0
            
        }
        
    }
    
    func tappedShapeAction(sender: CustomButton!) {
        
        //var tappedButton = sender
        gc.tappedArea = sender.area
        
        print("gc.tappedButton.area: \(sender.area)")
        print("shapeTap\(gc.pageIndex)")
        
        NSNotificationCenter.defaultCenter().postNotificationName("shapeTap\(gc.pageIndex)", object: nil)
        
    }
    
    
}
