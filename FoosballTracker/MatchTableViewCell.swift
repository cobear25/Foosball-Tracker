//
//  MatchTableViewCell.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/9/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var circleViews: [UIView]!
    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var black1Label: UILabel!
    @IBOutlet weak var black2Label: UILabel!
    @IBOutlet weak var black3Label: UILabel!
    @IBOutlet weak var black4Label: UILabel!
    @IBOutlet weak var red1Label: UILabel!
    @IBOutlet weak var red2Label: UILabel!
    @IBOutlet weak var red3Label: UILabel!
    @IBOutlet weak var red4Label: UILabel!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var blackScoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        for view in circleViews {
            view.layer.cornerRadius = view.bounds.width / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
