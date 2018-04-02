        //
        //  ViewDepositViewController.swift
        //  MBank
        //
        //  Created by Mac on 22/02/18.
        //  Copyright © 2018 Mac. All rights reserved.
        //

        import UIKit

        class ViewDepositViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
            
            @IBOutlet weak var tableview: UITableView!
            
            @IBOutlet weak var tableview1: UITableView!
            
            var fixedrecurr :  String!
            

            @IBOutlet weak var SelectDeposit: UIButton!
            
            var viewList : [String] = ["Fixed","Recurring"]
            
            var FixDeposit = [ViewDeposit]()
            
            override func viewDidLoad() {
                super.viewDidLoad()

                // Do any additional setup after loading the view.
                
                //url
            
                
            }
            @IBAction func SelectDepositPressed(_ sender: AnyObject) {
                
                self.tableview.reloadData()
                
                self.tableview.isHidden = !self.tableview.isHidden
                self.tableview1.isHidden = true
                
            }
            
            
            @IBAction func Back(_ sender: AnyObject) {
                
                
                self.dismiss(animated: true, completion: nil)
            }
            
            
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               
             var count : Int?
                if tableView == self.tableview{
                    
                    count =  viewList.count
                }
                if tableView == self.tableview1
                {
                    count = FixDeposit.count
                }
                return count!
                

                
            }
            
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                var cell : UITableViewCell?
                
                
                if tableView == tableview{
                    
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    cell.textLabel?.text = viewList[indexPath.row]
                    return cell
                    
                }
                
                if tableView == tableview1
                {
                    
                    
                    let  cell = tableview1.dequeueReusableCell(withIdentifier: "cell") as! ViewDepositTableViewCell
                    
                    let temp = FixDeposit[indexPath.row]
                    
                                  cell.accno1.text = temp.accno
                                  cell.balance1.text = temp.bal
                               cell.maturitydate1.text = temp.maturdate
                    
                                   return cell
                }
                
                return cell!
                
            }

            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
                
                let cell = tableview.cellForRow(at: indexPath)

                
                let temp = viewList[indexPath.row]

                if(temp == "Fixed"){
                    
                    SelectDeposit.setTitle(cell?.textLabel?.text, for: .normal)
                
                    ShowDepositList(depositType: "fd")
                    
                    
                    self.tableview.isHidden = true
                    
                    self.tableview1.isHidden = false
                    
                    } else {
            
                    SelectDeposit.setTitle(cell?.textLabel?.text, for: .normal)

                    
                    ShowDepositList(depositType: "rd")
                    
                    
                    self.tableview.isHidden = true
                    self.tableview1.isHidden = false
                    
                }
            }
            
            
            
            func ShowDepositList(depositType:String)
            {
                
                
if Connectivity.isConnectedToInternet
                {
                self.fixedrecurr = depositType
                
                
                let clientID = UserDefaults.standard.string(forKey: "ClientID")
                
                
                var responseString : String!
                
                let url = URL(string: Constant.POST.DEPOSITLIST.depositlist)!
                
                var request = URLRequest(url: url)
                
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                let postString = "listFor=\(self.fixedrecurr!)&client_id=\(clientID!)"
                
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
                        
                        
                        let resp = json?.value(forKey: "response") as? NSArray
                        
                        
                        if(resp != nil)
                        
                        {
                        
                        for item in resp!
                        {
                            
                      let i = item as! NSDictionary
                            
                       let obj = ViewDeposit()
                            
                         obj.accno = i.value(forKey: "AccNo") as! String
                            
                            
                         obj.bal = i.value(forKey: "Balance") as! String
                            
                            print(obj.bal)
                        obj.maturdate = i.value(forKey: "MaturityDate") as! String
                            
                            
                         self.FixDeposit.append(obj)
                         
                            
                            
                            
                            
                            
                        }
                        
                        
                        }
                        
                        self.parsingTheJsonData(JSondata: json!)
                        
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.tableview1.reloadData()
                            
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
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
           
                
            
                
           
            func parsingTheJsonData(JSondata:NSDictionary){
                
            }
            
            }


        class ViewDeposit{
            
            var accno : String!
            var bal : String!
            var maturdate : String!
            
            
            
        }



