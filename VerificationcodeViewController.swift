//
//  VerificationcodeViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class VerificationcodeViewController: UIViewController,UITextFieldDelegate {
  
    

    
    
    @IBOutlet weak var Mobtxt: UITextField!
    
    var mobileno : String!
    
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getVerCode(_ sender: AnyObject) {
        
        
//        let dvc = DisplayTableViewController()
//        dvc.temp = empArray
//        self.navigationController?.pushViewController(dvc, animated: true)
//
    let MOPT = MobileOTPViewController()
        
     MOPT.temp = Mobtxt.text!
        print(MOPT.temp)
     MOPT.temp1 = deviceID!
        print(MOPT.temp1)
        self.navigationController?.pushViewController(MOPT, animated: true)
    
        
     var request = URLRequest(url: URL(string: "http://115.117.44.229:8443/Mbank_api/verifyupdatemobileactivation.php")!)
        
        request.httpMethod = "POST"
        
        
        let postString = "mobile_number=\(Mobtxt.text!)&android_id=\(deviceID!)"
        
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                
                
                
            }
            
//            let Mob = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! MobileOTPViewController
//            
//            self.navigationController?.pushViewController(Mob, animated: true)
//            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let msg = json.value(forKey: "message") as! NSString!
            
            
            print(json)
            
            let alert2 = UIAlertController(title: "Invalid mobile Number", message: "\(msg!)", preferredStyle: .alert )
            alert2.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                
//                let MTP = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! MobileOTPViewController
                
               // self.navigationController?.pushViewController(MTP, animated: true)
            }))
            
            
            alert2.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            //       alert.show()
            OperationQueue.main.addOperation {
                self.present(alert2, animated:true, completion:nil)
            }
            
            
        }
        
        
        task.resume()
        
    }

        
        
        
    
    
    
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Mobtxt.setBottomLine(borderColor: lineColor)
        
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
