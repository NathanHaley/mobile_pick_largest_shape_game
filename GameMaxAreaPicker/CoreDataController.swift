////
////  CoreDataController.swift
////  GameMaxAreaPicker
////
////  Created by Nathan Haley on 2/26/16.
////  Copyright © 2016 Nathan Haley. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class CoreDataController {
//    
//    func loadGame(Games: [Game]) {
//        
//        for game in Games {
//            
//            if game.type! == self.gameBoardType {
//                //print("Loaded Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
//                gameScore = Int(game.score!)
//                gameStreak = Int(game.streak!)
//                gameScoreLabel.text = String(gameScore)
//            }
//        }
//        
//        messageCheck()
//        
//    }
//    
//    func fetchGame() -> [Game] {
//        
//        //print("self.gameBoardType == \(self.gameBoardType)")
//        
//        let predicate = NSPredicate(format: "type == %@", self.gameBoardType)
//        
//        let gameFetch = NSFetchRequest(entityName: "Game")
//        gameFetch.predicate = predicate
//        
//        do {
//            let fetchedGames = try moc.executeFetchRequest(gameFetch) as! [Game]
//            
//            return fetchedGames
//            
//        } catch {
//            fatalError("Could not fetch games. \(error)")
//            
//        }
//        
//        return []
//        
//    }
//    
//    func deleteGame() {
//        
//        let fetchedGames = fetchGame()
//        
//        
//        for game in fetchedGames {
//            moc.deleteObject(game)
//            //print("Deleting Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
//        }
//        
//        saveGame()
//        
//        do {
//            try moc.save()
//            
//            //print("Saving after delete")
//        } catch {
//            // Do something in response to error condition
//            print("Counld not save after deleting game: \(error)")
//        }
//        
//    }
//    
//    func insertGame() {
//        
//        //Delete before inserting for now
//        deleteGame()
//        
//        let game = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: moc) as! Game
//        
//        game.setValue(self.gameBoardType, forKey: "type")
//        game.setValue(self.gameScore, forKey: "score")
//        game.setValue(self.gameStreak, forKey: "streak")
//        
//        let shape = NSEntityDescription.insertNewObjectForEntityForName("Shape", inManagedObjectContext: moc) as! Shape
//        
//        
//        
//        //print("Inserting Game type: \(game.type!) score: \(game.score!) streak: \(game.streak!)")
//        saveGame()
//        
//    }
//    
//    func saveGame() {
//        do {
//            try moc.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//        //print("WARNING: didReceiveMemoryWarning()")
//    }
//    
//    
//    
//}
