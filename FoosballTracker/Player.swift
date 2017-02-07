//
//  Player.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/6/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name: String?
    var blackDefWins: Int = 0
    var blackOffWins: Int = 0
    var redDefWins: Int = 0
    var redOffWins: Int = 0
    var redSoloWins: Int = 0
    var blackSoloWins: Int = 0
    var games: Int = 0
    var points: Int = 0
    var totalWins: Int = 0
    var losses: Int = 0

    class func initWithJson(json: NSDictionary) -> Player {
        let player = Player()
        player.name = json["name"] as? String
        player.blackDefWins = json["blackDef"] as! Int
        player.blackOffWins = json["blackOff"] as! Int
        player.redDefWins = json["redDef"] as! Int
        player.redOffWins = json["redOff"] as! Int
        player.redSoloWins = json["redSolo"] as! Int
        player.blackSoloWins = json["blackSolo"] as! Int
        player.games = json["games"] as! Int
        player.points = json["points"] as! Int

        player.totalWins = player.blackOffWins + player.blackDefWins + player.redOffWins + player.redDefWins + player.redSoloWins + player.blackSoloWins
        player.losses = player.games - player.totalWins
        return player
    }
}
