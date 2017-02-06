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

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        players = APIClient.sharedInstance.players
        
        newPlayerButton.layer.cornerRadius = 5
        newPlayerButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        newPlayerButton.layer.shadowOpacity = 0.5
        newPlayerButton.layer.shadowColor = UIColor.darkGray.cgColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        players = APIClient.sharedInstance.players
        tableView.reloadData()
    }

    @IBAction func newPlayerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Please enter player's name", message: nil,preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Player name"
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let tf = alert.textFields?.first {
                if let name = tf.text {
//                    APIClient.sharedInstance.createPlayer(name: name)
                    APIClient.sharedInstance.createPlayer(name: name, success: { (done) in
                        self.players = APIClient.sharedInstance.players
                        self.tableView.reloadData()
                    })
                }
                print("name saved: \(tf.text)")
            }
        })
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion:nil)
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
        cell.winLossLabel.text = "\(player.totalWins)/\(player.losses)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
        vc.player = player
        show(vc, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
}

