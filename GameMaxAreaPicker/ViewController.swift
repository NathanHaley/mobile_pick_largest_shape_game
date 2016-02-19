//
//  ViewController.swift
//  GameMaxAreaPicker
//
//  Created by Nathan Haley on 2/15/16.
//  Copyright © 2016 Nathan Haley. All rights reserved.

//TODO: What to do about unsaved games when user closes, ask to ignore?
//

import UIKit
import CoreData


//TODO: Can these be implemented better?
var gameCurrentIndex = 0
var globalReload = true

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    var gc: [GameViewController] = []
    
    var pageViewController: UIPageViewController?

    var initialBuild = true
    
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var restartButton: UIView!
    @IBOutlet weak var saveButton: UIView!
    
    @IBAction func instructionsGoButtonTapped(sender: AnyObject) {
        
        instructionsView.hidden = true
        
        buildGame()
    }

    @IBAction func restartAction(sender: AnyObject) {
        
        gc[gameCurrentIndex].resetGame()
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        gc[gameCurrentIndex].insertGame()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func buildGame() {
        
        //Set initial values for game states
        var gameScore = [0, 0, 0]
        var gameStreak = [0, 0, 0]
        var gameBoardType = ["circles", "squares", "mix"]

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController!.dataSource = self
        
        for index in 0..<gameScore.count {
            
            //Create new GameViewController and set defaults
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
            
            vc.gameScore = gameScore[index]
            vc.gameStreak = gameStreak[index]
            vc.gameBoardType = gameBoardType[index]

            vc.pageIndex = index
            vc.minShapesToDraw = 2
            vc.maxShapesToDraw = 5
            
            gc.append(vc)
            
        }
        
        let startVC = gc[0]
        let viewControllers = [startVC]
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController!.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 60)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        
        restartButton.hidden = false
        
        //TODO: Maybe not show, enable, until one round played for game?
        saveButton.hidden = false
        //saveButton.alpha = 1.0
        //saveButton.userInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index: Int) -> GameViewController {
        
        print("viewControllerAtIndex(index: \(index))")
        
        return gc[index]
        
    }
    
    
    //MARK! -- Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameViewController
        var index = vc.pageIndex as Int
        
        //print("Before: vc.pageIndex: \(vc.pageIndex) gameCurrentIndex: \(gameCurrentIndex)")
        
        //If viewing first page do not set index to negative, sit at 0
        if (index <= 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameViewController
        var index = vc.pageIndex as Int
        
        //print("After: vc.pageIndex: \(vc.pageIndex) gameCurrentIndex: \(gameCurrentIndex)")
        
        //Do nothing with index if last game or out of bounds
        if ((index == NSNotFound) || (index >= gc.count - 1)) {
            return nil
        }
        
        index++
        
        return self.viewControllerAtIndex(index)

    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return gc.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    


}

