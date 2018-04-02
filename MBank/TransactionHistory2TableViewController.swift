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
    
    

    
    
    @IBOutlet weak var tableview: UITableView!
    var tranHistory = [TransactionHistory1]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "services") as! ServicesMenuViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func transactionHistory()
    {
        self.indicator.startAnimating()
        
        
if Connectivity.isConnectedToInternet
{
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.TRANSACTIONHISTORYLIST.transactionHistory)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let postString = "client_id=\(clientID!)"
        
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
            self.indicator.stopAnimating()
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as! NSDictionary
                
                let rootarr = json
                
                var response2 = rootarr?.value(forKey: "response") as! NSArray
               
                
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

                

                print(json)
                

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
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
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
        return cell
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
