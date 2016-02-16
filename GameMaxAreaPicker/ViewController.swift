//
//  ViewController.swift
//  GameMaxAreaPicker
//
//  Created by Nathan Haley on 2/15/16.
//  Copyright © 2016 Nathan Haley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var gameScore: Array<Int>!
    var gameStreak: Array<Int>!
    var gameBoardType: Array<String>!
    var gameIsNew: Array<Bool>!

    @IBAction func restartAction(sender: AnyObject) {
        print("restartAction(\(gameCurrentIndex))")
        
        gc[gameCurrentIndex].resetGame()
        
        /*
        gc[gameCurrentIndex].gameIsNew = true
        gc[gameCurrentIndex].gameScoreLabel.text = String(0)
        
        gc[gameCurrentIndex].gameScoreLabel.textColor = UIColor.blackColor()
        
        gc[gameCurrentIndex].gameScore = 0
        gc[gameCurrentIndex].messageLabel.text = "Click shape with largest area for FUN!"
        
        self.gameScore[gameCurrentIndex] = 0
        self.gameStreak[gameCurrentIndex] = 0
        self.gameIsNew[gameCurrentIndex] = true
        */
        /*
        let startVC = self.viewControllerAtIndex(0)
        
        let viewControllers = [startVC]
        
        self.pageViewController?.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameScore = [0, 0, 0]
        self.gameStreak = [0, 0, 0]
        self.gameBoardType = ["circle", "square", "mix"]
        self.gameIsNew = [true, true, true]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController!.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as GameViewController
        let viewControllers = [startVC]
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController!.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 60)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index: Int) -> GameViewController {
        
        if ((self.gameScore.count == 0) || (index >= self.gameScore.count)) {
            
            
            return GameViewController()
        }
        
        print("viewControllerAtIndex(index: \(index))")
        
        var vc = GameViewController()
        
        if gc.count == 3 {
            vc = gc[index]
        } else {
            print("viewControllerAtIndex(index: \(index))")
            
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
            
            
            vc.gameScore = self.gameScore[index]
            vc.gameBoardType = self.gameBoardType[index]
            vc.pageIndex = index
            vc.gameIsNew = self.gameIsNew[index]
            
            gc.append(vc)
        }
        
        return vc
        
    }
    
    
    //MARK! -- Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++
        
        if (index == self.gameScore.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)

    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.gameScore.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    


}

