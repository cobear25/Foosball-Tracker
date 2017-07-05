//
//  PlayerDetailViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/6/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!

    var player: Player = Player()
    var addToMatch = false

    enum PlayerStat: Int {
        case gamesPlayed = 0
        case gamesWon
        case gamesLost
        case goals
        case blackOffWins
        case blackDefWins
        case redOffWins
        case redDefWins
        case black1v1Wins
        case red1v1Wins
        case bestPosition
        case bestColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.image = player.image ?? UIImage(named: "profile-default")
        winsLabel.text = "\(player.totalWins)"
        goalsLabel.text =  "\(player.points)"
        
        playerNameLabel.text = "\(player.name!)"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if addToMatch {
            dismiss(animated: true, completion: nil)
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PlayerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text = "Games Played"
        cell.textLabel?.textColor = UIColor.hexColor(0x212121)
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        cell.detailTextLabel?.text = "0"
        cell.detailTextLabel?.textColor = UIColor.hexColor(0x212121)
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        }

        var statText = "Games Played"
        var detailText = "0"
        let playerStat: PlayerStat = PlayerStat(rawValue: indexPath.row)!
        switch playerStat {
        case .gamesPlayed:
            statText = "Games Played"
            detailText = "\(player.games)"
            break
        case .gamesWon:
            statText = "Games Won"
            detailText = "\(player.totalWins)"
        case .gamesLost:
            statText = "Games Lost"
            detailText = "\(player.losses)"
        case .goals:
            statText = "Goals"
            detailText = "\(player.points)"
        case .blackOffWins:
            statText = "Black Offense Wins"
            detailText = "\(player.blackOffWins)"
        case .blackDefWins:
            statText = "Black Defense Wins"
            detailText = "\(player.blackDefWins)"
        case .redOffWins:
            statText = "Red Offense Wins"
            detailText = "\(player.redOffWins)"
        case .redDefWins:
            statText = "Red Defense Wins"
            detailText = "\(player.redDefWins)"
        case .black1v1Wins:
            statText = "Black 1v1 Wins"
            detailText = "\(player.blackSoloWins)"
        case .red1v1Wins:
            statText = "Red 1v1 Wins"
            detailText = "\(player.redSoloWins)"
        case .bestPosition:
            statText = "Best Position"
            if player.blackOffWins + player.redOffWins > player.blackDefWins + player.redDefWins {
                detailText = "Offense"
            } else if player.blackOffWins + player.redOffWins == player.blackDefWins + player.redDefWins {
                detailText = "Any"
            } else {
                detailText = "Defense"
            }
        case .bestColor:
            statText = "Best Color"
            
            if player.blackOffWins + player.blackDefWins + player.blackSoloWins > player.redDefWins + player.redOffWins + player.redSoloWins {
                detailText = "Black"
            } else if player.blackOffWins + player.blackDefWins + player.blackSoloWins == player.redOffWins + player.redDefWins + player.redSoloWins {
                detailText = "Any"
            } else {
                detailText = "Red"
            }
        }

        cell.textLabel?.text = statText
        cell.detailTextLabel?.text = detailText
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
