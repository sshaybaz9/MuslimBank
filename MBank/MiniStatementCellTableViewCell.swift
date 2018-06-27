//
//  MiniStatementCellTableViewCell.swift
//  MBank
//
//  Created by Mac on 21/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MiniStatementCellTableViewCell: UITableViewCell {
    @IBOutlet weak var stmt1: UILabel!
    @IBOutlet weak var stmt: UILabel!
    @IBOutlet weak var amount1: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var CRDR: UILabel!
    @IBOutlet weak var CRDR1: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var date1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
