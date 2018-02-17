//
//  ReferFriendsViewController.swift
//  MBank
//
//  Created by Mac on 11/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ReferFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "services") as! ServicesMenuViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
