//
//  AccSetupLoginViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class AccSetupLoginViewController: UIViewController {
    
    
        
    @IBOutlet weak var ConfirmLoginPin: UITextField!

    @IBOutlet weak var loginPin: UITextField!
    @IBOutlet weak var AccountNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.AccountNumber.setBottomLine(borderColor: lineColor)
        self.loginPin.setBottomLine(borderColor: lineColor)
        self.ConfirmLoginPin.setBottomLine(borderColor: lineColor)
        
    }
    
    @IBAction func Save(_ sender: AnyObject) {
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
