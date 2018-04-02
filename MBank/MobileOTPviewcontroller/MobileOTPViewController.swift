//
//  MobileOTPViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

// Protocol for Passing Mobile Number to AccessSetUpViewController
protocol PassMobileNumber {
    func PassNumber(mobileNumber2:String,deviceID2: String)
}



class MobileOTPViewController: UIViewController,PassVerfication,UITextFieldDelegate {
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

   // Delegate Declartion For Passing Mobile Number to AccessSetUpViewController
    var delegate : PassMobileNumber? = nil
    
    var mobileNumber : String!
    var deviceId : String!
    
    @IBOutlet weak var Numtxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Numtxt.delegate = self
        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        

        
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

    @IBAction func ProceedBtn(_ sender: AnyObject) {
        
        
        self.indicator.startAnimating()
        
        if Connectivity.isConnectedToInternet
        {
        
        
        if ((Numtxt.text?.isEmpty)!)
        {
            
            let alert = UIAlertController(title: "Required Field Empty", message: "Please Enter the Code", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
        
        
      
        
      var request = URLRequest(url: URL(string: Constant.POST.VERIFYACTIVATIONCODE.VERIFY)!)
        
        
        
        
        
        request.httpMethod = "POST"
        var normalSecuritycode = Numtxt.text!  + mobileNumber
        let postString = "activation_code=\(Numtxt.text!)&mobile_number=\(mobileNumber!)&seck=\(normalSecuritycode)&deviceId=\(deviceId!)"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                self.parsingTheJsonData(JSondata: json!)//Function call to parse the Json response..
                
                
                self.indicator.stopAnimating()
            } catch {
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
    func parsingTheJsonData(JSondata:NSDictionary){
        var successMessage : String = String()
        var verificationStatus:Int = Int()
        
        let verficationAlert = UIAlertController()
        if((JSondata.value(forKey: "success") as! Int) == 1){//
            successMessage = "Success"

                let Access = self.storyboard?.instantiateViewController(withIdentifier: "setUp") as! AccSetupLoginViewController
//   Passing Mobile to Passing Mobile Number to AccessSetUpViewController
                self.delegate = Access
                self.delegate?.PassNumber(mobileNumber2: self.mobileNumber!,deviceID2: self.deviceId!)
                let kUserDefault = UserDefaults.standard
                
                kUserDefault.setValue(self.mobileNumber, forKey: "RegisteredMobileNumber")
                kUserDefault.setValue(self.deviceId, forKey: "RegisteredDeviceID")
                self.navigationController?.pushViewController(Access, animated: true)
                
            
            OperationQueue.main.addOperation {
                
                self.present(Access, animated: true, completion: nil)

            }
        }else if((JSondata.value(forKey: "success") as! Int) == 0){
            
            
            self.indicator.stopAnimating()
            verificationStatus =  JSondata.value(forKey: "success") as! Int
            successMessage = "Invalid mobile number"
            verficationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        }
        verficationAlert.title = successMessage
        verficationAlert.message = JSondata.value(forKey: "message") as! String
        OperationQueue.main.addOperation {
            self.present(verficationAlert, animated:true, completion:nil)
        }
    }
    //Function call to generate the alertview for verification
    func showTheAlertviewpopUp (messageTodisplay:String){
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Numtxt.setBottomLine(borderColor: lineColor)
        
    }
    
    
    @IBAction func ResendVerificationCode(_ sender: AnyObject) {
        
        self.indicator.startAnimating()
     
        if Connectivity.isConnectedToInternet
        
        {
        
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString

        
        let mobileNo = UserDefaults.standard.string(forKey: "ResendMobile")

        
        
        
  
        
        
    var request = URLRequest(url: URL(string: Constant.POST.VERIFYMOBILEUPDATEACTIVATIONCODE.VMUA)!)
        
        request.httpMethod = "POST"
        
        print(deviceID)
        
        let postString = "mobile_number=\(mobileNo!)&android_id=\(deviceID!)"
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                self.parsingTheJsonData1(JSondata1: json!)
            
                self.indicator.stopAnimating()
            
            } catch {
                print(error)
            }
        }
        task.resume()
        }
        
        
        else
        {
            
            self.indicator.stopAnimating()
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            var action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

            
            
        }
        
    }
    
    
    func parsingTheJsonData1(JSondata1:NSDictionary){
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Delegate function to get the verfication
    func PasstheVerifiationData(mobileNumberM: String, deviceIdM deviceIdm: String) {
        mobileNumber = mobileNumberM
        deviceId = deviceIdm
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
