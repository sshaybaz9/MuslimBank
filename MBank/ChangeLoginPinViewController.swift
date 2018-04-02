//
//  ChangeLoginPinViewController.swift
//  MBank
//
//  Created by Mac on 07/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import RNCryptor

class ChangeLoginPinViewController: UIViewController {

    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    @IBOutlet weak var currentPin: UITextField!
    
    
    
    @IBOutlet weak var newPin: UITextField!
    
    @IBOutlet weak var confirmPin: UITextField!
    
    
    var key = "1234567890123456"

    var isIphone = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func ProceedToChange(_ sender: AnyObject) {
        
        self.indicator.startAnimating()
      if Connectivity.isConnectedToInternet
      {
        
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")

        
        let ciphertext = RNCryptor.encrypt(data: (currentPin.text!.data(using: String.Encoding.utf8)!), withPassword: key)
        
        
        var Encrypted = ciphertext.base64EncodedString()
        
        
        let ciphertext1 = RNCryptor.encrypt(data: (newPin.text!.data(using: String.Encoding.utf8)!), withPassword: key)
        
        
                
        var Encrypted1 = ciphertext1.base64EncodedString()
        

        
        
        var seck = mobileNumber! + "1234"
        
        
        var responseString : String!
        
        
        
        
        
        let url = URL(string: Constant.POST.CHANGELOGINPIN.changeLoginPin)!
        
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //oldCipher,newCipher,mobile_no,seck= mobile+"1234"

        let postString = "oldCipher=\(Encrypted)&newCipher=\(Encrypted1)&mobile_no=\(mobileNumber!)&seck=\(seck)&isIphone=\(isIphone)"
        
        print(postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            self.indicator.stopAnimating()
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                
                print(json)
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()

        }
        
        else
        
      {
        
        self.indicator.stopAnimating()
        
        let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
        
        var action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

        
        }
    }
    
    
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
    }
}

//AwEMY963WUUhXTCmQ9K97Lk+6hFt3/VA/RCOqU1xyanrgsLg8dccxFq+Fkhjo5QrY9Fcb+W50N7LlGok4mc1pSyxnlsGMZ6CycNMoUfIHbtT0A
// AwEMY963WUUhXTCmQ9K97Lk 6hFt3/VA/RCOqU1xyanrgsLg8dccxFq Fkhjo5QrY9Fcb W50N7LlGok4mc1pSyxnlsGMZ6CycNMoUfIHbtT0A==

