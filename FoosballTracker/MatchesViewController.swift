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

    var matches: [Match] = []
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        APIClient.sharedInstance.getMatches(success: { (matches) in
            self.matches = matches
            if matches.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            self.tableView.reloadData()
        }

        let view: PlayersEmptyStateView = PlayersEmptyStateView.fromNib()
        view.mainLabel.text = "No Matches"
        view.detailLabel.text = "Create a match and add players to keep track of their stats"
        view.button.setTitle("Create A Match", for: .normal)
        view.button.addTarget(self, action: #selector(self.newMatchButtonTapped(_:)), for: .touchUpInside)

        tableView.register(UINib.init(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.backgroundView = view
        tableView.backgroundView?.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()

        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.getMatches), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.matches.count > 0 {
            self.tableView.backgroundView?.isHidden = true
        } else {
            self.tableView.backgroundView?.isHidden = false
        }
        self.tableView.reloadData()
    }

    func getMatches() {
        APIClient.sharedInstance.getMatches(success: { (matches) in
            self.refreshControl.endRefreshing()
            self.matches = matches
            if matches.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            self.refreshControl.endRefreshing()
            print("error getting players: \(error.localizedDescription)")
            if self.matches.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }
    }

    @IBAction func newMatchButtonTapped(_ sender: Any) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let vc = NewGameViewController(nibName: "NewMatchViewController-pad", bundle: nil)
            show(vc, sender: self)
        } else {
            let vc = NewGameViewController(nibName: "NewMatchViewController-phone", bundle: nil)
            show(vc, sender: self)
        }
    }
}

extension MatchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MatchTableViewCell
        let match = matches[indexPath.row]
        cell.matchNameLabel.text = match.matchName
        cell.playerCountLabel.text = "Players: \(match.playerCount)"
        cell.redScoreLabel.text = "\(match.redScore)"
        cell.blackScoreLabel.text = "\(match.blackScore)"
        cell.dateLabel.text = match.date

        for circle in cell.circleViews {
            if circle.tag <= match.playerCount {
                circle.isHidden = false
            } else {
                circle.isHidden = true
            }
        }

        for label in cell.nameLabels {
            label.text = ""
        }

        let blackPlayers = match.blackDefense + match.blackOffense
        for (index, name) in blackPlayers.enumerated() {
            if index == 0 {
                cell.black1Label.text = name
            } else if index == 1 {
                cell.black2Label.text = name
            } else if index == 2 {
                cell.black3Label.text = name
            } else if index == 3 {
                cell.black4Label.text = name
            }
        }

        let redPlayers = match.redDefense + match.redOffense
        for (index, name) in redPlayers.enumerated() {
            if index == 0 {
                cell.red1Label.text = name
            } else if index == 1 {
                cell.red2Label.text = name
            } else if index == 2 {
                cell.red3Label.text = name
            } else if index == 3 {
                cell.red4Label.text = name
            }
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let match = matches[indexPath.row]
        if match.playerCount <= 2 {
            return 98
        } else if match.playerCount <= 4 {
            return 124
        } else {
            return 174
        }
    }
}
