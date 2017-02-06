//
//  FirstViewController.swift
//  Foosball Tracker
//
//  Created by Cody Mace on 11/1/16.
//  Copyright © 2016 codymace. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    let playerOneDropDown = DropDown()
    let playerTwoDropDown = DropDown()
    let playerThreeDropDown = DropDown()
    let playerFourDropDown = DropDown()
    let playerFiveDropDown = DropDown()
    let playerSixDropDown = DropDown()
    let playerSevenDropDown = DropDown()
    let playerEightDropDown = DropDown()

    @IBOutlet var playerButtons: [UIButton]!
    var dropDowns: [DropDown] = []
    var players: [Player] = []
    var playerNames: [String] = []
    let positions = ["Black Def", "Black Off", "Red Def", "Red Off"]

    var r1: Player?
    var r2: Player?
    var r3: Player?
    var r4: Player?

    var b1: Player?
    var b2: Player?
    var b3: Player?
    var b4: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        APIClient.sharedInstance.getPlayers(success: { (players) in
            self.playerNames = []
            self.playerNames.append("None")
            for player in players {
                self.playerNames.append(player.name ?? "")
            }

            self.dropDowns = [self.playerOneDropDown, self.playerTwoDropDown, self.playerThreeDropDown, self.playerFourDropDown, self.playerFiveDropDown, self.playerSixDropDown, self.playerSevenDropDown, self.playerEightDropDown]
            for dd in self.dropDowns {
                dd.dataSource = self.playerNames
            }
            self.players = players
        }) { (err) in
            print(err)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for button in playerButtons {
            button.setTitle("None", for: .normal)
        }
    }

    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        APIClient.sharedInstance.getPlayers(success: { (players) in
            self.playerNames = []
            self.playerNames.append("None")
            for player in players {
                self.playerNames.append(player.name ?? "")
            }

            self.dropDowns = [self.playerOneDropDown, self.playerTwoDropDown, self.playerThreeDropDown, self.playerFourDropDown, self.playerFiveDropDown, self.playerSixDropDown, self.playerSevenDropDown, self.playerEightDropDown]
            for dd in self.dropDowns {
                dd.dataSource = self.playerNames
            }
            self.players = players
        }) { (err) in
            print(err)
        }
        for button in playerButtons {
            button.setTitle("None", for: .normal)
        }
    }
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.p1Black = b1
        vc.p2Black = b2
        vc.p3Black = b3
        vc.p4Black = b4
        
        vc.p1Red = r1
        vc.p2Red = r2
        vc.p3Red = r3
        vc.p4Red = r4
        
        show(vc, sender: self)
    }
    
    @IBAction func playerButtonTapped(_ sender: UIButton) {
        var dropDown: DropDown
        switch sender.tag {
        case 1:
            dropDown = playerOneDropDown
        default:
            dropDown = playerOneDropDown
        }
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        if sender.tag < 5 {
            dropDown.textColor = UIColor(red: 128/255.0, green: 0, blue: 0, alpha: 1)
        } else {
            dropDown.textColor = UIColor.black
        }
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index, item) in
            sender.setTitle(item, for: .normal)
            if index > 0 && self.players.count > 0 { // so that "None" doesn't count as a person
                switch sender.tag {
                case 1:
                    self.r1 = self.players[index - 1]
                case 2:
                    self.r2 = self.players[index - 1]
                case 3:
                    self.r3 = self.players[index - 1]
                case 4:
                    self.r4 = self.players[index - 1]
                case 5:
                    self.b1 = self.players[index - 1]
                case 6:
                    self.b2 = self.players[index - 1]
                case 7:
                    self.b3 = self.players[index - 1]
                case 8:
                    self.b4 = self.players[index - 1]
                default:
                    break
                }
            }
        }
    }
}

