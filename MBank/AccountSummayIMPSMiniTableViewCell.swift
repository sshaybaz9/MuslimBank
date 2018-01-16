//
//  AccountSummayIMPSMiniTableViewCell.swift
//  MBank
//
//  Created by Mac on 16/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AccountSummayIMPSMiniTableViewCell: UITableViewCell {
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var transaction1: UILabel!

    @IBOutlet weak var amount1: UILabel!
    @IBOutlet weak var transaction2: UILabel!
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var date2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
