//
//  BeneficiaryListViewController.swift
//  MBank
//
//  Created by Mac on 21/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class BeneficiaryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    var BenID : String!
    var ClientID : String!
    var BenCategory : String!
    var BenName : String!
    var BenAccount : String!
    var ClientAccount : String!
    var BenIFSC : String!
    var BenTransfer : String!
    
var userdefault = UserDefaults.standard
    
    var BenArray = [BeneficiaryName]()
    
    
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        ViewBeneficiaryList()
        
    }
    
    func ViewBeneficiaryList()
    {
        

        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        
        
        var responseString : String!
        
        
        
let url = URL(string: "http://115.117.44.229:8443/Mbank_api/fetchallpayees.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var seck = clientID! + accountNumber!
        
        let postString = "client_id=\(clientID!)&acc_no=\(accountNumber!)&seck=\(seck)"
        
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
           
            self.tableview.reloadData()

            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                print(json)
                
                let payelist = json?.object(forKey: "payee_list") as! NSArray
             
                self.BenArray = [BeneficiaryName]()

               for item in payelist
               {
                var benObj = BeneficiaryName()
                let obj = item as! NSDictionary
                
//                benObj.benID = obj.value(forKey: "BEN_ID") as! Int
//                
//                self.BenID = String(benObj.benID!)
//                
//                print(self.BenID)
//                
//                benObj.bNAme = obj.value(forKey: "BEN_NAME") as! String
//                
//                benObj.clientID = obj.value(forKey: "CLIENT_ID") as! String
//                
//                self.ClientID = String(benObj.clientID!)
                
                
                
                
                
                benObj.benID = obj.value(forKey: "BEN_ID") as! Int!
                self.BenID = String(benObj.benID)
                
                benObj.benAccount = obj.value(forKey: "BEN_ACCOUNT") as! String
                    self.BenAccount = String(benObj.benAccount!)
                
                benObj.clientAccount = obj.value(forKey: "CLIENT_ACCOUNT") as! String
                    self.ClientAccount = String(benObj.clientAccount!)
                
                
                
                benObj.bNAme = obj.value(forKey: "BEN_NAME") as! String
                      self.BenName = String(benObj.bNAme!)
                
                
                benObj.benCat = obj.value(forKey: "BEN_CATEGORY") as! String
                      self.BenCategory = String(benObj.benCat!)
                
                
                benObj.benIFSC = obj.value(forKey: "BEN_IFSC") as! String
                     self.BenIFSC = String(benObj.benIFSC!)
                
                
                benObj.benTransfer = obj.value(forKey: "BENE_TRF_LIMIT") as! String
                     self.BenTransfer = String(benObj.benTransfer!)
                
                
                benObj.clientID = obj.value(forKey: "CLIENT_ID") as! String
                self.ClientID = String(benObj.clientID!)
//                
//                print(self.ClientID)
//
//                print(benObj.bNAme)
//                
                self.BenArray.append(benObj)
                
                
                
                
                self.tableview.reloadData()
                
                
                }
                
                
                self.parsingTheJsonData(JSondata: json!)
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
    func parsingTheJsonData(JSondata:NSDictionary)
    {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int
    {
    return BenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BenNameTableViewCell
        cell.Edit.tag = indexPath.row
        cell.Delete.tag = indexPath.row
        let temp = BenArray[indexPath.row]
        cell.BenNamelbl.text = temp.bNAme
        
        cell.Delete.addTarget(self, action: #selector(isDelete(sender:)), for: .touchUpInside)
        cell.Edit.addTarget(self, action: #selector(isEdit(sender:)), for: .touchUpInside)
        return cell
    }
    
    func isDelete(sender : UIButton)
    {
     let alert = UIAlertController(title: "Do you want to delete", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Delete) in
            
            var responseString : String!
        
            let url = URL(string: "http://115.117.44.229:8443/Mbank_api/deletepayee.php")!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let seck = self.BenID! + self.ClientID!
            
            let postString = "ben_id=\(self.BenID!)&client_id=\(self.ClientID!)&seck=\(seck)"
            
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
                    self.parsingTheJsonData1(JSondata1: json!)
                }
                catch
                {
                    print(error)
                }
                
                
            }
            task.resume()
            
    }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
    //    if((JSondata.value(forKey: "success") as! Int) == 1){
        if((JSondata1.value(forKey: "success") as! Int) == 1)
        {
            ViewBeneficiaryList()
            self.tableview.reloadData()
        }
        
    }
    
    
    func isEdit(sender: UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? BenNameTableViewCell
        let indexPath = tableview.indexPath(for: cell!)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Beneficiary") as! AddNewBeneficiaryViewController
        vc.BArray = BenArray[(indexPath?.row)!]
        self.present(vc, animated: true, completion: nil)
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class BeneficiaryName
{
    var benID : Int!
    
    var clientID : String!
    
    var bNAme : String!
    
    var benAccount : String!
    
    var clientAccount : String!
    
    var benIFSC : String!
    
    var benTransfer : String!
    
    var benCat : String!
    

}
