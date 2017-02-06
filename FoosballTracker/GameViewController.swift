//
//  GameViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/6/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var black4Button: UIButton!
    @IBOutlet weak var black3Button: UIButton!
    @IBOutlet weak var black2Button: UIButton!
    @IBOutlet weak var black1Button: UIButton!
    @IBOutlet weak var red4Button: UIButton!
    @IBOutlet weak var red3Button: UIButton!
    @IBOutlet weak var red2Button: UIButton!
    @IBOutlet weak var red1Button: UIButton!
    @IBOutlet weak var black4Label: UILabel!
    @IBOutlet weak var black3Label: UILabel!
    @IBOutlet weak var black2Label: UILabel!
    @IBOutlet weak var black1Label: UILabel!
    @IBOutlet weak var red4Label: UILabel!
    @IBOutlet weak var red3Label: UILabel!
    @IBOutlet weak var red2Label: UILabel!
    @IBOutlet weak var red1Label: UILabel!
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!

    var redScore = 0
    var blackScore = 0
    var r1Points = 0
    var r2Points = 0
    var r3Points = 0
    var r4Points = 0
    var b1Points = 0
    var b2Points = 0
    var b3Points = 0
    var b4Points = 0

    var p1Red: Player?
    var p2Red: Player?
    var p3Red: Player?
    var p4Red: Player?

    var p1Black: Player?
    var p2Black: Player?
    var p3Black: Player?
    var p4Black: Player?

    var players: [Player] = []
    var positions: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let r1 = p1Red {
            red1Button.isHidden = false
            red1Label.isHidden = false
            red1Button.setTitle("\(r1.name!) +", for: .normal)
            players.append(r1)
            positions.append(1)
        }
        if let r2 = p2Red {
            red2Button.isHidden = false
            red2Label.isHidden = false
            red2Button.setTitle("\(r2.name!) +", for: .normal)
            players.append(r2)
            positions.append(1)
        }
        if let r3 = p3Red {
            red3Button.isHidden = false
            red3Label.isHidden = false
            red3Button.setTitle("\(r3.name!) +", for: .normal)
            players.append(r3)
            positions.append(2)
        }
        if let r4 = p4Red {
            red4Button.isHidden = false
            red4Label.isHidden = false
            red4Button.setTitle("\(r4.name!) +", for: .normal)
            players.append(r4)
            positions.append(2)
        }

        if let b1 = p1Black {
            black1Button.isHidden = false
            black1Label.isHidden = false
            black1Button.setTitle("\(b1.name!) +", for: .normal)
            players.append(b1)
            positions.append(3)
        }
        if let b2 = p2Black {
            black2Button.isHidden = false
            black2Label.isHidden = false
            black2Button.setTitle("\(b2.name!) +", for: .normal)
            players.append(b2)
            positions.append(3)
        }
        if let b3 = p3Black {
            black3Button.isHidden = false
            black3Label.isHidden = false
            black3Button.setTitle("\(b3.name!) +", for: .normal)
            players.append(b3)
            positions.append(4)
        }
        if let b4 = p4Black {
            black4Button.isHidden = false
            black4Label.isHidden = false
            black4Button.setTitle("\(b4.name!) +", for: .normal)
            players.append(b4)
            positions.append(4)
        }

        for button in buttons {
            button.layer.cornerRadius = 5
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        redScore = 0
        blackScore = 0
        players = []
        r1Points = 0
        r2Points = 0
        r3Points = 0
        r4Points = 0
        b1Points = 0
        b2Points = 0
        b3Points = 0
        b4Points = 0
        positions = []
        for button in buttons {
            button.isHidden = true
        }
        finishButton.isHidden = false
    }

    @IBAction func playerButtonTapped(_ sender: UIButton) {
        if sender == red1Button {
            r1Points += 1
            redScore += 1
        } else if sender == red2Button {
            r2Points += 1
            redScore += 1
        } else if sender == red3Button {
            r3Points += 1
            redScore += 1
        } else if sender == red4Button {
            r4Points += 1
            redScore += 1
        } else if sender == black1Button {
            b1Points += 1
            blackScore += 1
        } else if sender == black2Button {
            b2Points += 1
            blackScore += 1
        } else if sender == black3Button {
            b3Points += 1
            blackScore += 1
        } else {
            b4Points += 1
            blackScore += 1
        }
        blackLabel.text = "Black: \(blackScore)"
        redLabel.text = "Red: \(redScore)"

        red1Label.text = "\(r1Points)"
        red2Label.text = "\(r2Points)"
        red3Label.text = "\(r3Points)"
        red4Label.text = "\(r4Points)"
        
        black1Label.text = "\(b1Points)"
        black2Label.text = "\(b2Points)"
        black3Label.text = "\(b3Points)"
        black4Label.text = "\(b4Points)"
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func finishButtonTapped(_ sender: Any) {
        var winner = "red"
        if blackScore > redScore {
            winner = "black"
        } else if blackScore == redScore {
            winner = "tie"
        }
        var points: [Int] = []
        if let _ = p1Red {
            points.append(r1Points)
        }
        if let _ = p2Red {
            points.append(r2Points)
        }
        if let _ = p3Red {
            points.append(r3Points)
        }
        if let _ = p4Red {
            points.append(r4Points)
        }

        if let _ = p1Black {
            points.append(b1Points)
        }
        if let _ = p2Black {
            points.append(b2Points)
        }
        if let _ = p3Black {
            points.append(b3Points)
        }
        if let _ = p4Black {
            points.append(b4Points)
        }
        
        APIClient.sharedInstance.finishGame(players: players, points: points, positions: positions, winner: winner)
        dismiss(animated: true, completion: nil)
    }
}
