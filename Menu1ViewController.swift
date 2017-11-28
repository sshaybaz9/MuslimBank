//
//  Menu1ViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Menu1ViewController: UIViewController {
    @IBOutlet weak var barbutton: UIBarButtonItem!
    @IBOutlet weak var LeadingContraint: NSLayoutConstraint!

    var menuShowing = false
    
    @IBAction func openMenu(_ sender: AnyObject) {
        
        if(menuShowing)
        {
            LeadingContraint.constant = -140
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
            
        else{
        LeadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing =  !menuShowing
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        // Do any additional setup after loading the view.
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
