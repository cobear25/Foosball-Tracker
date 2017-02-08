//
//  APIClient.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/6/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class APIClient {
    static let sharedInstance = APIClient()
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    var user: FIRUser?
    #if DEBUG
    var table = "dev"
    #else
    var table = "rocketmade"
    #endif

    var players: [Player] = []

    init() {
        ref = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            self.user = user
        })
    }

    func getPlayers(success: @escaping ([Player]) -> Void, failure: @escaping (Error) -> Void) {
        ref.child("tables").child(table).child("players").observe(FIRDataEventType.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                var players: [Player] = []
                for (key, val) in value {
                    let playerName = key as! String
                    let playerDict = val as! NSDictionary
                    let blackDef = playerDict["blackDefWins"] as? Int ?? 0
                    let blackOff = playerDict["blackOffWins"] as? Int ?? 0
                    let redDef = playerDict["redDefWins"] as? Int ?? 0
                    let redOff = playerDict["redOffWins"] as? Int ?? 0
                    let redSolo = playerDict["redSoloWins"] as? Int ?? 0
                    let blackSolo = playerDict["blackSoloWins"] as? Int ?? 0
                    let points = playerDict["points"] as? Int ?? 0
                    let games = playerDict["games"] as? Int ?? 0
                    let playerDictionary: NSDictionary = ["name": playerName, "blackDef": blackDef, "blackOff": blackOff, "redDef": redDef, "redOff": redOff, "redSolo": redSolo, "blackSolo": blackSolo, "points": points, "games": games]
                    let player = Player.initWithJson(json: playerDictionary)
                    players.append(player)
                }
                self.players = players
                success(players)
            } else {
                let error = NSError(domain: "Failure", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch players"])
                failure(error)
            }
        }) { (error) in
            failure(error)
        }
    }

    func createPlayer(name: String, success: @escaping(Bool) -> Void) {
        ref.child("tables").child(table).child("players").child(name).setValue(["blackDefWins": 0, "blackOffWins": 0, "redDefWins": 0, "redOffWins": 0, "redSoloWins": 0, "blackSoloWins": 0, "points": 0, "games": 0])
        getPlayers(success: { (players) in
            success(true)
        }) { (err) in
        }
    }

    func deletePlayer(name: String) {
        ref.child("tables").child(table).child("players").child(name).removeValue()
    }

    func finishGame(players: [Player], winner: String) {
        for (_, player) in players.enumerated() {
            var pos = ""
            var wins = 0
            switch player.tempPosition {
            case 1:
                if winner == "red" {
                    wins = player.redDefWins + 1
                } else {
                    wins = player.redDefWins
                }
                pos = "redDefWins"
            case 2:
                if winner == "red" {
                    wins = player.redOffWins + 1
                } else {
                    wins = player.redOffWins
                }
                pos = "redOffWins"
            case 3:
                if winner == "black" {
                    wins = player.blackDefWins + 1
                } else {
                    wins = player.blackDefWins
                }
                pos = "blackDefWins"
            case 4:
                if winner == "black" {
                    wins = player.blackOffWins + 1
                } else {
                    wins = player.blackOffWins
                }
                pos = "blackOffWins"
            default:
                break
            }

            ref.child("tables").child(table).child("players").child(player.name!).child("points").setValue(player.points)

            ref.child("tables").child(table).child("players").child(player.name!).child("games").setValue(player.games + 1)

            if players.count == 2 {
                if (pos == "redDefWins" || pos == "redOffWins") && winner == "red" {
                    ref.child("tables").child(table).child("players").child(player.name!).child("redSoloWins").setValue(player.redSoloWins + 1)
                } else if (pos == "blackDefWins" || pos == "blackOffWins") && winner == "black" {
                    ref.child("tables").child(table).child("players").child(player.name!).child("blackSoloWins").setValue(player.blackSoloWins + 1)
                }
            } else {
                ref.child("tables").child(table).child("players").child(player.name!).child(pos).setValue(wins)
            }

        }

        ref.child("tables").child(table).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let games = value["games"] as? Int {
                    self.ref.child("tables").child(self.table).child("games").setValue(games + 1)
                }
                if winner != "tie" {
                    if winner == "black" {
                        if let blackWins = value["blackWins"] as? Int {
                            self.ref.child("tables").child(self.table).child("blackWins").setValue(blackWins + 1)
                        }
                    } else {
                        if let redWins = value["redWins"] as? Int {
                            self.ref.child("tables").child(self.table).child("redWins").setValue(redWins + 1)
                        }
                    }
                }
            }
        })
    }
}
