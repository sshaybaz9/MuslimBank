//
//  SummaryofAccountViewController.swift
//  MBank
//
//  Created by Mac on 16/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class SummaryofAccountViewController: UIViewController {

    var sumDetail = Login()
    
    @IBOutlet weak var IFScodeLBL: UILabel!
    @IBOutlet weak var accountIDLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var accountTypeLbl: UILabel!
    
    @IBOutlet weak var branchLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var unclearedBalanceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let customerName = UserDefaults.standard.string(forKey: "CustomerName")

        
        
        self.nameLbl.text = customerName
        self.accountIDLbl.text = sumDetail.accID
        self.descriptionLbl.text = sumDetail.Description
        self.IFScodeLBL.text = sumDetail.ifscCode
        self.branchLbl.text = sumDetail.branchName
        self.accountTypeLbl.text = sumDetail.accType
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
      self.dismiss(animated: true, completion: nil)
    }
   
}
