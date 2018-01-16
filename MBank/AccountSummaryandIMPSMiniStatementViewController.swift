//
//  AccountSummaryandIMPSMiniStatementViewController.swift
//  MBank
//
//  Created by Mac on 16/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class AccountSummaryandIMPSMiniStatementViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var showIMPSMini: UIButton!


    @IBOutlet weak var tableview1: UITableView!
    
    @IBOutlet weak var tableview: UITableView!
    var accountSummIMPS = [AccountSummandIMPS]()
    var accountDetail = [AccountDetail]()

    
    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

     tableview.isHidden = true
        
        Accountdetail()
        
        
    }

    @IBAction func ShowIMPSMini(_ sender: AnyObject) {
        

        
        if isOn == false
        {
            
            tableview.isHidden = false
            
            self.showIMPSMini.setTitle("Hide Statment", for: .normal)
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/getministatement.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck = mobileNumber! + accountNumber!
        
        let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_clientid=\(clientID!)&seck=\(seck)"
        
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
                
               
           var statment = json?.value(forKey: "statement") as! NSDictionary
                
            var records = statment.value(forKey: "Record") as! NSArray
                
                for item in records
                {
                  let i = item as? NSDictionary
                  
                    let accountobj = AccountSummandIMPS()
                    
                    accountobj.date = i?.value(forKey: "TranDateTime") as? String
                    
                    accountobj.transaction = i?.value(forKey: "TranType") as? String
                    accountobj.amount = i?.value(forKey: "TranAmount") as? String
                    
                    self.accountSummIMPS.append(accountobj)
                    
                    self.tableview.reloadData()

                    
                }
                
                print(json)
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
            isOn = true
        }else{
            
            tableview.isHidden = true
            self.showIMPSMini.setTitle("Show IMPS MiniStatment", for: .normal)
            isOn = false
            
        }
        
    }
    

    func parsingTheJsonData(JSondata:NSDictionary){
    
    }
    
    func Accountdetail()
    {
        let clientID = UserDefaults.standard.string(forKey: "ClientID")

        
        
        
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/getTransAccounts.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck =  "MBANK2017"
        
        let postString = "client_id=\(clientID!)&seck=\(seck)"
        
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
                
        var accounts = json?.value(forKey: "accounts") as! NSDictionary
        
                var clientAccnt = accounts.value(forKey: "clientAccounts") as! NSArray
                
                for item in clientAccnt
                {
                    let i = item as? NSDictionary
                    
                    let accountobj = AccountDetail()
                   accountobj.accountId = i?.value(forKey: "AccId") as? String
                  accountobj.accountnumber = i?.value(forKey: "AccNo") as? String
                    accountobj.balance = i?.value(forKey: "Balance") as? String
                    accountobj.description = i?.value(forKey: "Description") as? String
                    accountobj.ifsc = i?.value(forKey: "ifsccode") as? String
                    
                    self.accountDetail.append(accountobj)
                    
                    self.tableview1.reloadData()
                }
                
                
                self.parsingTheJsonData1(JSondata1: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        

        
    }
    
    func parsingTheJsonData1(JSondata1:NSDictionary){
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var count : Int?
        if tableView == self.tableview{
        
        count =  accountSummIMPS.count
        }
        if tableView == self.tableview1
        {
            count = accountDetail.count
        }
        return count!
        
           }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?

        
        if tableView == tableview{
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! AccountSummayIMPSMiniTableViewCell
        
        cell.date2.text = accountSummIMPS[indexPath.row].date
        cell.transaction2.text = accountSummIMPS[indexPath.row].transaction
        cell.amount2.text = accountSummIMPS[indexPath.row].amount
        return cell
        }
        
        if tableView == tableview1
        {
            
        
          let  cell = tableview1.dequeueReusableCell(withIdentifier: "cell") as! AccountDetailTableViewCell
            
            cell.accountNo.text = accountDetail[indexPath.row].accountnumber
            cell.summaryBtn.tag = indexPath.row
            
            return cell
        }
        
        
        return cell!
        
    }
    

    
    
    
   }


class AccountSummandIMPS
{
    var date : String!
    var transaction : String!
    var amount : String!
    
    
    
}
class AccountDetail
{
    var accountnumber : String!
    var balance : String!
    var branch  : String!
    var description : String!
    var accountId : String!
    var ifsc : String!
    
}
