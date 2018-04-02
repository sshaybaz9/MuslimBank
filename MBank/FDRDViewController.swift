//
//  FDRDViewController.swift
//  MBank
//
//  Created by Mac on 26/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class FDRDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func openFD(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "openFD") as! OpenFixedDepositViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }

    @IBAction func openRD(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "openRD") as! OpenRecurringDepositViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    @IBAction func viewDeposit(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewDeposit") as! ViewDepositViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    

}
