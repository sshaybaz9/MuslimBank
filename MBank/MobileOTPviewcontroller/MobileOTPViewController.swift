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

   // Delegate Declartion For Passing Mobile Number to AccessSetUpViewController
    var delegate : PassMobileNumber? = nil
    
    var mobileNumber : String!
    var deviceId : String!
    
    @IBOutlet weak var Numtxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Numtxt.delegate = self
        
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
        var request = URLRequest(url: URL(string: "http://115.117.44.229:8443/Mbank_api/verifyactivationcode.php")!)
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
            } catch {
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
            successMessage = "Success"
            verificationStatus =  JSondata.value(forKey: "success") as! Int
            verficationAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            verficationAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                let Access = self.storyboard?.instantiateViewController(withIdentifier: "setUp") as! AccSetupLoginViewController
//   Passing Mobile to Passing Mobile Number to AccessSetUpViewController
                self.delegate = Access
                self.delegate?.PassNumber(mobileNumber2: self.mobileNumber!,deviceID2: self.deviceId!)
                let kUserDefault = UserDefaults.standard
                
                kUserDefault.setValue(self.mobileNumber, forKey: "RegisteredMobileNumber")
                kUserDefault.setValue(self.deviceId, forKey: "RegisteredDeviceID")
                self.navigationController?.pushViewController(Access, animated: true)
                
                
                self.present(Access, animated: true, completion: nil)
            }))
        }else if((JSondata.value(forKey: "success") as! Int) == 0){
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
