//
//  MiniStatementViewController.swift
//  MBank
//
//  Created by Mac on 21/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MiniStatementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var arr = [String]()
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        MiniStatementPressed()


        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  func MiniStatementPressed()
  {
    
    let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    let clientID = UserDefaults.standard.string(forKey: "ClientID")
    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
    
    var responseString : String!
    
    
    
    let url = URL(string: "http://115.117.44.229:8443/Mbank_api/cbsministatement.php")!
    
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
            
            
            self.arr = (json?.value(forKey: "statements") as! NSArray) as! [String]
            

            
            
            print(self.arr)
            
            self.parsingTheJsonData(JSondata: json!)
            self.tableview.reloadData()

        }   catch {
            print(error)
        }
        
   //35975151
    }
    task.resume()

    }
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        self.tableview.reloadData()

    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(arr)
     return arr.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = arr[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Avenir", size:10)

       return cell
        
    }
    
    
}
