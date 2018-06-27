    //
    //  OpenFixedDepositViewController.swift
    //  MBank
    //
    //  Created by Mac on 01/02/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //
    
    
// Under Development proccess
    
    
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

        @IBAction func BackPressed(_ sender: AnyObject) {
            
            
            self.dismiss(animated: true, completion: nil)
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
            
            
            if Connectivity.isConnectedToInternet(){
            var responseString : String!
            
            
            
            let url = URL(string: Constant.POST.SCHEMELIST.schemelist)!

            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let seck = "fd"
            
            let postString = "schemesFor=\(seck)"
            
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
                
                
                var json: NSDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
               
                    let res = json?.object(forKey: "response") as! NSArray

                    
                    for item in res
                    {
                     
                        let fix = FixedDeposit()
                        
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
            
            else
            {
                
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
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
            return fixedArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            
            let temp = fixedArray[indexPath.row] 
            cell.textLabel?.text = temp.schemeName

            cell.textLabel?.font = UIFont(name:"Avenir", size:10)

            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            
            let temp = fixedArray[indexPath.row] 

            selectScheme.setTitle(cell?.textLabel?.text, for: .normal)
            self.schemeID = temp.depositScheme
            self.tableview.isHidden = true
        }
        
        @IBAction func startFixDeposit(_ sender: AnyObject) {
            
            
            
if Connectivity.isConnectedToInternet()
            {
            
            //let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")

            var responseString : String!
            
            let url = URL(string: Constant.POST.OPENFD.openfd)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let seck = self.schemeID + clientID! + self.depositamounttxt.text!
            
            let postString = "deposit_scheme_id=\(self.schemeID!)&customer_id=\(clientID!)&deposit_amount=\(self.depositamounttxt.text!)&deposit_period=\(self.depositperiodtxt.text!)&tranfer_account_no=\(self.transferaccounttxt.text!)&seckey=\(seck)"
            
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
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
        func parsingTheJsonData1(JSondata1:NSDictionary){
            
            
        }
            
        
        

    }


    class FixedDeposit{
        
        var depositScheme : String!
        
        var schemeName : String!
        
    }


