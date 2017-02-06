//
//  PlayerDetailViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/6/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    @IBOutlet weak var bestColorLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var redOffLabel: UILabel!
    @IBOutlet weak var redDefLabel: UILabel!
    @IBOutlet weak var blackOffLabel: UILabel!
    @IBOutlet weak var blackDefLabel: UILabel!
    @IBOutlet weak var pointsScoredLabel: UILabel!
    @IBOutlet weak var gamesLostLabel: UILabel!
    @IBOutlet weak var gamesWonLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!

    var player: Player = Player()

    override func viewDidLoad() {
        super.viewDidLoad()
        gamesPlayedLabel.text = "\(player.games)"
        gamesWonLabel.text = "\(player.totalWins)"
        gamesLostLabel.text = "\(player.losses)"
        pointsScoredLabel.text = "\(player.points)"

        blackDefLabel.text = "\(player.blackDefWins)"
        blackOffLabel.text = "\(player.blackOffWins)"
        redDefLabel.text = "\(player.redDefWins)"
        redOffLabel.text = "\(player.redOffWins)"

        if player.blackOffWins + player.redOffWins > player.blackDefWins + player.redDefWins {
            bestLabel.text = "Offense"
        } else if player.blackOffWins + player.redOffWins == player.blackDefWins + player.redDefWins {
            bestLabel.text = "Any"
        } else {
            bestLabel.text = "Defense"
        }

        if player.blackOffWins + player.blackDefWins > player.redDefWins + player.redOffWins {
            bestColorLabel.text = "Black"
        } else if player.blackOffWins + player.blackDefWins == player.redOffWins + player.redDefWins {
            bestColorLabel.text = "Any"
        } else {
            bestColorLabel.text = "Red"
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
