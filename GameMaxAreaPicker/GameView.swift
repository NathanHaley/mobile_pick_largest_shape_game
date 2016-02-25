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
    var shapeCount = 0
    var isNew = true
    var isPortraitView = UIApplication.sharedApplication().statusBarOrientation.isPortrait
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        addShapes(gc.shapeCountRandom, shapeType: gc.gameBoardType)
    }
    
    
    //TODO: Look at simplifying this in conjunction with addShapes, start by pulling out repeats
    func positionShapes(forRotation forRotation: Bool = false) {

        
        let shapeCount = subviews.count
        let sizes = sizeShapes(shapeCount)
        
        let sectionLength = sizes["sectionLength"]!
        let shapeSideLengthMax = sizes["shapeSideLengthMax"]!

        let positionalCenter = {(index: Int) in sectionLength * CGFloat(index + 1) - sectionLength * 0.5}
        var index = 0
        
        print("turnMaxSideLength: \(gc.turnMaxSideLength)), shapeSideLengthMax \(shapeSideLengthMax)")
        
        print(Int(gc.turnMaxSideLength) > Int(shapeSideLengthMax))
        
        //Check and set scale if needed
        if Int(gc.turnMaxSideLength) > Int(shapeSideLengthMax) {
            gc.scale = shapeSideLengthMax / gc.turnMaxSideLength
            
            gc.turnMaxArea = 0.0
            gc.turnMaxSideLength = 0.0
        }
        
        for shape in subviews {
            
            let button = shape as! CustomButton
            var shapeCenterX: CGFloat = 0.0
            var shapeCenterY: CGFloat = 0.0
            var sideLength = button.bounds.width
            
            if isPortraitView {
                
                print("portrait gc.scale: \(gc.scale)")
                
                //Incase we scaled to fit landscape, set back to original size
                sideLength = button.originalSize.width
                
                shapeCenterX = bounds.midX
                shapeCenterY = positionalCenter(index)
                
                
            } else {
                
                
                
                print("landscape gc.scale: \(gc.scale)")
                
                sideLength = sideLength * gc.scale
                
                shapeCenterX = positionalCenter(index)
                shapeCenterY = bounds.midY
                
            }
            
            //print("sidelength: \(sideLength)")
            
            let size = CGSize(width: sideLength, height: sideLength)
            
            button.sizeThatFits(size)
            button.frame.size = size
            
            button.center = CGPoint(x: shapeCenterX, y: shapeCenterY)
            
            index++
        }
        
        //If we've backed out previous scale need to reset this
        if isPortraitView {
            gc.scale = 1.0
        }
        
        for shape in subviews {
            vetMaxAreaAndSideLength(shape as! CustomButton)
        }
        
    }
    
    func sizeShapes(shapeCount: Int) -> [String: CGFloat] {
        
        var longBound = max(bounds.width,bounds.height)
        
        if isPortraitView {
            longBound -= 60 //TODO: Adjusting for toolbar until I figure out better layout approach
        }
        
        let shortBound = min(bounds.width,bounds.height)
        let  sectionLength = longBound / CGFloat(shapeCount)
        
        
        var shapeSideLengthMax = min(longBound / CGFloat(shapeCount), shortBound) //Use min to avoid clipping
        
        if shortBound < shapeSideLengthMax {
            shapeSideLengthMax = shortBound
        }
        
        let sizes = ["longBound": longBound, "shortBound": shortBound, "sectionLength": sectionLength, "shapeSideLengthMax": shapeSideLengthMax]
        
        return sizes
        
    }
    
    func vetMaxAreaAndSideLength(sender: CustomButton) {
        print("sender.area: \(sender.area), sender.frame.width: \(sender.frame.width)")
        //Find/set the area from the largest shape
        if sender.area > gc.turnMaxArea  {
            gc.turnMaxArea = sender.area
        }
        print("gc.turnMaxArea: \(gc.turnMaxArea), gc.turnMaxSideLength: \(gc.turnMaxSideLength)")
        if sender.frame.width > gc.turnMaxSideLength {
            gc.turnMaxSideLength = sender.frame.width
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //print("layoutSubviews: bounds.width: \(bounds.width), bounds.height: \(bounds.height)")
        
        isPortraitView = UIApplication.sharedApplication().statusBarOrientation.isPortrait
        
        if !isNew {
            positionShapes(forRotation: true)
        }
        
        
        
    }
    
    //Handles initial shape creation
    func addShapes(addCount: Int, shapeType: String = "circles") {
        
        //print("pageIndex: \(gc.pageIndex)")
        //print("addShapes(addCount: \(addCount), shapeType: String = \(shapeType))")
        
        let sizes = sizeShapes(addCount)
        let shapeSideLengthMax = sizes["shapeSideLengthMax"]!
        
        //Clear any previous views for clean slate
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<addCount {
            
            let randomFactor = Utils.randomBetweenLower(0.3, andUpper: 0.8)
            let randomSideLength = shapeSideLengthMax * randomFactor
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
            
            newShapeButton.originalSize = newShapeButton.frame.size
            
            //Apply visuals
            newShapeButton.fillColor = Utils.randomColor()
            newShapeButton.outlineColor = Utils.randomColor()
            
            vetMaxAreaAndSideLength(newShapeButton)
            
        }
        
        positionShapes()
        isNew = false
        
    }
    
    
    
    func tappedShapeAction(sender: CustomButton!) {
        
        gc.tappedArea = sender.area
        
        //print("gc.tappedButton.area: \(sender.area)")
        //print("shapeTap\(gc.pageIndex)")
        
        NSNotificationCenter.defaultCenter().postNotificationName("shapeTap\(gc.pageIndex)", object: nil)
        
    }
    
    
}
