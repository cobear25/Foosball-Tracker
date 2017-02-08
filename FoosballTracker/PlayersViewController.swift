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

    var players: [Player] = []
    var refreshControl = UIRefreshControl()

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        players = APIClient.sharedInstance.players
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

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

        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.getPlayers), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
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
        show(vc, sender: self)
//        let alert = UIAlertController(title: "Please enter player's name", message: nil,preferredStyle: UIAlertControllerStyle.alert)
//        alert.addTextField(configurationHandler: { (textField) in
//            textField.placeholder = "Player name"
//            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
//        })
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
//            if let tf = alert.textFields?.first {
//                if let name = tf.text {
//                    if !name.isEmpty {
//                        APIClient.sharedInstance.createPlayer(name: name, success: { (done) in
//                            self.players = APIClient.sharedInstance.players
//                            if self.players.count > 0 {
//                                self.tableView.backgroundView?.isHidden = true
//                            } else {
//                                self.tableView.backgroundView?.isHidden = false
//                            }
//                            self.tableView.reloadData()
//                        })
//                    }
//                }
//            }
//        })
//        alert.addAction(saveAction)
//        self.present(alert, animated: true, completion:nil)
    }
    
    func textChanged(sender:UITextField) {
        // add member
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
        vc.player = player
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
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

public extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
