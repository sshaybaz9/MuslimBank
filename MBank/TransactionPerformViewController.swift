//
//  TransactionPerformViewController.swift
//  MBank
//
//  Created by Mac on 22/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TransactionPerformViewController: UIViewController {
    
    
    @IBOutlet weak var Navig: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
   // To change navigation backgroung color
        
    UINavigationBar.appearance().barTintColor = UIColor.orange

    //To change Back button title & icon color
        UINavigationBar.appearance().tintColor = UIColor.white
    
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CaviarDreams", size: 5)!]
        
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
