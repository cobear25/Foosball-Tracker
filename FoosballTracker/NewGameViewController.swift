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

    @IBOutlet weak var matchNameTextField: UITextField!
    @IBOutlet weak var startMatchButton: UIButton!
    @IBOutlet weak var tableviewIphone: UITableView!
    @IBOutlet weak var redTableView: UITableView!
    @IBOutlet weak var blackTableView: UITableView!
//    @IBOutlet var playerButtons: [UIButton]!
    var dropDowns: [DropDown] = []
    var players: [Player] = []
    var playerNames: [String] = []
    let positions = ["Black Def", "Black Off", "Red Def", "Red Off"]
    var currentPlayers: [Player] = []

    var redDefPlayers: [Player] = []
    var redOffPlayers: [Player] = []
    var blackDefPlayers: [Player] = []
    var blackOffPlayers: [Player] = []

    var positionStrings = ["All Positions"]
    var selectedPlayerIndex = IndexPath(row: 0, section: 0)
    var selectedPlayerColor = 0

    var playerCount = 2

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

        setupViews()
    }

    func setupViews() {
        matchNameTextField.attributedPlaceholder = NSAttributedString(string: matchNameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 121/255.0, alpha: 1)])

        if UIDevice.current.userInterfaceIdiom == .pad {
            startMatchButton.layer.cornerRadius = startMatchButton.bounds.height / 2
            redTableView.dataSource = self
            redTableView.delegate = self
            redTableView.register(UINib.init(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            blackTableView.dataSource = self
            blackTableView.delegate = self
            blackTableView.register(UINib.init(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        } else {
            tableviewIphone.dataSource = self
            tableviewIphone.delegate = self
            tableviewIphone.register(UINib.init(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.players = []
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
        r1 = nil
        r2 = nil
        r3 = nil
        r4 = nil
        b1 = nil
        b2 = nil
        b3 = nil
        b4 = nil
//        for button in playerButtons {
//            button.setTitle("None", for: .normal)
//        }
    }

    @IBAction func playerCountChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            playerCount = 2
            positionStrings = ["All Positions"]
        case 1:
            playerCount = 4
            positionStrings = ["Offense", "Defense"]
        default:
            playerCount = 8
            positionStrings = ["Offense 1", "Offense 2", "Defense 1", "Defense 2"]
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            redTableView.reloadData()
            blackTableView.reloadData()
        } else {
            tableviewIphone.reloadData()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        self.currentPlayers.removeAll()
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
//        for button in playerButtons {
//            button.setTitle("None", for: .normal)
//        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func backButtonTapped(_ sender: Any) {
//    }
    @IBAction func textfieldDone(_ sender: UITextField) {
        matchNameTextField.resignFirstResponder()
    }

    @IBAction func startMatchButtonTapped(_ sender: UIButton) {
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


        let newMatch = Match.initWith(players: currentPlayers, matchName: "")
        vc.match = newMatch

        APIClient.sharedInstance.createMatch(match: newMatch) { (done) in
        }
        show(vc, sender: self)
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


        let newMatch = Match.initWith(players: currentPlayers, matchName: "")
        vc.match = newMatch

        APIClient.sharedInstance.createMatch(match: newMatch) { (done) in
        }
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
            let none = index <= 0
            if self.players.count > 0 { // so that "None" doesn't count as a person
                switch sender.tag {
                case 1:
                    if none {
                        if self.r1 != nil && self.currentPlayers.contains(self.r1!) {
                            let i = self.currentPlayers.index(of: self.r1!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.r1 = nil
                    } else {
                        self.r1 = self.players[index - 1]
                        self.r1!.tempPosition = 1
                        self.currentPlayers.append(self.r1!)
                    }
                case 2:
                    if none {
                        if self.r2 != nil && self.currentPlayers.contains(self.r2!) {
                            let i = self.currentPlayers.index(of: self.r2!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.r2 = nil
                    } else {
                        self.r2 = self.players[index - 1]
                        self.r2!.tempPosition = 1
                        self.currentPlayers.append(self.r2!)
                    }
                case 3:
                    if none {
                        if self.r3 != nil && self.currentPlayers.contains(self.r3!) {
                            let i = self.currentPlayers.index(of: self.r3!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.r3 = nil
                    } else {
                        self.r3 = self.players[index - 1]
                        self.r3!.tempPosition = 2
                        self.currentPlayers.append(self.r3!)
                    }
                case 4:
                    if none {
                        if self.r4 != nil && self.currentPlayers.contains(self.r4!) {
                            let i = self.currentPlayers.index(of: self.r4!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.r4 = nil
                    } else {
                        self.r4 = self.players[index - 1]
                        self.r4!.tempPosition = 2
                        self.currentPlayers.append(self.r4!)
                    }
                case 5:
                    if none {
                        if self.b1 != nil && self.currentPlayers.contains(self.b1!) {
                            let i = self.currentPlayers.index(of: self.b1!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.b1 = nil
                    } else {
                        self.b1 = self.players[index - 1]
                        self.b1!.tempPosition = 3
                        self.currentPlayers.append(self.b1!)
                    }
                case 6:
                    if none {
                        if self.b2 != nil && self.currentPlayers.contains(self.b2!) {
                            let i = self.currentPlayers.index(of: self.b2!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.b2 = nil
                    } else {
                        self.b2 = self.players[index - 1]
                        self.b2!.tempPosition = 3
                        self.currentPlayers.append(self.b2!)
                    }
                case 7:
                    if none {
                        if self.b3 != nil && self.currentPlayers.contains(self.b3!) {
                            let i = self.currentPlayers.index(of: self.b3!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.b3 = nil
                    } else {
                        self.b3 = self.players[index - 1]
                        self.b3!.tempPosition = 4
                        self.currentPlayers.append(self.b3!)
                    }
                case 8:
                    if none {
                        if self.b4 != nil && self.currentPlayers.contains(self.b4!) {
                            let i = self.currentPlayers.index(of: self.b4!)
                            self.currentPlayers.remove(at: i!)
                        }
                        self.b4 = nil
                    } else {
                        self.b4 = self.players[index - 1]
                        self.b4!.tempPosition = 4
                        self.currentPlayers.append(self.b4!)
                    }
                default:
                    break
                }
            }
        }
    }
}

extension NewGameViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableviewIphone {
            return 2
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tableviewIphone {
            if section == 0 {
                return "Red Team"
            } else {
                return "Black Team"
            }
        } else if tableView == redTableView {
            return "Red Team"
        } else {
            return "Black Team"
        }
    }

    func titleFor(tableView: UITableView, section: Int) -> String {
        if tableView == tableviewIphone {
            if section == 0 {
                return "Red Team"
            } else {
                return "Black Team"
            }
        } else if tableView == redTableView {
            return "Red Team"
        } else {
            return "Black Team"
        }
    }

    func colorFor(tableView: UITableView, section: Int) -> UIColor {
        var color: UIColor
        if tableView == tableviewIphone {
            if section == 0 {
                color = UIColor.appRed
            } else {
                color = UIColor.appBlack
            }
        } else if tableView == redTableView {
            color = UIColor.appRed
        } else {
            color = UIColor.appBlack
        }
        return color
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        view.backgroundColor = UIColor.white

        let label = UILabel(frame: CGRect(x: 18, y: 12, width: self.view.frame.size.width, height: 38))
        label.text = titleFor(tableView: tableView, section: section)
        label.textColor = colorFor(tableView: tableView, section: section)
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        view.addSubview(label)
        
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerCount / 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        cell.positionLabel.text = positionStrings[indexPath.row]

        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        }

        if tableView == tableviewIphone {
            if indexPath.section == 0 {
                cell.colorView.backgroundColor = UIColor.appRed
            } else {
                cell.colorView.backgroundColor = UIColor.appBlack
            }
        } else if tableView == redTableView {
            cell.colorView.backgroundColor = UIColor.appRed
        } else {
            cell.colorView.backgroundColor = UIColor.appBlack
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlayerIndex = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlayersViewController") as! PlayersViewController
        vc.addToMatch = true
        vc.selectedPlayerDelegate = self
        if tableView == redTableView {
            selectedPlayerColor = 0
        } else {
            selectedPlayerColor = 1
        }
        self.present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension NewGameViewController: SelectedPlayerDelegate {
    func playerSelected(player: Player) {
        var cell: GameTableViewCell
        var tableView: UITableView
        if UIDevice.current.userInterfaceIdiom == .pad {
            if selectedPlayerColor == 0 {
                cell = redTableView.cellForRow(at: selectedPlayerIndex) as! GameTableViewCell
                tableView = redTableView
            } else {
                cell = blackTableView.cellForRow(at: selectedPlayerIndex) as! GameTableViewCell
                tableView = blackTableView
            }
        } else {
            cell = tableviewIphone.cellForRow(at: selectedPlayerIndex) as! GameTableViewCell
            tableView = tableviewIphone
        }
        cell.nameLabel.text = player.name
        let image = player.image ?? UIImage(named: "profile-default")
        cell.addButton.setImage(image, for: .normal)
        tableView.reloadData()
    }
}
