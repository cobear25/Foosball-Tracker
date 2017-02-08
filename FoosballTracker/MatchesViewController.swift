//
//  MatchesViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/8/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let view: PlayersEmptyStateView = PlayersEmptyStateView.fromNib()
        view.mainLabel.text = "No Matches"
        view.detailLabel.text = "Create a match and add players to keep track of their stats"
        view.button.setTitle("Create A Match", for: .normal)
        view.button.addTarget(self, action: #selector(self.newMatchButtonTapped(_:)), for: .touchUpInside)
        tableView.backgroundView = view
    }

    @IBAction func newMatchButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        show(vc, sender: self)
    }
}
