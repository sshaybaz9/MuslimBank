        //
        //  PayUsingAccountViewController.swift
        //  MBank
        //
        //  Created by Mac on 28/12/17.
        //  Copyright © 2017 Mac. All rights reserved.
        //

        import UIKit
        import RNCryptor

        class PayUsingAccountViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
            
            @IBOutlet weak var textView: UITextView!
            var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

        // Variable decalare for Beneficiary list Api call
        @IBOutlet weak var benAccountlbl: UILabel!

        @IBOutlet weak var debitAccountlbl: UILabel!
        var benArray1 = [BeneficiaryName1]()
        var BenID : String!
        var ClientID : String!
        var BenCategory : String!
        var BenName : String!
        var BenAccount : String!
        var ClientAccount : String!
        var BenIFSC : String!
        var BenTransfer : String!
        var BenLimit : String!
            var BenLimit1 : Int!

            var msg : String?
            
        @IBOutlet weak var scrollView: UIScrollView!

        @IBOutlet weak var purposetxt: UITextField!
        @IBOutlet weak var Amounttransfertxt: UITextField!
        @IBOutlet weak var benIfsctxt: UITextField!
        @IBOutlet weak var Debittxt1: UITextField!
        var userdefault = UserDefaults.standard

        @IBOutlet weak var benNametxt: UITextField!
        @IBOutlet weak var benAccounttxt: UITextField!
        var benArrayInfo = [BeneficiaryName]()

        var temp3 = [Login]()


        let deviceID = UIDevice.current.identifierForVendor?.uuidString

        var OTPgeneratedtxt : UITextField!

        var key = "1234567890123456"

        var isIphone = 1

        var tranMessage : String!


        @IBOutlet weak var tableview1: UITableView!
        @IBOutlet weak var SelectAccount: UIButton!
        @IBOutlet weak var tableview: UITableView!

            
            var amountTransfer : Int?

        @IBOutlet weak var SelectBenf: UIButton!


            var commomAlertMessaage : String?

            var activeTextField : UITextField!
            
            let button = UIButton(type: UIButtonType.custom)



        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.amountTransfer = 0

            SelectAccount.contentHorizontalAlignment = LanguageManger.shared.isRightToLeft ? .right : .left
            
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            

        self.Amounttransfertxt.delegate = self
        self.purposetxt.delegate = self
            
        //fetch all beneficiary list available for transaction
        ViewBeneficiaryList()

     //   textView.isUserInteractionEnabled  = false
        Debittxt1.isUserInteractionEnabled = false
        benAccounttxt.isUserInteractionEnabled = false
        benNametxt.isUserInteractionEnabled = false
        benIfsctxt.isUserInteractionEnabled = false

        }

            
          
        @IBAction func PressedSelectAccount(_ sender: AnyObject) {

            self.tableview.reloadData()

            self.tableview.isHidden = !self.tableview.isHidden

        }

        @IBAction func PressSelectBeneficary(_ sender: AnyObject) {

            self.tableview1.reloadData()

            self.tableview1.isHidden = !self.tableview1.isHidden

        }


        // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }

        @IBAction func BackPressed(_ sender: AnyObject) {
      //      let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
            self.dismiss(animated: true, completion: nil)
        }




        // Beneficiary List Api Call Again in This VC

        func ViewBeneficiaryList()
        {

        if Connectivity.isConnectedToInternet(){

        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")

        var responseString : String!

        let url = URL(string: Constant.POST.FETCHALLPAYEE.fetchpayee)!

        var request = URLRequest(url: url)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")


        let seck = clientID! + accountNumber!

        let postString = "client_id=\(clientID!)&acc_no=\(accountNumber!)&seck=\(seck)"

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
                
                
                self.msg = json?.value(forKey: "message") as? String
                
                let payelist = json?.object(forKey: "payee_list") as? NSArray
                
                self.benArray1 = [BeneficiaryName1]()
                if (payelist != nil)
                {
                
                for item in payelist!
                {
                    let benObj = BeneficiaryName1()
                    let obj = item as! NSDictionary
                    
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
                    
                    benObj.benLimit = obj.value(forKey: "BENE_TRF_LIMIT") as! String
                    self.BenLimit = String(benObj.benLimit!)
                    self.BenLimit1 = Int(self.BenLimit)
                    self.benArray1.append(benObj)
                    
                    }
                }
                
                
                self.parsingTheJsonData(JSondata: json!)
                
                OperationQueue.main.addOperation {
                    
                    self.tableview1.reloadData()

                }
            }
            catch
            {
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

        func parsingTheJsonData(JSondata:NSDictionary)
        {
            if((JSondata.value(forKey: "success") as! Int) == 0){
                
                let alert = UIAlertController(title: "", message: "\(self.msg!)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                OperationQueue.main.addOperation {
                    
                    self.present(alert, animated:true, completion:nil)
                    
                }
            }

        }

        //    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //        return 1
        //    }
        //    
        //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        
        //        if pickerView == pickerDebit{
        //            
        //            return temp3.count
        //        }
        //        else if pickerView == benpicker{
        //            
        //            return benArray1.count
        //        }
        //        return 1
        //    }
        //    
        //    
        //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        
        //        if pickerView == pickerDebit{
        //            
        //            
        //           let login = temp3[row] as! Login
        //            
        //            
        //           self.view.endEditing(true)
        //            
        //            
        //            return  login.accNo
        //        }
        //            
        //        else if pickerView == benpicker
        //        {
        //        
        //           var beninfo = benArray1[row] as! BeneficiaryName1
        //            
        //           self.view.endEditing(true)
        //            
        //            return beninfo.bNAme
        //            
        //        }
        //        
        //        return ""
        //        
        //    }

        func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var count : Int?
        if tableView == self.tableview{
            
            count =  temp3.count
        }
        if tableView == self.tableview1
        {
            count = benArray1.count
        }
        return count!



        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : UITableViewCell?


        if tableView == tableview{
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = temp3[indexPath.row].accNo
            cell?.contentView.backgroundColor = UIColor.lightGray
            return cell!
            
        }

        if tableView == tableview1
        {
            
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
            
            
            let temp = benArray1[indexPath.row]
            cell?.textLabel?.text = temp.bNAme
            cell?.contentView.backgroundColor = UIColor.lightGray

            return cell!
            
        }

        return cell!

        }







        //
        //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        //    {
        //        if pickerView == pickerDebit{
        //            let login = temp3[row] as! Login
        //
        //            self.txtSelectDebit.text = login.accNo
        //            self.Debittxt1.text = login.accNo
        //            self.Debittxt1.isHidden = false
        //            self.pickerDebit.isHidden = true
        //            self.debitAccountlbl.isHidden = false
        //        }
        //        else if pickerView == benpicker
        //        {
        //            let beninfo = benArray1[row] as! BeneficiaryName1
        //            self.Selectbentxt.text = beninfo.bNAme
        //            self.benAccounttxt.text = beninfo.benAccount
        //            self.benNametxt.text = beninfo.bNAme
        //            self.benIfsctxt.text = beninfo.benIFSC
        //            self.benpicker.isHidden = true
        //            self.benAccountlbl.isHidden = false
        //        }
        //    }
        //    







        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if tableView == tableview{


           self.SelectAccount.setTitle(temp3[indexPath.row].accNo, for: .normal)
            self.Debittxt1.text =  temp3[indexPath.row].accNo
            self.tableview.isHidden = true
            

        }



        else if tableView ==  tableview1
        {
            
                
                self.SelectBenf.setTitle(benArray1[indexPath.row].bNAme, for: .normal)
                
                self.benAccounttxt.text =  benArray1[indexPath.row].benAccount
                self.benNametxt.text = benArray1[indexPath.row].bNAme
                self.benIfsctxt.text = benArray1[indexPath.row].benIFSC
                self.tableview1.isHidden = true
            
            
            
            
        }


        }













        //    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField == self.txtSelectDebit
        //        {
        //            
        //            activeField = textField
        //
        //            self.debitAccountlbl.isHidden = true
        //            self.pickerDebit.isHidden = false
        //            txtSelectDebit.endEditing(true)
        //            Debittxt1.endEditing(true)
        //        }
        //        if textField == self.Selectbentxt
        //        {
        //            
        //            activeField = textField
        //
        //            
        //            self.benAccountlbl.isHidden = true
        //            self.benpicker.isHidden =  false
        //            Selectbentxt.endEditing(true)
        //        }
        //    }

       
            
            
            func commonAlertFunc()
            {
                
                
         let alert = UIAlertController(title: "", message: "\(self.commomAlertMessaage!)", preferredStyle: .alert)
                
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                OperationQueue.main.addOperation {
                    self.present(alert, animated: true, completion: nil)
                }
            }


            @IBAction func proceedTransaction(_ sender: AnyObject) {

            //call function for transaction
                //
              
                
                self.amountTransfer = Int(self.Amounttransfertxt.text!)
                print(self.amountTransfer)
                
                if(self.Debittxt1.text == nil || (self.Debittxt1.text?.isEmpty)!){
                        
                        self.commomAlertMessaage = "Please select debit account"
                        commonAlertFunc()
                    
                }else if(self.benAccounttxt.text == nil || (self.benAccounttxt.text?.isEmpty)!)
                {
                    
                    self.commomAlertMessaage = "Please select the Beneficary"
                    commonAlertFunc()
                    
                }
                else if(self.Amounttransfertxt.text == nil || (self.Amounttransfertxt.text?.isEmpty)!){
                    
                    self.commomAlertMessaage = "Please enter the amount"
                    
                    commonAlertFunc()
                } else if (self.purposetxt.text == nil || (self.purposetxt.text?.isEmpty)!){
            
                    self.commomAlertMessaage = "Please enter the purpose"
                    
                    commonAlertFunc()
                    
                }else if (self.BenLimit1 > 0 && self.amountTransfer! > self.BenLimit1){
                    //display msg amount greater than limit
                    
                   self.commomAlertMessaage = "Amount entered is greater  than limit"
                    
                    commonAlertFunc()
                    
                } else  {
                    sendOTPForTransaction()
                }

            }
            
            
            
            
            //function for sending OTP
            public func sendOTPForTransaction(){
                
                

                
                
                //Alert Label
                let strings = [["text" : "Debit Account:", "color" : UIColor.black], ["text" : "\(self.Debittxt1.text!)\n", "color" : UIColor.black], ["text" :"\nTransaction amount:" ,"color" : UIColor.black], ["text" :"\(self.Amounttransfertxt.text!)\n" ,"color" : UIColor.black], ["text" :"\nBeneficiary Account:" ,"color" : UIColor.black], ["text" :"\(self.benAccounttxt.text!)\n" ,"color" : UIColor.black], ["text" :"\nBeneficiary Name:" ,"color" : UIColor.black], ["text" :"\(self.benNametxt.text!)" ,"color" : UIColor.black]];
                
                
                let attributedString = NSMutableAttributedString()
                
                for configDict in strings {
                    if let color = configDict["color"] as? UIColor, let text = configDict["text"] as? String {
                        attributedString.append(NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : color]))
                    }
                }
                
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                
                
                alert.setValue(attributedString, forKey: "attributedMessage")
                
                let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler)
                
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                
                alert.addAction(okaction)
                OperationQueue.main.addOperation {
                    
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            
            
            
            
            func Handler(alert: UIAlertAction)
            {
                self.indicator.startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()

                if Connectivity.isConnectedToInternet()
                {
                    
                    let clientID = UserDefaults.standard.string(forKey: "ClientID")
                    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
                    
                    var responseString : String!
                    
                    
                    
                    
                    let url = URL(string: Constant.POST.TRANSACTIONOTP.getTransactionOtp)!
                    
                    
                    
                    var request = URLRequest(url: url)
                    
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    
                    request.httpMethod = "POST"
                    
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    
                    
                    
                    let seck = mobileNumber! + clientID!
                    
                    let postString = "remitter_mobile=\(mobileNumber!)&remitter_clientid=\(clientID!)&seck=\(seck)&isIphone=\(isIphone)"
                    
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
                        
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            
                            self.indicator.stopAnimating()
                            
                            return
                            
                        })
                        var json: NSDictionary?
                        do {
                            json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                            
                            OperationQueue.main.addOperation {
                                self.tableview1.reloadData()

                            }
                            
                            self.parsingTheJsonData1(JSondata1: json!)
                            
                        }   catch {
                            print(error)
                        }
                        
                        
                    }
                    task.resume()
                    
                }
                    
                    
                else{
                    
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        
                        self.indicator.stopAnimating()
                        
                        return
                        
                    })
                    let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
            }
            
            //alert for api call of verifying OTP entered by customer
            
            func Proceed()
            {
                
                let alert = UIAlertController(title: "Enter the OTP", message: "", preferredStyle: .alert)
                
                OperationQueue.main.addOperation {

                alert.addTextField(configurationHandler: self.OTPgeneratedtxt)
                
                
                let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler1)
                
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                
                alert.addAction(okaction)
                
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            

        func parsingTheJsonData1(JSondata1:NSDictionary)
        {
        if((JSondata1.value(forKey: "success") as! Int) == 1){
            
            
            Proceed()
           
            
        }





        }

        func OTPgeneratedtxt(textField: UITextField!)
        {
        OTPgeneratedtxt = textField
        OTPgeneratedtxt?.placeholder = "Enter OTP"
        }


        func Handler1(alert: UIAlertAction)
        {
            self.indicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()


        if Connectivity.isConnectedToInternet()
        {

        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")


        let ciphertext = RNCryptor.encrypt(data: (OTPgeneratedtxt.text!.data(using: String.Encoding.utf8)!), withPassword: key)

        let Encrypted = ciphertext.base64EncodedString()

        var   seckey =  Encrypted + mobileNumber!

        var responseString : String!




        let url = URL(string: Constant.POST.TRANSACTIONOTPVERIFICATION.transactionotpVerification)!


        var request = URLRequest(url: url)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")




        let seck = Encrypted + mobileNumber!

        let postString = "client_id=\(clientID!)&mobile=\(mobileNumber!)&otp=\(Encrypted)&seck=\(seck)&isIphone=\(isIphone)"

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
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
                
                
                self.indicator.stopAnimating()
                
                return
                
            })
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


        else
        {
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

            }

        }
            
            
        func parsingTheJsonData2(JSondata2:NSDictionary){


          if((JSondata2.value(forKey: "success") as! Int) == 1){
            
            if Connectivity.isConnectedToInternet()
            {
            
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let customerName = UserDefaults.standard.string(forKey: "CustomerName")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            
            
            var responseString : String!
            
            
        let  systemVersion = UIDevice.current.systemVersion
            let   deviceName = UIDevice.current.name
            let systemName = UIDevice.current.systemName

      
        let deviceInfo = "sytemVersion:" + systemVersion + "deviceName:" + deviceName + "systemName:" + systemName
            
            let url = URL(string: Constant.POST.PTOATRANSFER.TRANSFER)!
            

            
                    var request = URLRequest(url: url)
            
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
                    request.httpMethod = "POST"
            
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
                    var isIphone = 1
            
            
                    let seck = mobileNumber! + accountNumber! + benIfsctxt.text!
            
                let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_name=\(customerName!)&bene_account=\(benAccounttxt.text!)&bene_ifsc=\(benIfsctxt.text!)&amount=\(Amounttransfertxt.text!)&trans_purpose=\(purposetxt.text!)&remitter_clientid=\(clientID!)&device_id=\(deviceID!)&seck=\(seck)&device_info=\(deviceInfo)"
            
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
                            
                            
                            self.tranMessage = json?.value(forKey: "message") as! String!

                            
                            
                            self.parsingTheJsonData3(JSondata3: json!)
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
            if((JSondata2.value(forKey: "success") as! Int) == 0){
                
                
                
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    self.indicator.stopAnimating()
                    
                    return
                    
                })
                let alert = UIAlertController()
                
                alert.addAction(UIAlertAction(title: "Invalid OTP", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: self.Resend))
                
               self.present(alert, animated: true, completion: nil)
                
           }
            
            
        }
            func Resend(alert :UIAlertAction)
            {
                
                Proceed()
            }

        func parsingTheJsonData3(JSondata3:NSDictionary)
        {
        if((JSondata3.value(forKey: "success") as! Int) == 1){
            
            let alert = UIAlertController(title: "Transaction Successfull", message: "\(self.tranMessage!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }

        if((JSondata3.value(forKey: "success") as! Int) == 0){
            
            let alert = UIAlertController(title: "", message: "\(self.tranMessage!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }


        }


        }


        class BeneficiaryName1
        {
        var benID : Int!

        var clientID : String!

        var bNAme : String!

        var benAccount : String!

        var clientAccount : String!

        var benIFSC : String!

        var benTransfer : String!

        var benCat : String!
            
        var benLimit : String!

        }
