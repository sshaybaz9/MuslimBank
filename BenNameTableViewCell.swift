//
//  BenNameTableViewCell.swift
//  MBank
//
//  Created by Mac on 22/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class BenNameTableViewCell: UITableViewCell {
    @IBOutlet weak var Edit: UIButton!

    @IBOutlet weak var BenNamelbl: UILabel!
    @IBOutlet weak var Delete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
