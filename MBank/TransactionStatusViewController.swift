//
//  TransactionStatusViewController.swift
//  MBank
//
//  Created by Mac on 22/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TransactionStatusViewController: UIViewController {

    var json : NSDictionary?
    
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var beneficiaryName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var TransactionStatus: UILabel!
    @IBOutlet weak var Transactiontype: UILabel!
    @IBOutlet weak var Transactiontxt: UITextField!
    
    @IBOutlet weak var datetime1: UILabel!
    @IBOutlet weak var benName1: UILabel!
    
    
    @IBOutlet weak var message1: UILabel!
    @IBOutlet weak var transtatus1: UILabel!
    @IBOutlet weak var trantype1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activity.isHidden = true
        self.datetime.isHidden = true
        self.beneficiaryName.isHidden = true
        self.message.isHidden = true
        self.TransactionStatus.isHidden = true
        self.Transactiontype.isHidden = true
        
        
        self.datetime1.isHidden = true
        self.benName1.isHidden = true
        self.message1.isHidden = true
        self.transtatus1.isHidden = true
        self.trantype1.isHidden = true
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Transactiontxt.setBottomLine(borderColor: lineColor)
        
    }

    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
     
        
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func transactionStatus(_ sender: AnyObject) {
        
        
        if Connectivity.isConnectedToInternet{
        
        self.activity.isHidden = false
        activity.startAnimating()

        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.TRANSENQUIRY.TRANSENQ)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck = mobileNumber! + accountNumber!
        
        let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&trans_ref_no=\(Transactiontxt.text!)&remitter_clientid=\(clientID!)&seck=\(seck)"
        
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
            
            
            do {
               self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                print(self.json)
               
                
                self.parsingTheJsonData(JSondata: self.json!)
            }   catch {
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
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            
            DispatchQueue.main.async(execute: {

            let enqry = self.json?.value(forKey: "enquiry") as! NSDictionary
            
            let tranDate = enqry.value(forKey: "TrandateTime") as! String
            self.datetime1.text = tranDate
            
            
            
            let tranType = enqry.value(forKey: "TranType") as! String
            self.trantype1.text = tranType
            
            let tranStatus = enqry.value(forKey: "Status") as! String
            self.transtatus1.text = tranStatus
            
            
            let mess = enqry.value(forKey: "ImpsMessage") as! String
            self.message1.text = mess
            
            
            let benName = enqry.value(forKey: "BeneName") as! String
            self.benName1.text = benName
            

            
            self.datetime1.isHidden = false
            self.benName1.isHidden = false
            self.message1.isHidden = false
            self.transtatus1.isHidden = false
            self.trantype1.isHidden = false
            
            
            
            self.activity.isHidden = true
            
            self.datetime.isHidden = false
            self.beneficiaryName.isHidden = false
            self.message.isHidden = false
            self.TransactionStatus.isHidden = false
            self.Transactiontype.isHidden = false
            })
            
        }
        else if ((JSondata.value(forKey: "success") as! Int) == 0){
            self.activity.stopAnimating()
            
            var msg = self.json?.value(forKey: "message") as! String!
            
            let alert = UIAlertController(title: "", message: "\(msg!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
            
            
            
        }
        
        

        
    }
    

}
