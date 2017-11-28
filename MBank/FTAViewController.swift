//
//  FTAViewController.swift
//  MBank
//
//  Created by Mac on 22/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class FTAViewController: UIViewController {
    @IBOutlet weak var IFSCtxt: UITextField!

    @IBOutlet weak var Beneficarytxt: UITextField!
    @IBOutlet weak var Transactiontxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Beneficarytxt.setBottomLine(borderColor: lineColor)
        self.Transactiontxt.setBottomLine(borderColor: lineColor)
        self.IFSCtxt.setBottomLine(borderColor: lineColor)
        
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
