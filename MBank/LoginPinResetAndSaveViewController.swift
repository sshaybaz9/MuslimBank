//
//  LoginPinResetAndSaveViewController.swift
//  MBank
//
//  Created by Mac on 13/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import RNCryptor


class LoginPinResetAndSaveViewController: UIViewController,UITextFieldDelegate {
   
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    var mobileno : String?
    
    @IBOutlet weak var LoginPintxt: UITextField!
    @IBOutlet weak var ConfirmPintxt: UITextField!
  
    var key = "1234567890123456"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.LoginPintxt.delegate = self
        self.ConfirmPintxt.delegate =  self
        
        mobileno = UserDefaults.standard.string(forKey: "MobileNumber")
        
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SavePin(_ sender: AnyObject) {
        
        
        self.indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        if Connectivity.isConnectedToInternet()
        {
        
        
        if LoginPintxt.text != nil
        {
        
        
        let ciphertext = RNCryptor.encrypt(data: (LoginPintxt.text!.data(using: String.Encoding.utf8)!), withPassword: key)
        
        
        var responseString : String!
        
        let Encrypted = ciphertext.base64EncodedString()
        
        let   seckey = mobileno! + Encrypted
        
           print(seckey)
        
       
            
            let url = URL(string: Constant.POST.SETUPLOGINPIN.SETUPPIN)!
   
            
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let postString = "mobileno=\(mobileno!)&loginpin=\(Encrypted)&seckey=\(seckey)"
        
        print(postString)
        
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
            
            responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            self.indicator.stopAnimating()
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        }
        else{
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
                
                
                self.indicator.stopAnimating()
                
                return
                
            })


                        let alert = UIAlertController(title: "Alert", message: "Enter the field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
            
        }
        
        
        else {
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
                
                
                self.indicator.stopAnimating()
                
                return
                
            })
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

            
        }
        
        
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){

        
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            let Login = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginMobileViewController
            
            
            self.navigationController?.pushViewController(Login, animated: true)
            
            OperationQueue.main.addOperation{

            self.present(Login, animated: true, completion: nil)
            }
        }
        else if((JSondata.value(forKey: "success") as! Int) == 0){
            
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
                
                
                self.indicator.stopAnimating()
                
                return
                
            })

            let alert = UIAlertController()
            
            alert.message = JSondata.value(forKey: "message") as? String
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        
        
    }


    
}
