//
//  GameViewsContainer.swift
//  DesignPatternsInSwift
//
//  Created by Nathan Haley on 2/13/16.
//  Copyright © 2016 RepublicOfApps, LLC. All rights reserved.
//

//TODO: Refactor to not be so tightly coupled with GameViewController

import UIKit

class GameView: UIView {
    
    var gc: GameViewController!
    var isNew = true
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        addShapes(gc.shapeCountRandom, shapeType: gc.gameBoardType)
    }
    
    
    //TODO: Look at simplifying this in conjunction with addShapes, start by pulling out repeats
    func positionShapes(forRotation forRotation: Bool = false) {
        
        let shapeCount = subviews.count
        let longBound = max(bounds.width,bounds.height)
        let shortBound = min(bounds.width,bounds.height)
        var sectionLength = min(longBound / CGFloat(shapeCount), shortBound)
        
        let positionalCenter = {(index: Int) in sectionLength * CGFloat(index + 1) - sectionLength * 0.5}
        var index = 0
        
        print("shortBound: \(shortBound), sectionLength: \(sectionLength)")
        print("turnMaxSideLength: \(gc.turnMaxSideLength)), sectionLength \(sectionLength)")
        
        for shape in subviews {
            
            let button = shape as! CustomButton
            var shapeCenterX: CGFloat = 0.0
            var shapeCenterY: CGFloat = 0.0
            var sideLength: CGFloat!
            
            let portraitView = longBound == bounds.height
            
            if portraitView {
                
                print("portrait gc.scale: \(gc.scale)")
                
                //gc.scale should be 1.0 or will be scale applied in landscape which this will back out
                sideLength = button.frame.width / gc.scale
                
                shapeCenterX = bounds.midX
                shapeCenterY = positionalCenter(index)
                
            } else {
                
                //Check and set scale if needed
                if Int(gc.turnMaxSideLength) > Int(sectionLength) {
                    gc.scale = sectionLength / gc.turnMaxSideLength
                    
                    gc.turnMaxArea = 0.0
                }
                
                //TODO: reseting this to max here works but find better solution
                sectionLength = max(longBound / CGFloat(shapeCount), shortBound)
                
                print("landscape gc.scale: \(gc.scale)")
                
                sideLength = button.frame.width * gc.scale
                
                shapeCenterX = positionalCenter(index)
                shapeCenterY = bounds.midY
                
            }
            
            let size = CGSize(width: sideLength, height: sideLength)
            
            button.sizeThatFits(size)
            button.frame.size = size
            
            button.center = CGPoint(x: shapeCenterX, y: shapeCenterY)
            
            index++
        }
        
        for shape in subviews {
            vetMaxAreaAndSideLength(shape as! CustomButton)
        }
        
    }
    
    func vetMaxAreaAndSideLength(sender: CustomButton) {
        
        //Find/set the area from the largest shape
        if sender.area > gc.turnMaxArea  {
            gc.turnMaxArea = sender.area
        }
        
        if sender.frame.width > gc.turnMaxSideLength {
            gc.turnMaxSideLength = sender.frame.width
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layoutSubviews: bounds.width: \(bounds.width), bounds.height: \(bounds.height)")
        if !isNew {
            positionShapes(forRotation: true)
        }
        
    }
    
    func addShapes(addCount: Int, shapeType: String = "circles") {
        
        print("pageIndex: \(gc.pageIndex)")
        print("addShapes(addCount: \(addCount), shapeType: String = \(shapeType))")
        
        let longBound = max(bounds.width,bounds.height)
        let shortBound = min(bounds.width,bounds.height)
        let sectionLength = min(longBound / CGFloat(addCount), shortBound)
        
        //Clear any previous views for clean slate
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<addCount {
            
            let randomFactor = Utils.randomBetweenLower(0.3, andUpper: 0.8)
            let randomSideLength = sectionLength * randomFactor
            let newFrame = CGRect(x: 0.0, y: 0.0, width: randomSideLength, height: randomSideLength)
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
            
            addSubview(newShapeButton)
            
            newShapeButton.addTarget(self, action: "tappedShapeAction:", forControlEvents: UIControlEvents.TouchDown)
            
            //Apply visuals
            newShapeButton.fillColor = Utils.randomColor()
            newShapeButton.outlineColor = Utils.randomColor()
            
            vetMaxAreaAndSideLength(newShapeButton)
            
        }
        
        positionShapes()
        isNew = false
        
    }
    
    
    
    func tappedShapeAction(sender: CustomButton!) {
        
        //var tappedButton = sender
        gc.tappedArea = sender.area
        
        print("gc.tappedButton.area: \(sender.area)")
        print("shapeTap\(gc.pageIndex)")
        
        NSNotificationCenter.defaultCenter().postNotificationName("shapeTap\(gc.pageIndex)", object: nil)
        
    }
    
    
}
