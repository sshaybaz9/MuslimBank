//
//  LoginMobileViewController.swift
//  MBank
//
//  Created by Mac on 21/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import RNCryptor



class LoginMobileViewController: UIViewController,UITextFieldDelegate {
    
    

    var json: NSDictionary?

    var ACCID : String?
    
    

    var tArray = [Login]()
    
    var alert : UIAlertController = UIAlertController()
    var action : UIAlertAction = UIAlertAction()
    
    var MobileNoOTP : String?
    
    @IBOutlet weak var Mobtxt: UITextField!
    
    var OTPgeneratedtxt : UITextField!
    
    var OTPtxt : UITextField!
    
    
    @IBOutlet weak var loginPin: UITextField!
   
    var isIphone = 1
    
    var lineView1 = UIView(frame: CGRect(x: 0, y: 80, width: 500, height: 5))
    
    var key = "1234567890123456"
    
    let deviceID = UIDevice.current.identifierForVendor?.uuidString

    let kUserDefault = UserDefaults.standard
    
    var accountNo : String?
    
    var customerName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //To Hide Cursor
        
        loginPin.isSecureTextEntry = true
        
        self.loginPin.delegate = self
        self.Mobtxt.delegate = self
      
        
        
       // Vertically line in view
        lineView1.layer.borderWidth = 10
       lineView1.layer.borderColor = UIColor.orange.cgColor
       self.view.addSubview(lineView1)
        
   //     kUserDefault.value(forKey: "RegisteredMobile")
        
        
               
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Mobtxt.setBottomLine(borderColor: lineColor)
        
    }
    
    //then you should implement the func named textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowNumber = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowNumber.isSuperset(of: characterSet)
        
    }
    // login part
    
    @IBAction func Logged(_ sender: AnyObject) {
        
        let ciphertext = RNCryptor.encrypt(data: (loginPin.text!.data(using: String.Encoding.utf8)!), withPassword: key)
   
        print(deviceID)
        
        var responseString : String!
        
        var Encrypted = ciphertext.base64EncodedString()
        
        var   seckey = Mobtxt.text! + Encrypted
        
        
         let url = URL(string: "http://115.117.44.229:8443/Mbank_api/dashboardlogin.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let postString = "mobileno=\(Mobtxt.text!)&loginpin=\(Encrypted)&seckey=\(seckey)&deviceId=\(deviceID!)&isIphone=\(isIphone)"
        
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
            
            
            do {
                self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                
                print(self.json)
            
 // Login Customer Personal Detail
               self.accountNo = self.json?.value(forKey: "accno") as! String!
               self.kUserDefault.setValue(self.accountNo, forKey: "AccountNO")
               self.customerName = self.json?.value(forKey: "customerName") as! String!
               self.kUserDefault.setValue(self.customerName, forKey: "CustomerName")
               let  clientID = self.json?.value(forKey: "client_id") as! String!
             self.kUserDefault.setValue(clientID, forKey: "ClientID")
               let  clientAddress = self.json?.value(forKey: "client_address") as! String!
               let  clientCity = self.json?.value(forKey: "client_city") as! String!
              let  clientState = self.json?.value(forKey: "client_state") as! String!
              let Email = self.json?.value(forKey: "email") as! String!
//            var Rating = json?.value(forKey: "rating") as! NSString!
                
//                let imgurl = self.json?.value(forKey: "profile_image")as! String
//                
//                let imgData = try! Data.init(contentsOf: URL(string: imgurl)!)
//                    let tempimg = UIImage.init(data: imgData)
                
                print(self.json)
                
                
                // Accessing Transaction Details
                
 //Customer Transactional Account Detail In Which We will Store All The Information About Customer Credit And Debit Accounts
                
                        self.parsingTheJsonData(JSondata: self.json!)
            }   catch {
                print(error)
                    }
      
            
        }
        task.resume()
        
        
        
    }
   
    
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        var successMessage : String = String()
        var verificationStatus:Int = Int()
        
        let verficationAlert = UIAlertController()
        if((JSondata.value(forKey: "success") as! Int) == 1){//
            
            self.kUserDefault.setValue(self.Mobtxt.text, forKey: "MobileText")

            
            if((JSondata.value(forKey: "verification_needed") as! Int) == 1){
                
                let Verification = self.storyboard?.instantiateViewController(withIdentifier: "Verification") as! VerificationcodeViewController
                
                self.navigationController?.pushViewController(Verification, animated: true)
                
                OperationQueue.main.addOperation{
                self.present(Verification, animated: true, completion: nil)
                }
            }
            else {
                
                
                var jsonAccount = self.json?.value(forKey: "accounts") as? NSDictionary
                
                let jsonClientAccount = jsonAccount?.value(forKey: "clientAccounts") as!NSArray
                
                
                
                for item in jsonClientAccount
                {
                    

                    let i = item as? NSDictionary
                    let tObjLogin = Login()
                    
                    tObjLogin.accID = i?.value(forKey: "AccId") as! String
                    
                    tObjLogin.accNo = i?.value(forKey: "AccNo") as! String
                    tObjLogin.accType = i?.value(forKey: "AccountType") as! String
                    tObjLogin.Balance = i?.value(forKey: "Balance") as! String
                    tObjLogin.branchName = i?.value(forKey: "BranchName") as! String

                    tObjLogin.Description = i?.value(forKey: "Description") as! String
                    tObjLogin.maturityDate = i?.value(forKey: "MaturityDate") as! String
                    tObjLogin.Name = i?.value(forKey: "Name") as? String
                    tObjLogin.ifscCode = i?.value(forKey: "ifsccode") as! String
                    print("\(tObjLogin.ifscCode!)")

                    
                    
//               print("\(tObjLogin.accID!),\(tObjLogin.accNo),\(tObjLogin.accType),\(tObjLogin.Balance!),\(tObjLogin.branchName),\(tObjLogin.Deself.tArray, forKey: "Testing"scription),\(tObjLogin.ifscCode),\(tObjLogin.maturityDate),\(tObjLogin.Name)")
                    
                    self.tArray.append(tObjLogin)
                    
                    
                }
                

                print(self.tArray)
                
                
                

                
                successMessage = "Login successful"
                verificationStatus =  JSondata.value(forKey: "verification_needed") as! Int
                verficationAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
                verficationAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                    let Menu = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu1ViewController
                    //   Passing Mobile to Passing Mobile Number to AccessSetUpViewController
                   
                   Menu.temp1 = self.tArray
                    

                    
            self.navigationController?.pushViewController(Menu, animated: true)
                    
                    
                    self.present(Menu, animated: true, completion: nil)
                }))
            }
        }
        else if((JSondata.value(forKey: "success") as! Int) == 0){
            verificationStatus =  JSondata.value(forKey: "success") as! Int
            successMessage = "Login failed"
            verficationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        }
        verficationAlert.title = successMessage
        //       verficationAlert.message = JSondata.value(forKey: "message") as! String
        OperationQueue.main.addOperation {
            self.present(verficationAlert, animated:true, completion:nil)
        }
    }
    
    
   // Forgot Login Pin Part
    
    @IBAction func ForgotPInPressed(_ sender: AnyObject) {
        
      
        let alert = UIAlertController(title: "Get OTP on registered mobile for changing PIN", message: "", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: OTPgeneratedtxt)
        
        
        let okaction = UIAlertAction(title: "Get OTP", style: .default, handler: self.Handler)
        
        
        alert.addAction(okaction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func OTPgeneratedtxt(textField: UITextField!)
    {
        OTPgeneratedtxt = textField
        OTPgeneratedtxt?.placeholder = "Enter mobile number"
    }
    
    
    func Handler(alert: UIAlertAction)
    {
        
    
        
        var responseString : String!
        
   
    //    var  MobileNoOTP = OTPgeneratedtxt.text!
        

        MobileNoOTP = OTPgeneratedtxt.text!
        
        self.kUserDefault.setValue(self.MobileNoOTP, forKey: "MobileNumber")

        print(MobileNoOTP)
        
        
        var Sec = OTPgeneratedtxt.text!
        
              
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/getotpforpinchange.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let postString = "mobile_number=\(MobileNoOTP!)&seck=\(Sec)"
        
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
    
    func parsingTheJsonData1(JSondata1:NSDictionary)
    {
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            let alert = UIAlertController(title: "Enter one time password for pin change", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: OTPtxt)
            
            
            let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler1)
            
            
            alert.addAction(okaction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else if((JSondata1.value(forKey: "success") as! Int) == 0){
            
            let alert = UIAlertController()
            
            alert.message = JSondata1.value(forKey: "message") as! String

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            

            
        }

    }
    
    func OTPtxt(textField: UITextField!)
    {
        OTPtxt = textField
        OTPtxt?.placeholder = "Enter mobile number"
    }
   
    // Checking OTP Is Valid or Not
    
    func Handler1(alert: UIAlertAction)
    {
        
        
    var  OTP = OTPtxt.text!
        
        
    var sec =  OTPtxt.text! +  MobileNoOTP!
       
        var responseString : String!

       
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/verifyotp.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let postString = "otp_code=\(OTPtxt.text!)&mobile_number=\(MobileNoOTP!)&seck=\(sec)"
        
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
                
                
                self.parsingTheJsonData2(JSondata2: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        }
    
    
    func parsingTheJsonData2(JSondata2:NSDictionary)
    {
        
        if((JSondata2.value(forKey: "success") as! Int) == 1){
            
            let SetPin = self.storyboard?.instantiateViewController(withIdentifier: "LoginPinReset") as! LoginPinResetAndSaveViewController
            
            
            self.navigationController?.pushViewController(SetPin, animated: true)
            
            
            self.present(SetPin, animated: true, completion: nil)

        }
        else if((JSondata2.value(forKey: "success") as! Int) == 0){
            
            let alert = UIAlertController()
            
            alert.message = JSondata2.value(forKey: "message") as! String
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        
    }
}


class Login{
    
    var accID : String!
    var accNo : String!
    var accType : String!
    var Balance : String!
    var branchName : String!
    var Description : String!
    var maturityDate : String!
    var Name : String!
    var ifscCode : String!
    
}
