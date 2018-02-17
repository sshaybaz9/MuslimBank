//
//  OpenFixedDepositViewController.swift
//  MBank
//
//  Created by Mac on 01/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class OpenFixedDepositViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var selectScheme: UIButton!

    @IBOutlet weak var tableview: UITableView!
    var fixedArray = [FixedDeposit]()
    var schemeID : String!
    
    @IBOutlet weak var transferAmountlbl: UILabel!
    @IBOutlet weak var transferaccounttxt: UITextField!
    @IBOutlet weak var depositperiodlbl: UILabel!
    @IBOutlet weak var depositperiodtxt: UITextField!
    @IBOutlet weak var depositamounttxt: UITextField!
    @IBOutlet weak var depositAmountlbl: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
   
        
        self.transferaccounttxt.text = accountNumber
        
        
                OpenFixDeposit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectSchemePressed(_ sender: AnyObject) {
        
        self.tableview.reloadData()
        
        self.tableview.isHidden = !self.tableview.isHidden

    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func OpenFixDeposit()
    {
        
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/schemeslist.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var seck = "fd"
        
        let postString = "schemesFor=\(seck)"
        
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
           
                let res = json?.object(forKey: "response") as! NSArray

                
                for item in res
                {
                 
                    var fix = FixedDeposit()
                    
                    let obj = item as! NSDictionary

                    
                fix.depositScheme  = obj.value(forKey: "DepositSchemeId") as! String!
  
//print(self.schemeID)
                    
                    
                fix.schemeName = obj.value(forKey: "SchemeName") as! String!
                    
                    self.fixedArray.append(fix)
                    
                    
                    print(fix)
                }
                print(json)
                
                self.parsingTheJsonData(JSondata: json!)
                self.tableview.reloadData()
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    func parsingTheJsonData(JSondata:NSDictionary){

    }
    
    
    
    
            
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        var temp = fixedArray[indexPath.row] as! FixedDeposit
        cell.textLabel?.text = temp.schemeName

        cell.textLabel?.font = UIFont(name:"Avenir", size:10)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        var temp = fixedArray[indexPath.row] as! FixedDeposit

        selectScheme.setTitle(cell?.textLabel?.text, for: .normal)
        self.schemeID = temp.depositScheme
        self.tableview.isHidden = true
    }
    
    @IBAction func startFixDeposit(_ sender: AnyObject) {
        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")

        
        
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/fdaccountopening.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck = self.schemeID + clientID! + self.depositamounttxt.text!
        
        let postString = "deposit_scheme_id=\(self.schemeID!)&customer_id=\(clientID!)&deposit_amount=\(self.depositamounttxt.text!)&deposit_period=\(self.depositperiodtxt.text!)&tranfer_account_no=\(self.transferaccounttxt.text!)&seckey=\(seck)"
        
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
                
                
                print(json)
                
                self.parsingTheJsonData1(JSondata1: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        
    }
    
    
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
        
    }
        
    
    

}


class FixedDeposit{
    
    var depositScheme : String!
    
    var schemeName : String!
    
}


