//
//  Match.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/9/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class Match: NSObject {
    var players: [Player] = []
    var redDefense: [String] = []
    var redOffense: [String] = []
    var blackDefense: [String] = []
    var blackOffense: [String] = []
    var redScore = 0
    var blackScore = 0
    var playerCount = 0
    var date = ""
    var matchName = ""

    class func initWith(players: [Player], matchName: String) -> Match {
        let match = Match()

        match.players = players

        let format = DateFormatter()
        format.dateFormat = "MMM d  h:mm a"
        match.date = format.string(from: Date())

        if matchName.isEmpty {
            match.matchName = match.date
        }

        match.playerCount = players.count

        for player in players {
            if player.tempPosition == 1 {
                match.redDefense.append(player.name!)
            } else if player.tempPosition == 2 {
                match.redOffense.append(player.name!)
            } else if player.tempPosition == 3 {
                match.blackDefense.append(player.name!)
            } else if player.tempPosition == 4 {
                match.blackOffense.append(player.name!)
            }
        }
        return match
    }

    class func initWithJson(json: NSDictionary) -> Match {
        let match = Match()

        match.matchName = json["matchName"] as! String
        match.redDefense = json["redDefense"] as! [String]
        match.redOffense = json["redOffense"] as! [String]
        match.blackDefense = json["blackDefense"] as! [String]
        match.blackOffense = json["blackOffense"] as! [String]
        match.redScore = json["redScore"] as! Int
        match.blackScore = json["blackScore"] as! Int
        match.playerCount = json["playerCount"] as! Int
        match.date = json["date"] as! String

        return match
    }
}
