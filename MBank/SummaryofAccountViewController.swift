//
//  SummaryofAccountViewController.swift
//  MBank
//
//  Created by Mac on 16/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class SummaryofAccountViewController: UIViewController {

    var sumDetail = AccountDetail()
    
    @IBOutlet weak var IFScodeLBL: UILabel!
    @IBOutlet weak var accountIDLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var accountTypeLbl: UILabel!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var availBalanceLbl: UILabel!
    
    @IBOutlet weak var branchLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var unclearedBalanceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let customerName = UserDefaults.standard.string(forKey: "CustomerName")

        
        
        self.nameLbl.text = customerName
        self.accountLbl.text = sumDetail.accountnumber
        self.accountIDLbl.text = sumDetail.accountId
        self.descriptionLbl.text = sumDetail.description
        self.IFScodeLBL.text = sumDetail.ifsc
        self.branchLbl.text = sumDetail.branch
        self.accountTypeLbl.text = sumDetail.accountType
        self.availBalanceLbl.text = sumDetail.balance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountSummary") as! AccountSummaryandIMPSMiniStatementViewController

        
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func ShowMiniStatement(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MiniStatment") as! MiniStatementViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
        
        
    }
    @IBAction func FundTransfer(_ sender: AnyObject) {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayUsing") as! PayUsingAccountViewController
        
        
        self.present(vc, animated: true, completion: nil)
    }
    

}
