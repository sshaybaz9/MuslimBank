//
//  AccSetupLoginViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class AccSetupLoginViewController: UIViewController {

    @IBOutlet weak var Accntxt: UITextField!
    @IBOutlet weak var Pintxt: UITextField!
    @IBOutlet weak var ConPintxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Accntxt.setBottomLine(borderColor: lineColor)
        self.Pintxt.setBottomLine(borderColor: lineColor)
        self.ConPintxt.setBottomLine(borderColor: lineColor)
        
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
