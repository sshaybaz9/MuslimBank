//
//  BalanceEnqryViewController.swift
//  MBank
//
//  Created by Mac on 21/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class BalanceEnqryViewController: UIViewController {

    @IBOutlet weak var Balancelbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }

    @IBAction func showBalance(_ sender: AnyObject) {
        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let customerName = UserDefaults.standard.string(forKey: "CustomerName")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/balanceinquiry.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck = mobileNumber! + accountNumber!
        
        let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_name=\(customerName!)&remitter_clientid=\(clientID!)&seck=\(seck)"
        
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
            
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
            var Bal = json?.object(forKey: "balanceinfo") as? NSDictionary
                
                
            self.Balancelbl.text = Bal?.value(forKey: "Message") as! String!
                
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()

        
    //801713648464
    }
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        
        
    }

   
}
