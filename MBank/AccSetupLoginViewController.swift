//
//  AccSetupLoginViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Foundation
import RNCryptor



class AccSetupLoginViewController: UIViewController,PassMobileNumber,UITextFieldDelegate {
    
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    var isIphone = 1

    
    @IBOutlet weak var ConfirmLoginPin: UITextField!

    @IBOutlet weak var loginPin: UITextField!
    @IBOutlet weak var AccountNumber: UITextField!

     var key = "1234567890123456"
    
    
    var mobileNumber : String!
    var deviceID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfirmLoginPin.delegate = self
        self.loginPin.delegate = self
        self.AccountNumber.delegate = self
        
        
        
        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        

        
        
    }
    //then you should implement the func named textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.AccountNumber.setBottomLine(borderColor: lineColor)
        self.loginPin.setBottomLine(borderColor: lineColor)
        self.ConfirmLoginPin.setBottomLine(borderColor: lineColor)
        
    }
    
    @IBAction func Save(_ sender: AnyObject) {
        
        
        self.indicator.startAnimating()
        
        if Connectivity.isConnectedToInternet
        
        
        {
        
        
        if(loginPin.text != ConfirmLoginPin.text)
        {
            
            let alert = UIAlertController(title: "Does Not Match", message: "Please Enter Same", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        var responseString : String!

        let ciphertext = RNCryptor.encrypt(data: (loginPin.text?.data(using: String.Encoding.utf8)!)!, withPassword: key)
        
//     print(ciphertext)
        
        let  Encrypted = ciphertext.base64EncodedString()
        
        
//        print(Encrypted)

        let  seckey = mobileNumber + Encrypted
     
 //   print(seckey)
        
        
    var request = URLRequest(url: URL(string: Constant.POST.SETUPPINVERIFICATION.SETUPPINVERIFY)!)
        
        
        request.httpMethod = "POST"
    let postString = "mobileno=\(mobileNumber!)&account_no=\(AccountNumber.text!)&loginpin=\(Encrypted)&seckey=\(seckey)&isIphone=\(isIphone)"
        
      print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
self.indicator.stopAnimating()
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                self.parsingTheJsonData(JSondata: json!)
            } catch {
                print(error)
            }
        }
        task.resume()
            
        }
        
        else{
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
        var successMessage : String = String()
        var verificationStatus:Int = Int()
        
        let verficationAlert = UIAlertController()
        if((JSondata.value(forKey: "success") as! Int) == 1){//
            
            
        let Log = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginMobileViewController
                //   Passing Mobile to Passing Mobile Number to AccessSetUpViewController
               
                
                self.navigationController?.pushViewController(Log, animated: true)
                
            OperationQueue.main.addOperation {
                
                self.present(Log, animated: true, completion: nil)

            }
            
            
        }else if((JSondata.value(forKey: "success") as! Int) == 0){
            
            
            self.indicator.stopAnimating()
            
            
            verificationStatus =  JSondata.value(forKey: "success") as! Int
            successMessage = "Invalid Account number"
            verficationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        }
        verficationAlert.title = successMessage
     //   verficationAlert.message = JSondata.value(forKey: "message") as! String
        OperationQueue.main.addOperation {
            self.present(verficationAlert, animated:true, completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Delegate function to get the verfication
    func PassNumber(mobileNumber2: String,deviceID2: String) {
        
        
        mobileNumber =  mobileNumber2
        deviceID = deviceID2
        
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
