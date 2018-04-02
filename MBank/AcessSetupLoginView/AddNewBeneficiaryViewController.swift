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
    
    @IBOutlet weak var tableview: UITableView!
    
    var BeneCatTable : String!
    
    
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.dismiss(animated: true, completion: nil)
    }
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.BeneficiaryNametxt.delegate = self
            self.IfsCodetxt.delegate = self
            self.BeneficiarAccountNo.delegate = self
            self.TransferLimittxt.delegate = self
            

            
            
            // View Frame will Move Up when Keyboard hide the frame
            
            let center : NotificationCenter = NotificationCenter.default;
            center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
            
            
            

            
            

            
            
            self.BenID = String(describing: BArray.benID)
        print(BenID!)
        
                        
            self.TransferLimittxt.text = BArray.benTransfer
            self.IfsCodetxt.text = BArray.benIFSC
            self.BeneficiarAccountNo.text = BArray.benAccount
            
            var tempBenCat = BArray.benCat
            
            
            
            if(tempBenCat != nil){
  //          self.selectBeneficiary.text = BArray.benCat
            
       self.selectBeneficiary.setTitle(tempBenCat, for: .normal)
            }
            else{
            
            
            self.selectBeneficiary.setTitle("Select", for: .normal)
                
            }
            
            self.BeneficiaryNametxt.text = BArray.bNAme
            
  //          self.SelectBank.tintColor = .clear
            
            lineView1.layer.borderWidth = 1.0
            lineView1.layer.borderColor = UIColor.white.cgColor
            self.View1.addSubview(lineView1)

            
            
            
            
            
            
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.button.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
                }, completion: nil)
        }
        
    }
    
    
    
    func keyboardDidShow(notification: Notification)
        
    {
        
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        
        let editingTextFieldY : CGFloat! = self.activeTextField?.frame.origin.y
        
        
        if self.view.frame.origin.y >= 0 {
            
            // Checking if the textfield is really hiddn behind the keyboard
            
            if(editingTextFieldY != nil)
            {
                
                if editingTextFieldY > keyboardY - 60
                {
                    
                    
                    
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                        self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
                        }, completion: nil)
                }
            }
            
        }
        
        
    }
    
    func keyboardWillHide(notification: Notification)
        
    {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    //then you should implement the func named textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        var temp = list[indexPath.row]
        
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    @IBAction func Register(_ sender: AnyObject) {
        
        
        
if Connectivity.isConnectedToInternet        {
        
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")

        var responseString : String!
        
        let url = URL(string: Constant.POST.VERIFYMOBILENO.verifymobileno)!
        
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
        
        else
        {
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
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
        
if Connectivity.isConnectedToInternet
        {
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        let url = URL(string: Constant.POST.VERIFYGENERICOTP.verifygenericotp)!
        
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
        else
        {
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
 // After checking OTP Api Success  Add Beneficiary  Api call
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            
            
if Connectivity.isConnectedToInternet            {
            
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
            
            var seck = self.BeneCatTable! + BeneficiaryNametxt.text!
            if(BenID == "nil"){
           
                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(self.BeneCatTable!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)"
                print(postString)
                

            }
            else{
                
                self.BenID = String(describing: BArray.benID!)

                postString = "seck=\(seck)&client_id=\(clientID!)&client_account=\(accountNumber!)&payee_category=\(self.BeneCatTable!)&payee_name=\(BeneficiaryNametxt.text!)&ifsc_code=\(IfsCodetxt.text!)&payee_account=\(BeneficiarAccountNo.text!)&trf_limit=\(TransferLimittxt.text!)&payee_id=\(BenID!)"
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
            
            
            else
            {
                
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                var action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }
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
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
