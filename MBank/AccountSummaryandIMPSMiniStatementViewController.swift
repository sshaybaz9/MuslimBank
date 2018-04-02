    //
    //  AccountSummaryandIMPSMiniStatementViewController.swift
    //  MBank
    //
    //  Created by Mac on 16/01/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //

    import UIKit

    class AccountSummaryandIMPSMiniStatementViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
        
        
        
        
        var json: NSDictionary?

        
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        

        
        @IBOutlet weak var showIMPSMini: UIButton!


        @IBOutlet weak var tableview1: UITableView!
        
        @IBOutlet weak var tableview: UITableView!
        var accountSummIMPS = [AccountSummandIMPS]()
        var accountDetail = [Login]()

        
        var isOn = false
        
        @IBOutlet weak var Amountlbl: UILabel!
        
        @IBOutlet weak var Datellbl: UILabel!
        @IBOutlet weak var Transactionlbl: UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()

            
            
   tableview1.tableFooterView = UIView(frame: .zero)
            
            tableview.isHidden = true
            
            
            
            self.Datellbl.isHidden = true
            self.Transactionlbl.isHidden = true
            self.Amountlbl.isHidden = true
            
            
            
            Accountdetail()
            
            
            
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            

            
        }
        
        
        
        override  func viewDidAppear(_ animated: Bool) {
            self.tableview1.reloadData()
            self.indicator.stopAnimating()

            
        }
        @IBAction func BackPressed(_ sender: AnyObject) {
            
            
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu1ViewController
            
            self.dismiss(animated: true, completion: nil)
        }
        @IBAction func ShowIMPSMini(_ sender: AnyObject) {
          
    
            if isOn == false
            {
               
                
                
                
                if Connectivity.isConnectedToInternet{
                    
                    
                    self.tableview.reloadData()

                
                self.Datellbl.isHidden = false
                self.Transactionlbl.isHidden = false
                self.Amountlbl.isHidden = false
                
                
                
                
                tableview.isHidden = false
                
                self.showIMPSMini.setTitle("Hide Statment", for: .normal)
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            var responseString : String!
            
                
            let url = URL(string: Constant.POST.GETSTATEMENT.STATEMENT)!
                
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
                
                
                do {
                   self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    
                   
                                 DispatchQueue.main.async(execute: {
                        
                        self.tableview.reloadData()
                        
                        return
                        
                    })
                    self.parsingTheJsonData(JSondata: self.json!)

                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()
                isOn = true
                
   
                
                }
            
            
                else
                {
                    
                    
                    let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                    
                    var action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            
            
            
            
            }
    
    
    
                      else{
                
                
                
                self.Transactionlbl.isHidden = true
                self.Datellbl.isHidden = true
                self.Amountlbl.isHidden = true
                tableview.isHidden = true
                self.showIMPSMini.setTitle("Show IMPS MiniStatment", for: .normal)
                isOn = false
                
            }
            
        }
        

        func parsingTheJsonData(JSondata:NSDictionary){
            
            
            
            
            if((JSondata.value(forKey: "success") as! Int) == 1){
                
                
                
                
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
                    
                    
                    
                }

            }else if((JSondata.value(forKey: "success") as! Int) == 0){
            
            
                var msg = self.json?.value(forKey: "message") as! String!

                let alert = UIAlertController(title: "", message: "\(msg!)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
                
                OperationQueue.main.addOperation {
                    
                    self.present(alert, animated:true, completion:nil)
                    
                }

            
            }

        
        }
        
        func Accountdetail()
        {
            
            
if Connectivity.isConnectedToInternet
            {
            let clientID = UserDefaults.standard.string(forKey: "ClientID")

            
            
            
            var responseString : String!
            
            
            
          
            
            let url = URL(string: Constant.POST.GETTRANSACCOUNTS.transaccounts)!
            

            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            var seck =  "MBANK2017"
            
            let postString = "client_id=\(clientID!)&seck=\(seck)"
            
            
            self.indicator.startAnimating()
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
                        
                        
                        
                        let accountobj = Login()
                       accountobj.accID = i?.value(forKey: "AccId") as? String
                      accountobj.accNo = i?.value(forKey: "AccNo") as? String
                        
                        accountobj.Balance = i?.value(forKey: "Balance") as? String
                        accountobj.Description = i?.value(forKey: "Description") as? String
                        accountobj.ifscCode = i?.value(forKey: "ifsccode") as? String
                        accountobj.accType = i?.value(forKey: "AccountType") as? String
                        accountobj.branchName = i?.value(forKey: "BranchName") as? String
                        self.accountDetail.append(accountobj)

                    }
                    DispatchQueue.main.async(execute: {
                        
                        self.tableview1.reloadData()
                        
                        return
                        
                    })
                    
                    self.parsingTheJsonData1(JSondata1: json!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()
            }
            
            else
            {
                
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                var action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }

            
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
                
                cell.accountNo.text = accountDetail[indexPath.row].accNo
                cell.summaryBtn.tag = indexPath.row
                cell.summaryBtn.addTarget(self, action: #selector(isEdit(sender:)), for: .touchUpInside)

                return cell
                

            }
            
            
            return cell!
            
        }
        
        func isEdit(sender: UIButton)
        {
            
            let button = sender
            let cell = button.superview?.superview as? AccountDetailTableViewCell
            let indexPath = tableview1.indexPath(for: cell!)

            let vc = storyboard?.instantiateViewController(withIdentifier: "Sum1Account") as! Summary1AccountBalanceViewController
            
            
            vc.sum1Detail = accountDetail[(indexPath?.row)!]
            vc.sumArray = self.accountDetail
             self.present(vc, animated: true, completion: nil)

            
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
        var accountType : String!
        
    }
