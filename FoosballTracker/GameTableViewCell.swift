//
//  GameTableViewCell.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/10/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = addButton.bounds.width / 2
        addButton.clipsToBounds = true
        colorView.layer.cornerRadius = colorView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
