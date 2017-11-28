//
//  MobileOTPViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MobileOTPViewController: UIViewController {

    var temp : String!
    var temp1 : String!
    
    @IBOutlet weak var Numtxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func ProceedBtn(_ sender: AnyObject) {
        
        var request = URLRequest(url: URL(string: "http://115.117.44.229:8443/Mbank_api/verifyactivationcode.php")!)
        
        request.httpMethod = "POST"
        
        var conc = "Numtxt.text!"+"temp"
        let postString = "activation_code=\(Numtxt.text!)&mobile_number=\(temp)&seck=\(conc)&deviceId=\(temp1)"
        
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
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let msg = json.value(forKey: "message") as! NSString!
            
//            var succ = json.value(forKey: "success") as! Int!
//            
//            var  id = json.value(forKey: "usr_id") as! String!
//            
//            var code = json.value(forKey: "verificationcode") as! String!
//            
            
            
            print(json)
            
            
            let alert2 = UIAlertController(title: "Generate OTP", message: "\(msg!)", preferredStyle: .alert )
            
                       
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
        self.Numtxt.setBottomLine(borderColor: lineColor)
        
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
