//
//  AddNewBeneficiaryViewController.swift
//  MBank
//
//  Created by Mac on 12/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData
class AddNewBeneficiaryViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
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
    var lineView1 = UIView(frame: CGRect(x: 160, y: 0, width: 1.0, height: 57))

    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var SelectBank: UITextField!
    var list = ["Muslim Bank","Other Bank"]
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.present(vc, animated: true, completion: nil)
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
            self.SelectBank.text = BArray.benCat
            self.BeneficiaryNametxt.text = BArray.bNAme
            
            self.SelectBank.tintColor = .clear
            
            lineView1.layer.borderWidth = 1.0
            lineView1.layer.borderColor = UIColor.white.cgColor
            self.View1.addSubview(lineView1)

            
            
            
    }

    //then you should implement the func named textFieldShouldReturn
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.SelectBank.text = self.list[row]
        self.picker.isHidden = true
    
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.SelectBank
        {
            self.picker.isHidden = false
        }
    }
    

    @IBAction func Register(_ sender: AnyObject) {
        
        
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")

        var responseString : String!
        
        
let url = URL(string: "http://115.117.44.229:8443/Mbank_api/verifywithmobile.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var seck = "MBANK2017"
        
        let postString = "seck=\(seck)&mobile_no=\(mobileNumber!)"
        
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
                
                
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            let alert = UIAlertController(title: "Enter the OTP", message: "", preferredStyle: .alert)
            
            
            alert.addTextField(configurationHandler: OTPgeneratedtxt)
            
            
            let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler)
            
            
            alert.addAction(okaction)
            OperationQueue.main.addOperation {
                
                
                self.present(alert, animated: true, completion: nil)
            }
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
        
        
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/verifygenericotp.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var seck = OTPgeneratedtxt.text! + mobileNumber!
        
        let postString = "otp_code=\(OTPgeneratedtxt.text!)&mobile_number=\(mobileNumber!)&seck=\(seck)"
        
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
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    
 // After checking OTP Api Success  Add Beneficiary  Api call
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            let clientID = UserDefaults.standard.string(forKey: "ClientID")

            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    
 //           self.kUserDefault.setValue(BeneficiaryNametxt.text, forKey: "Ben")
            
                       

            var responseString : String!
            var postString : String!
            
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/addbeneficiary.php")!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var seck = SelectBank.text! + BeneficiaryNametxt.text!
            if(BenID == "nil"){
           
                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(SelectBank.text!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)"
                print(postString)
                

            }
            else{
                
                self.BenID = String(describing: BArray.benID!)

                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(SelectBank.text!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)&payee_id=\(BenID!)"
                print(postString)

            }
            
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
                self.msg = json?.value(forKey: "message") as! String!
   
                    
                    self.parsingTheJsonData2(JSondata2: json!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()
            }
        
        else if((JSondata1.value(forKey: "success") as! Int) == 0){
            
            let alert = UIAlertController()
            
            alert.message = JSondata1.value(forKey: "message") as! String
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            OperationQueue.main.addOperation {
                
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }

        
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
        let Transaction = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
    
        
        self.navigationController?.pushViewController(Transaction, animated: true)
        
        OperationQueue.main.addOperation{
            self.present(Transaction, animated: true, completion: nil)
        }
    }
    
    
}
