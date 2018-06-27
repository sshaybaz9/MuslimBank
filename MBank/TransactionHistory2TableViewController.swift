//
//  TransactionHistory2TableViewController.swift
//  MBank
//
//  Created by Mac on 08/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class TransactionHistory2TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var fundtransfer: RadioButton!
    
    @IBOutlet weak var all: RadioButton!
    
    var Flag : String!
    var tranReferenceNumber : String!
    
    var json1 : NSDictionary?

    var datetime1 : String!
    var trantype1 : String!
    var transtatus1 : String!
    var message1 : String!
    var benName1 : String!
    
    @IBOutlet weak var tableview: UITableView!
    var tranHistory = [TransactionHistory1]()

    
    lazy var radioButtons: [RadioButton] = {
        return [
            self.all,
            self.fundtransfer,
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Flag = "0"
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
         transactionHistory()

    }

    
    override  func viewDidAppear(_ animated: Bool) {
        
        self.tableview.reloadData()
        
    }
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
    //    let vc = self.storyboard?.instantiateViewController(withIdentifier: "services") as! ServicesMenuViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func allAction(_ sender: RadioButton) {
        
        updateRadioButton(sender)
        
        self.Flag = "0"
        transactionHistory()
        
    }
    @IBAction func fundAction(_ sender: RadioButton) {
        
        updateRadioButton(sender)

        self.Flag = "1"
            transactionHistory()
        
        
    }
    
    func updateRadioButton(_ sender: RadioButton){
        
        
        radioButtons.forEach{$0.isSelected = false}
        sender.isSelected = !sender.isSelected
    }
    
    func getSelectedRadioButton() -> RadioButton? {
        var radioButton: RadioButton?
        radioButtons.forEach { if($0.isSelected){ radioButton =  $0 } }
        return radioButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
   
    
    func transactionHistory()
    {
        self.indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
if Connectivity.isConnectedToInternet()
{
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.TRANSACTIONHISTORYLIST.transactionHistory)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let postString = "client_id=\(clientID!)&flagFilter=\(self.Flag!)"
        
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
            DispatchQueue.main.async(execute: {
                
                self.indicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                return
                
            })
            
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                let rootarr = json
                
                let response2 = rootarr?.value(forKey: "response") as! NSArray
               
                self.tranHistory.removeAll()
                
                for item in response2
                {
                    
                    let i = item as! NSDictionary
                    
                    let tranhisobj = TransactionHistory1()
                    

                    tranhisobj.transactionrefnumber = i.value(forKey: "RRN") as? String
                    
                    tranhisobj.status = i.value(forKey: "ActCodeDesc") as? String
                tranhisobj.transactiontype = i.value(forKey: "Transaction_type") as? String
                    tranhisobj.date = i.value(forKey: "LocalTxnDtTime") as? String
                    
                    self.tranHistory.append(tranhisobj)

                }

                        

                self.parsingTheJsonData(JSondata: json!)
                
                DispatchQueue.main.async(execute: {
                    
                    self.tableview.reloadData()
                    
                    return
                    
                })
            }
            catch {
                print(error)
            }
            
            
        }
        task.resume()
        }
        else
        {
            DispatchQueue.main.async(execute: {
                
                self.indicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                return
                
            })
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        if((JSondata.value(forKey: "success") as! Int) == 0){
            
            DispatchQueue.main.async(execute: {
                
                self.indicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                return
                
            })
            let alert = UIAlertController(title:"No Internet Connection" , message:"There are no Transaction for this Account" , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            

        }
        
        
 }
    


    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tranHistory.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! TransactionHistoryTableViewCell
        
        cell.Tranrefnum2.text = tranHistory[indexPath.row].transactionrefnumber
        cell.Trantype2.text = tranHistory[indexPath.row].transactiontype
        cell.status2.text = tranHistory[indexPath.row].status
        cell.date2.text = tranHistory[indexPath.row].date
        if(cell.Trantype2.text == "P to A Funds transfer"){
        cell.StatusButton.isHidden = false
         self.tranReferenceNumber = cell.Tranrefnum2.text
            print(self.tranReferenceNumber)
        }else{
            cell.StatusButton.isHidden = true
        }
        
        cell.StatusButton.tag = indexPath.row
        cell.StatusButton.addTarget(self, action: #selector(isEdit(sender:)), for: .touchUpInside)
        
        return cell
    }
    @objc func isEdit(sender: UIButton){
        if Connectivity.isConnectedToInternet(){
            
            
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            var responseString : String!
            
            let url = URL(string: Constant.POST.TRANSENQUIRY.TRANSENQ)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let seck = mobileNumber! + accountNumber!
            
            let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&trans_ref_no=\(self.tranReferenceNumber!)&remitter_clientid=\(clientID!)&seck=\(seck)"
            
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
                
                
                do {
                    self.json1 = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    
                    print(self.json1)
                    
                    
                    self.parsingTheJsonData1(JSondata1: self.json1!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()
            
        }
        else{
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        
        
        
}
    
    public func alertTransactionStatus(){
        
        
        //Alert Label
        let strings = [["text" : "Date & time:", "color" : UIColor.black], ["text" : "\n\(self.datetime1!)\n", "color" : UIColor.black], ["text" :"\nStatus:" ,"color" : UIColor.black], ["text" :"\(self.transtatus1!)\n" ,"color" : UIColor.black],["text" : "\nTransaction type:", "color" : UIColor.black], ["text" : "\(self.trantype1!)\n", "color" : UIColor.black], ["text" :"\nMessage:" ,"color" : UIColor.black], ["text" :"\(self.message1!)\n" ,"color" : UIColor.black], ["text" :"\nBeneficiary Name:" ,"color" : UIColor.black], ["text" :"\(self.benName1!)" ,"color" : UIColor.black]];
        
        
        let attributedString = NSMutableAttributedString()
        
        for configDict in strings {
            if let color = configDict["color"] as? UIColor, let text = configDict["text"] as? String {
                attributedString.append(NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : color]))
            }
        }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        
        OperationQueue.main.addOperation {
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            
            DispatchQueue.main.async(execute: {
                
                let enqry = self.json1?.value(forKey: "enquiry") as! NSDictionary
                
                let tranDate = enqry.value(forKey: "TrandateTime") as! String
                self.datetime1 = tranDate
                
                
                
                let tranType = enqry.value(forKey: "TranType") as! String
                self.trantype1 = tranType
                
                let tranStatus = enqry.value(forKey: "Status") as! String
                self.transtatus1 = tranStatus
                
                
                let mess = enqry.value(forKey: "ImpsMessage") as! String
                self.message1 = mess
                
                
                let benName = enqry.value(forKey: "BeneName") as! String
                self.benName1 = benName
                
                
                self.alertTransactionStatus()
               
            })
            
        }
    }
    
//
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class TransactionHistory1
{
    var transactionrefnumber : String!
    var status : String!
    var transactiontype : String!
    var date : String!
    
}
