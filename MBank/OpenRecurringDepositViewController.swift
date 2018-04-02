    //
    //  OpenRecurringDepositViewController.swift
    //  MBank
    //
    //  Created by Mac on 02/02/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //

    import UIKit

    class OpenRecurringDepositViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

        @IBOutlet weak var insatllmenttxt: UITextField!
        @IBOutlet weak var transferAccounttxt: UITextField!
        @IBOutlet weak var depositPeriodtxt: UITextField!
        @IBOutlet weak var depositAmounttxt: UITextField!
        @IBOutlet weak var tableview: UITableView!
        var recurringArray = [RecurringDeposit]()
        var schemeID : String!
        @IBOutlet weak var selectScheme: UIButton!
        override func viewDidLoad() {
            super.viewDidLoad()

            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            
            
            self.transferAccounttxt.text = accountNumber
            

            
            
                OpenRecurringDeposit()
        }

        @IBAction func BackPressed(_ sender: AnyObject) {
            
            
            
            
            self.dismiss(animated: true, completion: nil)
        }
        @IBAction func selectSchemePressed(_ sender: AnyObject) {
            
            
            self.tableview.reloadData()
            
            self.tableview.isHidden = !self.tableview.isHidden

        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        func OpenRecurringDeposit()
        {
            
            
if Connectivity.isConnectedToInternet
            
            
{
    
    var responseString : String!
            
            let url = URL(string: Constant.POST.SCHEMELIST.schemelist)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var seck = "rd"
            
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
                        
                        var recur = RecurringDeposit()
                        
                        let obj = item as! NSDictionary
                        
                        
                        recur.depositSchemeID  = obj.value(forKey: "DepositSchemeId") as! String!
                        
                        
                        
                        
                        recur.schemeName = obj.value(forKey: "SchemeName") as! String!
                        
                        self.recurringArray.append(recur)
                        
                        
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
            else
            {
                
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                var action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        func parsingTheJsonData(JSondata:NSDictionary){
            
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return recurringArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            
            var temp = recurringArray[indexPath.row] as! RecurringDeposit
            cell.textLabel?.text = temp.schemeName
            cell.textLabel?.font = UIFont(name:"Avenir", size:10)

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            
            var temp = recurringArray[indexPath.row] as! RecurringDeposit

            selectScheme.setTitle(cell?.textLabel?.text, for: .normal)
            self.schemeID = temp.depositSchemeID
            self.tableview.isHidden = true
        }
        
        
        
        
        
        @IBAction func OpenRecurring(_ sender: AnyObject) {
            
            
            if Connectivity.isConnectedToInternet{
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")
            
            var responseString : String!
            
            let url = URL(string: Constant.POST.OPENRD.openrd)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            var seck = self.schemeID + clientID! + self.depositAmounttxt.text!
            
            
            

            let postString = "deposit_scheme_id=\(self.schemeID!)&customer_id=\(clientID!)&deposit_amount=\(self.depositAmounttxt.text!)&deposit_period=\(self.depositPeriodtxt.text!)&tranfer_account_no=\(self.transferAccounttxt.text!)&seckey=\(seck)"
            
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
        

    }

    class RecurringDeposit{
        
        
            var depositSchemeID : String!
            
            var schemeName : String!
        
    }
