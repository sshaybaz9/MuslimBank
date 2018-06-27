//
//  AddNewBeneficiaryViewController.swift
//  MBank
//
//  Created by Mac on 12/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData
class AddNewBeneficiaryViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    var commonAlertMessage : String?
    @IBOutlet weak var tableview: UITableView!
    
    var BeneCatTable : String?
    
    
    var activeTextField : UITextField!
    
    let button = UIButton(type: UIButtonType.custom)
    

    
    var BArray = BeneficiaryName()

    var BenID : String!
    
    
    let context = AppDelegate().persistentContainer.viewContext

    let kUserDefault = UserDefaults.standard
    
    var msg : String!
    
    var OTPgeneratedtxt : UITextField!

    @IBOutlet weak var TransferLimittxt: UITextField!
    @IBOutlet weak var View1: UIView!
    
    @IBOutlet weak var BeneficiaryNametxt: UITextField!
    @IBOutlet weak var IfsCodetxt: UITextField!
    
    @IBOutlet weak var BeneficiarAccountNo: UITextField!
    var lineView1 = UIView(frame: CGRect(x: 180, y: 0, width: 1.0, height: 57))

    @IBOutlet weak var selectBeneficiary: UIButton!
    
    var list = ["Muslim Bank","Other Bank"]
    
    @IBAction func SelectBeneficary(_ sender: AnyObject) {
        
        
        
        
        self.tableview.reloadData()
        
        self.tableview.isHidden = !self.tableview.isHidden
        

    }
    @IBAction func BackPressed(_ sender: AnyObject) {
        
    //    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.dismiss(animated: true, completion: nil)
    }
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.BeneficiaryNametxt.delegate = self
            self.IfsCodetxt.delegate = self
            self.BeneficiarAccountNo.delegate = self
            self.TransferLimittxt.delegate = self
            

            
            

            
            

            
            
            self.BenID = String(describing: BArray.benID)
        print(BenID!)
        
                        
            self.TransferLimittxt.text = BArray.benTransfer
            self.IfsCodetxt.text = BArray.benIFSC
            self.BeneficiarAccountNo.text = BArray.benAccount
            
            let tempBenCat = BArray.benCat
            
            
            
            if(tempBenCat != nil){
  //          self.selectBeneficiary.text = BArray.benCat
            
       self.selectBeneficiary.setTitle(tempBenCat!, for: .normal)
                
                self.BeneCatTable = tempBenCat
            }
            else{
            
            
            self.selectBeneficiary.setTitle("Select", for: .normal)
                
            }
            
            if (self.BeneficiaryNametxt.text?.isEmpty)!{
            
            self.BeneficiaryNametxt.text = BArray.bNAme
            }
            else{
                self.BeneficiaryNametxt.text! = BArray.bNAme

            }
            
  //          self.SelectBank.tintColor = .clear
            
            lineView1.layer.borderWidth = 1.0
            lineView1.layer.borderColor = UIColor.white.cgColor
            self.View1.addSubview(lineView1)

            
            
            
            
            
            
    }

    
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        var temp = list[indexPath.row]
        
        cell.textLabel?.text = list[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let temp = list[indexPath.row]
        
        
        if (temp == "Muslim Bank")
        {
        
        
        selectBeneficiary.setTitle(cell?.textLabel?.text, for: .normal)

        self.BeneCatTable = "Muslim Bank"
        
            
            self.tableview.isHidden = true
        }
        
        else if (temp == "Other Bank"){
            
            selectBeneficiary.setTitle(cell?.textLabel?.text, for: .normal)

            
            self.BeneCatTable = "Other Bank"
            self.tableview.isHidden = true
            
        }

    }
    
    
    //then you should implement the func named textFieldShouldReturn
    
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func commonAlertFunc()
    {
        
        
        let alert = UIAlertController(title: "", message: "\(self.commonAlertMessage!)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    @IBAction func Register(_ sender: AnyObject) {
        
    if (self.BeneficiaryNametxt.text == nil || (self.BeneficiaryNametxt.text?.isEmpty)!)
        {
            
            self.commonAlertMessage = "Please enter the Beneficiary Name"
            
            commonAlertFunc()
        }
 
        
        else if (self.IfsCodetxt.text == nil || (self.IfsCodetxt.text?.isEmpty)!)
    {
        self.commonAlertMessage = "Please enter the IFSC code"
        commonAlertFunc()
    }
        else if (self.BeneficiarAccountNo.text == nil || (self.BeneficiarAccountNo.text?.isEmpty)!)
    {
      self.commonAlertMessage = "Please enter the Beneficiary account number"
        
    }
        
    else if (self.TransferLimittxt.text == nil || (self.TransferLimittxt.text?.isEmpty)!)
    {
    
        self.commonAlertMessage = "Please enter the amount limit"
        commonAlertFunc()
    }
        
    else{
        
        senOTP()
        
        }
        
        
        
        
        
    }
    
    func senOTP()
    {
        
        if Connectivity.isConnectedToInternet()        {
            
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            var responseString : String!
            
            let url = URL(string: Constant.POST.VERIFYMOBILENO.verifymobileno)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let seck = "MBANK2017"
            
            let postString = "seck=\(seck)&mobile_no=\(mobileNumber!)"
            
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
                    
                    
                    
                    self.parsingTheJsonData(JSondata: json!)
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
    
    func Proceed()
    {
        
        
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: "Enter the OTP", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: self.OTPgeneratedtxt)
     
        
        
        
        let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler)
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        
        alert.addAction(okaction)
        
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }

    
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
           Proceed()
        }
        
        
    }
    
    
    func OTPgeneratedtxt(textField: UITextField!)
    {
        OTPgeneratedtxt = textField
        OTPgeneratedtxt?.placeholder = "Enter OTP"
    }
    
    
    
// Verify OTP Api Call For Add New Beneficiary
    
    func Handler(alert: UIAlertAction)
    {
        
if Connectivity.isConnectedToInternet()
        {
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.VERIFYGENERICOTP.verifygenericotp)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            let seck = OTPgeneratedtxt.text! + mobileNumber!
        
        let postString = "otp_code=\(OTPgeneratedtxt.text!)&mobile_number=\(mobileNumber!)&seck=\(seck)"
        
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
    
 // After checking OTP Api Success  Add Beneficiary  Api call
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            
            
if Connectivity.isConnectedToInternet()
{
            
            let clientID = UserDefaults.standard.string(forKey: "ClientID")

            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    
 //           self.kUserDefault.setValue(BeneficiaryNametxt.text, forKey: "Ben")
            
                       

            var responseString : String!
            var postString : String!
            
            
            
            let url = URL(string: Constant.POST.ADDPAYEE.addPayee)!
            
       
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
   
    
                let seck = self.BeneCatTable! + BeneficiaryNametxt.text!
            if(BenID == "nil"){
           
                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(self.BeneCatTable!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)"
                

            }
            else{
                
                self.BenID = String(describing: BArray.benID!)

                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(self.BeneCatTable!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)&payee_id=\(BenID!)"

            }
            
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
                    
                    self.msg = json?.value(forKey: "message") as! String!
   
                    
                    self.parsingTheJsonData2(JSondata2: json!)
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
        
        else if((JSondata1.value(forKey: "success") as! Int) == 0){
            
            let alert = UIAlertController()
            
            alert.message = JSondata1.value(forKey: "message") as? String
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: self.Resend))
            
            OperationQueue.main.addOperation {
                
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }

        
    }
    
    func Resend(alert :UIAlertAction)
    {
        
        Proceed()
    }
    
    func parsingTheJsonData2(JSondata2:NSDictionary){
        
        
        
        if((JSondata2.value(forKey: "success") as! Int) == 1){
            
           
            
            
            
            let alert = UIAlertController(title: "", message: "\(self.msg!)", preferredStyle: .alert)
            
 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: self.Handler1))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        
        }

        
        
    }

    
    func Handler1(alert: UIAlertAction)
    {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
