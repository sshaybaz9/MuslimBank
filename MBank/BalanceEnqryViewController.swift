//
//  BalanceEnqryViewController.swift
//  MBank
//
//  Created by Mac on 21/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class BalanceEnqryViewController: UIViewController {

    var json : NSDictionary?
    
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var Balancelbl: UILabel!
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
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
   //     let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
                self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func showBalance(_ sender: AnyObject) {
        
        self.indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
        if Connectivity.isConnectedToInternet()
        
        {
        
        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let customerName = UserDefaults.standard.string(forKey: "CustomerName")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.BALANCEINQUIRY.INQUIRY)!
        
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let seck = mobileNumber! + accountNumber!
        
        let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_name=\(customerName!)&remitter_clientid=\(clientID!)&seck=\(seck)"
        
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
            
            
            
            do {
                self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
            let Bal = self.json?.object(forKey: "balanceinfo") as? NSDictionary
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.Balancelbl.text = Bal?.value(forKey: "Message") as! String!
                   self.indicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    return
                    
                })
                
                
                
                
                
                self.parsingTheJsonData(JSondata: self.json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()

        }
        
        
        else
        {
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    //801713648464
    }
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            
            
            
                  }
        else if ((JSondata.value(forKey: "success") as! Int) == 0){
            
            DispatchQueue.main.async(execute: { 
                self.indicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            
            let msg = self.json?.value(forKey: "message") as! String!
            
            let alert = UIAlertController(title: "", message: "\(msg!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
            
            
            
        }
        
        

        
        
    }

   
}
