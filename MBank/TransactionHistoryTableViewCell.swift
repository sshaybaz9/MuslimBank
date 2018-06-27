//
//  TransactionHistoryTableViewCell.swift
//  MBank
//
//  Created by Mac on 10/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Trantype2: UILabel!
    
    @IBOutlet weak var status2: UILabel!
    
    @IBOutlet weak var Tranrefnum2: UILabel!
    
    @IBOutlet weak var date2: UILabel!
    
    @IBOutlet weak var Tranrefnum1: UILabel!
    
    @IBOutlet weak var status1: UILabel!
    
    @IBOutlet weak var Trantype1: UILabel!
    
    @IBOutlet weak var StatusButton: UIButton!
    
    @IBOutlet weak var benaccount: UILabel!
    @IBOutlet weak var tranAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
