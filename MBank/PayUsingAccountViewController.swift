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



    @IBOutlet weak var SelectBenf: UIButton!







        var activeTextField : UITextField!
        
        let button = UIButton(type: UIButtonType.custom)



    override func viewDidLoad() {
    super.viewDidLoad()
        
        
        // View Frame will Move Up when Keyboard hide the frame
        
        let center : NotificationCenter = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        

        
        
        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        

      self.Amounttransfertxt.delegate = self
    self.purposetxt.delegate = self
    ViewBeneficiaryList()





    Debittxt1.isUserInteractionEnabled = false
    benAccounttxt.isUserInteractionEnabled = false
    benNametxt.isUserInteractionEnabled = false
    benIfsctxt.isUserInteractionEnabled = false

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
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
    self.dismiss(animated: true, completion: nil)
    }




    // Beneficiary List Api Call Again in This VC

    func ViewBeneficiaryList()
    {

    if Connectivity.isConnectedToInternet{



    let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    let clientID = UserDefaults.standard.string(forKey: "ClientID")


    var responseString : String!


    let url = URL(string: Constant.POST.FETCHALLPAYEE.fetchpayee)!


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
        
        
        
        var json: NSDictionary?
        do {
            json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
            
            print(json)
            
            let payelist = json?.object(forKey: "payee_list") as! NSArray
            
            self.benArray1 = [BeneficiaryName1]()
            
            for item in payelist
            {
                var benObj = BeneficiaryName1()
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
                
                self.benArray1.append(benObj)
                
                
            }
            
            
            self.parsingTheJsonData(JSondata: json!)
            self.tableview1.reloadData()
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
        
        var action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

    }
    }

    func parsingTheJsonData(JSondata:NSDictionary)
    {

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
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = temp3[indexPath.row].accNo
        return cell
        
    }

    if tableView == tableview1
    {
        
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
        
        
        var temp = benArray1[indexPath.row]
        cell?.textLabel?.text = temp.bNAme
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



    @IBAction func proceedTransaction(_ sender: AnyObject) {




    let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    let clientID = UserDefaults.standard.string(forKey: "ClientID")
    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")



    //Alert Label
    var strings = [["text" : "Debit Account:", "color" : UIColor.black], ["text" : "\(self.Debittxt1.text!)\n", "color" : UIColor.black], ["text" :"Transaction amount:" ,"color" : UIColor.black], ["text" :"\(self.Amounttransfertxt.text!)\n" ,"color" : UIColor.black], ["text" :"Beneficiary Account:" ,"color" : UIColor.black], ["text" :"\(self.benAccounttxt.text!)\n" ,"color" : UIColor.black], ["text" :"Beneficiary Name:" ,"color" : UIColor.black], ["text" :"\(self.benNametxt.text!)" ,"color" : UIColor.black]];


    var attributedString = NSMutableAttributedString()

    for configDict in strings {
        if let color = configDict["color"] as? UIColor, let text = configDict["text"] as? String {
            attributedString.append(NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : color]))
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


    if Connectivity.isConnectedToInternet
    {

    let clientID = UserDefaults.standard.string(forKey: "ClientID")
    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")

            var responseString : String!




    let url = URL(string: Constant.POST.TRANSACTIONOTP.getTransactionOtp)!



            var request = URLRequest(url: url)

            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")




            var seck = mobileNumber! + clientID!

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
             self.indicator.stopAnimating()

                var json: NSDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    
                    
                    self.tableview1.reloadData()

                    self.parsingTheJsonData1(JSondata1: json!)
                    
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()

    }


    else{
        
        self.indicator.stopAnimating()
        
        let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
        
        var action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

        
    }


    }
        
        
 

    func parsingTheJsonData1(JSondata1:NSDictionary)
    {
    if((JSondata1.value(forKey: "success") as! Int) == 1){
        
        
        
        let alert = UIAlertController(title: "Enter the OTP", message: "", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: OTPgeneratedtxt)
        
        
        let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.Handler1)
        
        
       alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        
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


    func Handler1(alert: UIAlertAction)
    {
self.indicator.startAnimating()


    if Connectivity.isConnectedToInternet
    {

    let clientID = UserDefaults.standard.string(forKey: "ClientID")
    let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")


    let ciphertext = RNCryptor.encrypt(data: (OTPgeneratedtxt.text!.data(using: String.Encoding.utf8)!), withPassword: key)

    var Encrypted = ciphertext.base64EncodedString()

    var   seckey =  Encrypted + mobileNumber!

    var responseString : String!




    let url = URL(string: Constant.POST.TRANSACTIONOTPVERIFICATION.transactionotpVerification)!


    var request = URLRequest(url: url)

    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")




    var seck = Encrypted + mobileNumber!

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
        self.indicator.stopAnimating()
        
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
        
        var action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)

    }



    }
    func parsingTheJsonData2(JSondata2:NSDictionary)
    {



    if((JSondata2.value(forKey: "success") as! Int) == 1){
        
        
        
        if Connectivity.isConnectedToInternet
        {
        
        let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
        let customerName = UserDefaults.standard.string(forKey: "CustomerName")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        
        
                var responseString : String!
        
        
    let  systemVersion = UIDevice.current.systemVersion
        let   deviceName = UIDevice.current.name
        let systemName = UIDevice.current.systemName

  
    var deviceInfo = "sytemVersion:" + systemVersion + "deviceName:" + deviceName + "systemName:" + systemName
        
        let url = URL(string: Constant.POST.PTOATRANSFER.TRANSFER)!
        

        
                var request = URLRequest(url: url)
        
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
                request.httpMethod = "POST"
        
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
                var isIphone = 1
        
        
                var seck = mobileNumber! + accountNumber! + benIfsctxt.text!
        
            let postString = "remitter_mobile=\(mobileNumber!)&remitter_account=\(accountNumber!)&remitter_name=\(customerName!)&bene_account=\(benAccounttxt.text!)&bene_ifsc=\(benIfsctxt.text!)&amount=\(Amounttransfertxt.text!)&trans_purpose=\(purposetxt.text!)&remitter_clientid=\(clientID!)&device_id=\(deviceID!)&seck=\(seck)&device_info=\(deviceInfo)"
        
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
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        
        


}
        if((JSondata2.value(forKey: "success") as! Int) == 0){
            
            
            
            self.indicator.stopAnimating()
            let alert = UIAlertController()
            
            alert.addAction(UIAlertAction(title: "Invalid OTP", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
           self.present(alert, animated: true, completion: nil)
            
       }
        
        
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


    }
