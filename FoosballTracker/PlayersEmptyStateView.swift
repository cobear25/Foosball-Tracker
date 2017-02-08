//
//  PlayersEmptyStateView.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/8/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class PlayersEmptyStateView: UIView {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = button.bounds.height / 2
    }
}
