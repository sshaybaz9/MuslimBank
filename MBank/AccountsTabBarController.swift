//
//  AccountsTabBarController.swift
//  MBank
//
//  Created by Mac on 12/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

extension UITabBar {
    
    
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 40
        
        return sizeThatFits
    }
}

class AccountsTabBarController: UITabBarController {
    
   
   
    
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
