                            //
                            //  LoginMobileViewController.swift
                            //  MBank
                            //
                            //  Created by Mac on 21/11/17.
                            //  Copyright © 2017 Mac. All rights reserved.
                            //
                            
                            import UIKit
                            import RNCryptor
                            import ImageSlideshow
                            import Kingfisher
                            import IQKeyboardManagerSwift
                            import Alamofire
                            
                            class LoginMobileViewController: UIViewController,UITextFieldDelegate {
                                
                                
                                // Image Slider View Declartion
                                @IBOutlet weak var imageSlideShow: ImageSlideshow!
                                
                                @IBOutlet weak var scrollView: UIScrollView!
                                let kingfisherSource = [KingfisherSource(urlString: Constant.Domain+"appimages/"+"a.jpg")!,KingfisherSource(urlString: Constant.Domain+"appimages/"+"b.jpg")!,KingfisherSource(urlString: Constant.Domain+"appimages/"+"c.jpg")!,KingfisherSource(urlString: Constant.Domain+"appimages/"+"d.jpg")!,]
                                
                                
                                
                                // Adding Return Button on Keyboard
                                
                                
                                let button = UIButton(type: UIButtonType.custom)
                                
                                
                                var msg : String?
                                
                                
                                var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                                
                                
                                
                                
                                var imageArray = [UIImage(named: "accounts_mbank.png"),UIImage(named: "transfer.png"),UIImage(named: "tax_payment.png"),UIImage(named: "bill_paym.png"),UIImage(named: "upi.png"),UIImage(named: "locate_atm.png"),UIImage(named: "shoppingcart.png"),UIImage(named: "services.png"),UIImage(named: "cards.png")]
                                
                                @IBOutlet weak var welcomelbl: UILabel!
                                
                                var temping : UIImage!
                                
                                var url1  = Constant.Domain
                                
                                
                                var json: NSDictionary?
                                
                                var ACCID : String?
                                
                                
                                
                                var tArray = [Login]()
                                
                                var alert : UIAlertController = UIAlertController()
                                var action : UIAlertAction = UIAlertAction()
                                
                                var MobileNoOTP : String?
                                
                                @IBOutlet weak var Mobtxt: UITextField!
                                
                                var OTPgeneratedtxt : UITextField!
                                
                                var OTPtxt : UITextField!
                                
                                @IBOutlet weak var pageviewImage: UIImageView!
                                
                                @IBOutlet weak var loginPin: UITextField!
                                
                                var isIphone = 1
                                
                                var lineView1 = UIView(frame: CGRect(x: 0, y: 80, width: 500, height: 5))
                                
                                var key = "1234567890123456"
                                
                                let deviceID = UIDevice.current.identifierForVendor?.uuidString
                                
                                let kUserDefault = UserDefaults.standard
                                
                                var accountNo : String?
                                
                                var customerName : String?
                                
                                var defaultLang : String!
                                
                                
                                var activeTextField : UITextField!
                                
                                var Conn : Bool?
                                
                                override func viewDidLoad() {
                                    super.viewDidLoad()
                                    
                                    
    
                                    
                                    
                                    self.defaultLang = UserDefaults.standard.string(forKey: "lang")
                                    
                                    if(self.defaultLang == nil || self.defaultLang.isEmpty){
                                        UserDefaults.standard.set("en", forKey: "lang")
                                    }

                                    //set english language by default
                                    
                                    
                                    //  call to Image Slider View
                                    imageSlideShow.backgroundColor = UIColor.white
                                    imageSlideShow.slideshowInterval = 5.0
                                    imageSlideShow.pageControlPosition = PageControlPosition.underScrollView
                                    imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                                    imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
                                    imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
                                    
                                    // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
                                    
                                    imageSlideShow.currentPageChanged = { page in
                                        print("current page:", page)
                                    }
                                    
                                    // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
                                    imageSlideShow.setImageInputs(kingfisherSource)
                                    
                                    let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
                                    imageSlideShow.addGestureRecognizer(recognizer)
                                    
                                    
                                    
                                    
                                    //To Hide Cursor
                                    
                                    loginPin.isSecureTextEntry = true
                                    
                                    self.loginPin.delegate = self
                                    self.Mobtxt.delegate = self
                                    
                                    
                                    
                                    
                                    loginPin.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                                    
                                    
                                  
                                    
                                    // Vertically line in view
                                    //        lineView1.layer.borderWidth = 10
                                    //       lineView1.layer.borderColor = UIColor.orange.cgColor
                                    //       self.view.addSubview(lineView1)
                                    
                                    //     kUserDefault.value(forKey: "RegisteredMobile")
                                    
                                    
                                       indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                                    indicator.center = view.center
                                    view.addSubview(indicator)
                                    indicator.bringSubview(toFront: view)
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                                }
                                
                @objc private func textFieldDidChange(textField: UITextField)
                                {
                                    let text = textField.text
                                    
                                    if text?.utf16.count==4{
                                        
                                        
                                        Logged(self)
                                        
                                    }
                                    
                                    
                                }
                                
                                
                                
                            
                                
                                // Function of Slider Image
                                
                                @objc func didTap() {
                                    let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
                                    // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
                                    //                        fullScreenController.imageSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
                                }
                                
                                
                                
                                                         
                                
                                // login part
                                
                                @IBAction func Logged(_ sender: AnyObject) {
                                    
                                    
                                    
                                    self.indicator.startAnimating()
                                    
                                    UIApplication.shared.beginIgnoringInteractionEvents()
                                    
                                    if Connectivity.isConnectedToInternet(){
                                        
                                        self.Conn = Connectivity.isConnectedToInternet()
                                        
                                        
                                        if((Mobtxt.text?.isEmpty)!)
                                        {
                                            
                                            
                                            
                                            self.indicator.stopAnimating()
                                            
                                            let alert = UIAlertController(title: "Required field is Empty", message: "Please enter the Mobile Number", preferredStyle: .alert)
                                            
                                            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment:""), style: .default, handler: nil))
                                            
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        
                                        
                                        
                                        
                                        if((loginPin.text?.isEmpty)!)
                                        {
                                            
                                            DispatchQueue.main.async(execute: {
                                                UIApplication.shared.endIgnoringInteractionEvents()
                                                
                                                self.indicator.stopAnimating()
                                                
                                                return
                                                
                                            })
                                            
                                            let alert = UIAlertController(title: "Required field is Empty", message: "Please enter the Password", preferredStyle: .alert)
                                            
                                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                                            
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        
                                        
                                        let ciphertext = RNCryptor.encrypt(data: (loginPin.text!.data(using: String.Encoding.utf8)!), withPassword: key)
                                        
                                        
                                        var responseString : String!
                                        
                                        let Encrypted = ciphertext.base64EncodedString()
                                        
                                        let   seckey = Mobtxt.text! + Encrypted
                                        
                                        let url = URL(string: Constant.POST.DASHBOARDLOGIN.LOGIN)!
                                        
                                        var request = URLRequest(url: url)
                                        
                                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                        
                                        request.httpMethod = "POST"
                                        
                                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                        
                                        
                                        let postString = "mobileno=\(Mobtxt.text!)&loginpin=\(Encrypted)&seckey=\(seckey)&deviceId=\(deviceID!)&isIphone=\(isIphone)"
                                        
                                        print(postString)
                                        
                                        request.httpBody = postString.data(using: .utf8)
                                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                                                print("error=\(String(describing: error))")
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
                                                
                                                
                                                self.msg = self.json?.value(forKey: "message") as? String
                                                
                                                var  clientAddress = self.json?.value(forKey: "client_address") as? String
                                                
                                                let  clientCity = self.json?.value(forKey: "client_city") as? String
                                                
                                                let  clientState = self.json?.value(forKey: "client_state") as? String
                                                
                                                let Email = self.json?.value(forKey: "email") as? String
                                                
                                                
                                                let Rating = self.json?.value(forKey: "rating") as? NSString
                                                
                                                if(Rating != nil)
                                                {
                                                    
                                                    self.kUserDefault.setValue(Rating, forKey: "Rating")
                                                    
                                                }
                                                
                                                let imgurl = self.json?.value(forKey: "profile_image")as? String
                                                self.kUserDefault.setValue(imgurl, forKey: "FileName")
                                                
                                                if (imgurl != nil)
                                                {
                                                    var img2 = self.url1 + "uploads/"
                                                    img2  +=   (self.customerName?.removingWhitespaces())! + "/profile_images/" + imgurl! + ".jpg"
                                                    
                                                    let imgData = try! Data.init(contentsOf: URL(string: img2)!)
                                                    
                                                    self.temping = UIImage.init(data: imgData)!
                                                    
                                                }
                                                
                                                
                                                // Accessing Transaction Details
                                                
                                                //Customer Transactional Account Detail In Which We will Store All The Information About Customer Credit And Debit Accounts
                                                
                                                self.parsingTheJsonData(JSondata: self.json!)
                                                
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
            
            UIApplication.shared.endIgnoringInteractionEvents()

        self.present(Verification, animated: true, completion: nil)
            
        }
            }
        else {
                                            
        
        let jsonAccount = self.json?.value(forKey: "accounts") as? NSDictionary
        
                if(jsonAccount != nil){
                    
        let jsonClientAccount = jsonAccount?.value(forKey: "clientAccounts") as! NSArray
                    
    for item in jsonClientAccount{
    
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
        
                    self.tArray.append(tObjLogin)
                                                    
                                                }
                                                
                                                
                                            }
                                            
        
        UIApplication.shared.endIgnoringInteractionEvents()

    let Menu = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu1ViewController
                                            
        //   Passing Mobile to Passing Mobile Number to AccessSetUpViewController
                                            
                    Menu.temp1 = self.tArray
                    Menu.img = self.temping
                                            
                                            
        self.navigationController?.pushViewController(Menu, animated: true)
                                            
        OperationQueue.main.addOperation {
            
        self.present(Menu, animated: true, completion: nil)
                                                
                                        }
                                            
                                        }
                                    }
        else if((JSondata.value(forKey: "success") as! Int) == 0){
                                        
                                        
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()

                
                        self.indicator.stopAnimating()
                                            
                            return
                                            
                            })
                                        
                verificationStatus =  JSondata.value(forKey: "success") as! Int
                                        
                successMessage = self.msg!
                                        
                verficationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                                    }
                                    
                                    
            verficationAlert.title = successMessage
                                    
    //       verficationAlert.message = JSondata.value(forKey: "message") as! String
                                    
                    OperationQueue.main.addOperation {
                        
                self.present(verficationAlert, animated:true, completion:nil)
                                                    }
                           
                                }
            @IBAction func newToApp(_ sender: AnyObject) {
                                    
                                    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Verification") as! VerificationcodeViewController
                                    
        self.present(vc, animated: true, completion: nil)
                                    
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
                                    
        if Connectivity.isConnectedToInternet(){
            
        var responseString : String!
                                        
                                        
        //    var  MobileNoOTP = OTPgeneratedtxt.text!
            
            if(OTPgeneratedtxt.text == nil || (OTPgeneratedtxt.text?.isEmpty)!){
                
                let alert = UIAlertController(title: "", message: "Please Enter the mobile number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
                                        
                                        MobileNoOTP = OTPgeneratedtxt.text!
                                        
                                        self.kUserDefault.setValue(self.MobileNoOTP, forKey: "MobileNumber")
            
                                        let Sec = OTPgeneratedtxt.text!
                                        
                                        let url = URL(string: Constant.POST.GETOTPFORPINCHANGE.GETOTP)!
                                        
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
                                        
                                        
                                    else{
                                        
                                        let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                                        
                                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(action)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
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
                                        
                                        alert.message = JSondata1.value(forKey: "message") as? String
                                        
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
                                    
                                    
                                    self.indicator.startAnimating()
                                    
                                    if Connectivity.isConnectedToInternet(){
                                        
                                        
                                        
                                        var  OTP = OTPtxt.text!
                                        
                                        
                                        let sec =  OTPtxt.text! +  MobileNoOTP!
                                        
                                        var responseString : String!
                                        
                                        
                                        
                                        
                                        
                                        let url = URL(string: Constant.POST.VERIFYOTP.verifyOtp)!
                                        
                                        
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
                                        
                                    else{
                                        
                                        
                                        self.indicator.stopAnimating()
                                        
                                        let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                                        
                                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(action)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                func parsingTheJsonData2(JSondata2:NSDictionary)
                                {
                                    
                                    if((JSondata2.value(forKey: "success") as! Int) == 1){
                                        
                                        let SetPin = self.storyboard?.instantiateViewController(withIdentifier: "LoginPinReset") as! LoginPinResetAndSaveViewController
                                        
                                        
                                        self.navigationController?.pushViewController(SetPin, animated: true)
                                        
                                        
                                        self.present(SetPin, animated: true, completion: nil)
                                        
                                    }
                                    else if((JSondata2.value(forKey: "success") as! Int) == 0){
                                        
                                        self.indicator.stopAnimating()
                                        
                                        let alert = UIAlertController()
                                        
                                        alert.message = JSondata2.value(forKey: "message") as? String
                                        
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
                            
                            
