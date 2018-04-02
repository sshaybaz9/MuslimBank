//
//  ViewDepositTableViewCell.swift
//  MBank
//
//  Created by Mac on 22/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ViewDepositTableViewCell: UITableViewCell {

    @IBOutlet weak var balance1: UILabel!
    @IBOutlet weak var maturitydate1: UILabel!
    @IBOutlet weak var accno1: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var maturdate: UILabel!
    @IBOutlet weak var accno: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
