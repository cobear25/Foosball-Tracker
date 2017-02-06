//
//  PlayerTableViewCell.swift
//  Foosball Tracker
//
//  Created by Cody Mace on 11/1/16.
//  Copyright © 2016 codymace. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var winLossLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
