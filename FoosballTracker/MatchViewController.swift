//
//  MatchViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/13/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var finishMatchButton: UIButton!
    @IBOutlet weak var tableViewIphone: UITableView!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blackScoreLabel: UILabel!
    @IBOutlet weak var redScoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func finishMatchTapped(_ sender: UIButton) {
    }
}
