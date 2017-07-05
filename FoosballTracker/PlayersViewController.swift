//
//  SecondViewController.swift
//  Foosball Tracker
//
//  Created by Cody Mace on 11/1/16.
//  Copyright © 2016 codymace. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    @IBOutlet weak var newPlayerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!

    var players: [Player] = []
    var refreshControl = UIRefreshControl()
    var addToMatch = false
    var selectedPlayerDelegate: SelectedPlayerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        players = APIClient.sharedInstance.players
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        APIClient.sharedInstance.getPlayers(success: { (players) in
            self.players = players
            if players.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            print("error getting players: \(error.localizedDescription)")
        }

        let view: PlayersEmptyStateView = PlayersEmptyStateView.fromNib()
        view.button.addTarget(self, action: #selector(self.newPlayerButtonTapped(_:)), for: .touchUpInside)
        tableView.backgroundView = view
        tableView.backgroundView?.isHidden = true

        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.getPlayers), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if addToMatch {
            var frame = tableView.frame
            frame.origin.y += 20
            tableView.frame = frame

            backButton.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.players.count > 0 {
            self.tableView.backgroundView?.isHidden = true
        } else {
            self.tableView.backgroundView?.isHidden = false
        }
        self.tableView.reloadData()
    }

    func getPlayers() {
        APIClient.sharedInstance.getPlayers(success: { (players) in
            self.refreshControl.endRefreshing()
            self.players = players
            if players.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            self.refreshControl.endRefreshing()
            print("error getting players: \(error.localizedDescription)")
            if self.players.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
            self.tableView.reloadData()
        }
    }

    @IBAction func newPlayerButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewPlayerViewController") as! NewPlayerViewController
        vc.addToMatch = self.addToMatch
        show(vc, sender: self)
    }

    func textChanged(sender:UITextField) {
        // add member
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension PlayersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerTableViewCell
        let player = players[indexPath.row]
        cell.playerLabel.text = player.name ?? ""
        cell.winLossLabel.text = "\(player.totalWins) : \(player.losses)"
        if player.blackOffWins + player.redOffWins > player.blackDefWins + player.redDefWins {
            cell.bestPositionLabel.text = "Best Position: Offense"
        } else if player.blackOffWins + player.redOffWins == player.blackDefWins + player.redDefWins {
            cell.bestPositionLabel.text = "Best Position: Any"
        } else {
            cell.bestPositionLabel.text = "Best Position: Defense"
        }
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        if addToMatch && selectedPlayerDelegate != nil {
            selectedPlayerDelegate?.playerSelected(player: player)
            dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
            vc.player = player
            vc.addToMatch = self.addToMatch
            self.show(vc, sender: self)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let player = players[indexPath.row]
            APIClient.sharedInstance.deletePlayer(name: player.name!)
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            if self.players.count > 0 {
                self.tableView.backgroundView?.isHidden = true
            } else {
                self.tableView.backgroundView?.isHidden = false
            }
        }
    }
}

protocol SelectedPlayerDelegate: class {
    func playerSelected(player: Player)
}

public extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
