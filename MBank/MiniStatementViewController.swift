//
//  MiniStatementViewController.swift
//  MBank
//
//  Created by Mac on 21/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Foundation
class MiniStatementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var json : NSDictionary?
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    @IBOutlet weak var tableview: UITableView!
    
    var arr = [String]()
    var arr1 = [MiniStatement]()

    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
   //     let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
            self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet(){
        
        MiniStatementPressed()
       
        }
        else
        {
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }

        

        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        

        
        // Do any additional setup after loading the view.
    }

    override  func viewDidAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  func MiniStatementPressed()
  {
    if Connectivity.isConnectedToInternet() {
    
    let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    let clientID = UserDefaults.standard.string(forKey: "ClientID")
    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
    
    var responseString : String!
    
    let url = URL(string: Constant.POST.SHOWMINISTATEMENT.ministatement)!
    
    var request = URLRequest(url: url)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let seck = mobileNumber! + accountNumber!
    
    let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_name=\(customerName!)&remitter_clientid=\(clientID!)&seck=\(seck)"
    
     self.indicator.startAnimating()
     UIApplication.shared.beginIgnoringInteractionEvents()

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
        

        
        DispatchQueue.main.async(execute: {
            
            self.indicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            return
            
        })
        
        
        responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString)")
        
        
        
        
        do {
            self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
            
            
            
            print(self.json)
            
            
            self.parsingTheJsonData(JSondata: self.json!)

            
            DispatchQueue.main.async(execute: {
                
                self.tableview.reloadData()
                
                return
                
            })
            
        }   catch {
            print(error)
        }
        
   //35975151
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
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            let finalResult = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return finalResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            
            
            self.arr = (self.json?.value(forKey: "statements") as! NSArray) as! [String]
            
            self.arr.remove(at: 0)
            self.arr.remove(at: 0)
            self.arr.removeLast()

            self.arr = self.arr.filter({ $0 != ""})

            for item in self.arr{
             
            var obj = MiniStatement()
               
            var Str1 : String!
            
            
            let regex = try! NSRegularExpression(pattern: "([a-z])(\\))", options: NSRegularExpression.Options.caseInsensitive)
        
            let range = NSMakeRange(0, (item.characters.count))
            
            Str1 = regex.stringByReplacingMatches(in: item, options: [], range: range, withTemplate: "")
                
            var parts1   =     Str1.components(separatedBy: "INR")
                
            let mySubstring = parts1[0].prefix(11)
              
            obj.date = String(mySubstring)

            obj.stmt = parts1[0].replacingOccurrences(of: mySubstring, with: "", options: .literal, range: nil)
            
             
            if(parts1[1].contains("CR"))
            {
                
                let  parts2 = parts1[1].components(separatedBy: "CR")
                
                obj.amount = parts2[0]
                
                obj.CRDR = "(Cr)"

            }else if(parts1[1].contains("DR")){
                
                var  parts2 = parts1[1].components(separatedBy: "DR")
                
                obj.amount = parts2[0]
                obj.CRDR = "(Dr)"
                
                }
             self.arr1.append(obj)
           }
            
        }else if ((JSondata.value(forKey: "success") as! Int) == 0){
            
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

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     return arr.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! MiniStatementCellTableViewCell
        

 
        cell.date.text = self.arr1[indexPath.row].date
        cell.stmt.text = self.arr1[indexPath.row].stmt
        cell.amount.text = self.arr1[indexPath.row].amount
        cell.CRDR.text = self.arr1[indexPath.row].CRDR
        if(cell.CRDR.text == "(Cr)"){
            
            cell.CRDR.textColor = UIColor.green
        }
        else{
            
            cell.CRDR.textColor = UIColor.red

        }
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)

       return cell
        
    }
    
    
    
    
}


class MiniStatement
{
    
    var date : String!
    var stmt : String!
    var amount : String!
    var CRDR : String!
    
}



