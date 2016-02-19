

import UIKit
import CoreData




class GameViewController: UIViewController {
    
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var gameBoardView: GameView!
    
    var defaultMessageLabelText = "Click shape with largest area for FUN!"
    
    var pageIndex: Int!
    var gameScore = 0
    var gameStreak = 0
    var gameBoardType: String!

    var turnMaxArea: CGFloat = 0.0
    
    var minShapesToDraw: CGFloat = 2.0
    var maxShapesToDraw: CGFloat = 5.0
    
    var shapeCountRandom: Int!
    
    var tappedArea: CGFloat = 0.0
    
    let moc = DataController().managedObjectContext
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        print("viewWillAppear(\(pageIndex))")
        
        gameCurrentIndex = pageIndex
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad(\(pageIndex))")
        
        gameBoardView.gc = self
        
        setGameState(gameIsNew: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endTurn:", name:"shapeTap\(pageIndex)", object: nil)
        
    }
    
    func checkAnswer() {
        
        print("checkAnswer: score: \(gameScore), streak: \(gameStreak), maxArea: \(round(turnMaxArea))")
    
        let answerCorrect = turnMaxArea == tappedArea
        
        if answerCorrect {
            
            gameScore++
            gameStreak++
            
        } else {
            
            gameScore--
            gameStreak = 0
            
        }
        
        setScoreLabelColor()
        
        print("buttonTapped.area: \(round(tappedArea))")
        
    }
    
    
    func resetGame() {
        
        deleteGame()
        
        gameBoardView.addShapes(shapeCountRandom,shapeType: gameBoardType)
        
        setGameState(gameIsNew: true)
        
    }
    
    func setGameState(gameIsNew gameIsNew: Bool) {
        
        print("setGameState()")
        
        shapeCountRandom = Int(Utils.randomBetweenLower(minShapesToDraw, andUpper: maxShapesToDraw))
        
        
        if gameIsNew {
        
            gameScore = 0
            gameStreak = 0
            messageLabel.text = defaultMessageLabelText
            gameScoreLabel.text = String(0)
            
            loadGame(fetchGame())
            
            setScoreLabelColor()
            tappedArea = 0.0

        }
        
    }
    
    
    func endTurn(sender: AnyObject) {
        print("endTurn")
        
        checkAnswer()
        
        messageCheck()
        
        gameScoreLabel.text = String(self.gameScore)
        
        shapeCountRandom = Int(Utils.randomBetweenLower(minShapesToDraw, andUpper: maxShapesToDraw))
        
        gameBoardView.addShapes(shapeCountRandom,shapeType: gameBoardType)
    }
    
    
    
    func messageCheck() {
        print("messageCheck()")
        
        switch gameStreak {
        case 2:
            messageLabel.text = "You rock!!!"
            
        case 5:
            messageLabel.text = "\(gameStreak) in a row! Wow!!!"
            
        case 7:
            messageLabel.text = "\(gameStreak)! You are blowing my mind!!!"
            
        case 10...100000:
            
            if gameStreak % 10 == 0 {
                messageLabel.text = "\(gameStreak) in a row! ...How far can you go!?"
            } else {
                fallthrough
            }
            
        default:
            messageLabel.text = "Go again!"
            
        }
        
    }
    
    func setScoreLabelColor() {
        print("setScoreLabelColor()")
        
        let scoreIsNegative = gameScore < 0
        
        if scoreIsNegative {
            gameScoreLabel.textColor = UIColor.redColor()
        } else {
            gameScoreLabel.textColor = UIColor.blackColor()
        }

    }
    
    func loadGame(Games: [Game]) {
        
        for game in Games {
            
            if game.type! == self.gameBoardType {
                print("Loaded Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
                gameScore = Int(game.score!)
                gameStreak = Int(game.streak!)
                gameScoreLabel.text = String(gameScore)
            }
        }
        
        messageCheck()
        
    }
    
    func fetchGame() -> [Game] {
        
        print("self.gameBoardType == \(self.gameBoardType)")
        
        let predicate = NSPredicate(format: "type == %@", self.gameBoardType)
        
        let gameFetch = NSFetchRequest(entityName: "Game")
        gameFetch.predicate = predicate
        
        do {
            let fetchedGames = try moc.executeFetchRequest(gameFetch) as! [Game]
            
            return fetchedGames
        
        } catch {
            fatalError("Could not fetch games. \(error)")
            
        }
        
        return []
        
    }
    
    func deleteGame() {
    
        let fetchedGames = fetchGame()
        
        
        for game in fetchedGames {
            moc.deleteObject(game)
            print("Deleting Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
        }
        
        saveGame()
        
        do {
            try moc.save()
            
            print("Saving after delete")
        } catch {
            // Do something in response to error condition
            print("Counld not save after deleting game: \(error)")
        }
        
    }
    
    func insertGame() {

        //Delete before inserting for now
        deleteGame()
        
        let game = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: moc) as! Game
        
        game.setValue(self.gameBoardType, forKey: "type")
        game.setValue(self.gameScore, forKey: "score")
        game.setValue(self.gameStreak, forKey: "streak")
        
        print("Inserting Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
        saveGame()
        
    }
    
    func saveGame() {
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("WARNING: didReceiveMemoryWarning()")
    }
    
    
}
