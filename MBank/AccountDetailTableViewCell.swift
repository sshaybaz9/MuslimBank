//
//  AccountDetailTableViewCell.swift
//  MBank
//
//  Created by Mac on 16/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var summaryBtn: UIButton!
    @IBOutlet weak var accountNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
