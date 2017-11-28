//
//  FixedDepositViewController.swift
//  MBank
//
//  Created by Mac on 21/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class FixedDepositViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var schemetxt: UITextField!
    @IBOutlet weak var TransferAccounttxt: UITextField!

    @IBOutlet weak var DepositPeriodtxt: UITextField!
    @IBOutlet weak var ClientIDtxt: UITextField!
    @IBOutlet weak var DepositAmounttxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        
    // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.schemetxt.setBottomLine(borderColor: lineColor)
        self.ClientIDtxt.setBottomLine(borderColor: lineColor)
        self.DepositAmounttxt.setBottomLine(borderColor: lineColor)
        self.DepositPeriodtxt.setBottomLine(borderColor: lineColor)
        self.TransferAccounttxt.setBottomLine(borderColor: lineColor)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
