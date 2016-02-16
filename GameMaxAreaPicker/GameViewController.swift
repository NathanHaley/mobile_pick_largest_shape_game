

import UIKit


var gameCurrentIndex = 0

var globalReload = true

var gc: [GameViewController] = []

class GameViewController: UIViewController {
  
  @IBOutlet weak var gameScoreLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  @IBOutlet weak var gameBoardView: GameView!
    
    var pageIndex: Int!
    var gameScore: Int!
    var gameBoardType: String!
    var gameIsNew: Bool!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        gameCurrentIndex = pageIndex
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad for pageIndex: \(pageIndex)")
        
        self.gameScoreLabel.text = String(self.gameScore)
        //print("self.gameBoardView.shapeType: \(self.gameBoardView.shapeType)")
        
        self.gameBoardView.gameId = pageIndex
        self.gameBoardView.shapeType = gameBoardType
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endTurn:", name:"buttonClick", object: nil)
        
    }
    
    func resetGame() {
        gameBoardView.score = 0
        gameBoardView.streak = 0
        gameBoardView.isNewGame = true
        
        gameBoardView.drawRect(gameBoardView.frame)
        
        self.gameScoreLabel.text = String(0)
        self.gameScoreLabel.textColor = UIColor.blackColor()
        self.messageLabel.text = "Click shape with largest area for FUN!"
        
        
        
        
    }
  

  func endTurn(sender: AnyObject) {
  
    messageCheck()

    let scoreIsNegative = gameBoardView.score < 0
    
    if scoreIsNegative {
      gameScoreLabel.textColor = UIColor.redColor()
    } else {
      gameScoreLabel.textColor = UIColor.blackColor()
    }
    
    gameScoreLabel.text = String(gameBoardView.score)
  }
  
  func messageCheck() {
    
    switch gameBoardView.streak {
    case 2:
      messageLabel.text = "You rock!!!"
      
    case 5:
      messageLabel.text = "\(gameBoardView.streak) in a row! Wow!!!"
      
    case 7:
      messageLabel.text = "\(gameBoardView.streak)! You are blowing my mind!!!"
      
    case 10...100000:
      
      if gameBoardView.streak % 10 == 0 {
        messageLabel.text = "\(gameBoardView.streak) in a row! ...Who are you?!?"
      } else {
        fallthrough
      }
      
    default:
      messageLabel.text = "Go again!"
      
    }
    
  }
  
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    
    print("WARNING: didReceiveMemoryWarning()")
  }
  

}
