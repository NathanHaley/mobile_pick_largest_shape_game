
import UIKit
import CoreData

class GameViewController: UIViewController {
    
    
    // MARK: Properties
    
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var gameBoardView: GameView!
    
    var defaultMessageLabelText = "Click shape with largest area for FUN!"
    var pageIndex: Int!
    var gameScore = 0
    var gameStreak = 0
    var gameBoardType: String!
    
    var turnMaxArea: CGFloat = 0.0
    var turnMaxSideLength: CGFloat = 0.0
    var scale: CGFloat = 1.0
    
    var minShapesToDraw: CGFloat = 2.0
    var maxShapesToDraw: CGFloat = 5.0
    
    var shapeCountRandom: Int!
    var tappedArea: CGFloat = 0.0
    var moc: NSManagedObjectContext = DataController().managedObjectContext

    // MARK: Game management
    
    func checkAnswer() {
        
        let answerCorrect = turnMaxArea == tappedArea
        
        if answerCorrect {
            
            gameScore++
            gameStreak++
            
        } else {
            
            gameScore--
            gameStreak = 0
            
        }
        
        scale = 1.0
        turnMaxArea = 0.0
        
        setScoreLabelColor()
        
    }
    
    
    func resetGame() {
        
        deleteGame()
        
        setGameState(gameIsNew: true)
        
        scale = 1.0
        turnMaxArea = 0.0
        turnMaxSideLength = 0.0
        
        
        //TODO: Fix odd order of depending on call to setGameState() to have shapeCountRandom set
        gameBoardView.addShapes(shapeCountRandom,shapeType: gameBoardType)
        
        
    }
    
    func setGameState(gameIsNew gameIsNew: Bool) {
        
        shapeCountRandom = Int(Utils.randomBetweenLower(minShapesToDraw, andUpper: maxShapesToDraw))
        
        if gameIsNew {
            
            gameScore = 0
            gameStreak = 0
            messageLabel.text = defaultMessageLabelText
            gameScoreLabel.text = String(0)
            
            loadGame(fetchGame())
            
            setScoreLabelColor()
            tappedArea = 0.0
            scale = 1.0
            turnMaxArea = 0.0
            turnMaxSideLength = 0.0
            
        }
        
    }
    
    func endTurn(sender: AnyObject) {
        
        checkAnswer()
        
        messageCheck()
        
        gameScoreLabel.text = String(self.gameScore)
        
        shapeCountRandom = Int(Utils.randomBetweenLower(minShapesToDraw, andUpper: maxShapesToDraw))
        
        scale = 1.0
        turnMaxArea = 0.0
        turnMaxSideLength = 0.0
        
        gameBoardView.addShapes(shapeCountRandom,shapeType: gameBoardType)
        
    }
    
    func messageCheck() {
        
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
        
        let scoreIsNegative = gameScore < 0
        
        if scoreIsNegative {
            gameScoreLabel.textColor = UIColor.redColor()
        } else {
            gameScoreLabel.textColor = UIColor.blackColor()
        }
        
    }
    
    //MARK: Overrides
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        gameCurrentIndex = pageIndex
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoardView.gc = self
        
        setGameState(gameIsNew: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endTurn:", name:"shapeTap\(pageIndex)", object: nil)
        
    }
    
    //MARK: CoreData data handlers
    
    func loadGame(Games: [Game]) {
        
        for game in Games {
            
            if game.type! == self.gameBoardType {
                gameScore = Int(game.score!)
                gameStreak = Int(game.streak!)
                gameScoreLabel.text = String(gameScore)
            }
        }
        
        messageCheck()
        
    }
    
    func fetchGame() -> [Game] {
        
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

        }
        
        saveGame()
        
        do {
            
            try moc.save()
            
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
        
        // TODO: Implement shape data
        //let shape = NSEntityDescription.insertNewObjectForEntityForName("Shape", inManagedObjectContext: moc) as! Shape
        
    }
    
    func saveGame() {
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}
