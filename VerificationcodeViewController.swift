//
//  VerificationcodeViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

protocol PassVerfication {
    func PasstheVerifiationData(mobileNumberM:String ,deviceIdM:String)
}
class VerificationcodeViewController: UIViewController,UITextFieldDelegate {

    var delegate:PassVerfication? = nil
    @IBOutlet weak var Mobtxt: UITextField!
    var mobileno : String!
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
    @IBAction func getVerCode(_ sender: AnyObject) {
    var request = URLRequest(url: URL(string: "http://115.117.44.229:8443/Mbank_api/verifyupdatemobileactivation.php")!)
    request.httpMethod = "POST"
        
        print(deviceID)
        
    let postString = "mobile_number=\(Mobtxt.text!)&android_id=\(deviceID!)"
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
    //Function call to parse and check the Verifcation response
    func parsingTheJsonData(JSondata:NSDictionary){
        var successMessage : String = String()
        var verificationStatus:Int = Int()
        
        let verficationAlert = UIAlertController()
        if((JSondata.value(forKey: "success") as! Int) == 1){//
            successMessage = "OTP generated Succesfully"
            verificationStatus =  JSondata.value(forKey: "success") as! Int
            verficationAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            verficationAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                let MTP = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! MobileOTPViewController
        //800515320360
                
          // Passing Data to Other ViewController
                self.delegate = MTP
                self.delegate?.PasstheVerifiationData(mobileNumberM: self.Mobtxt.text!, deviceIdM: self.deviceID!)
                self.navigationController?.pushViewController(MTP, animated: true)
                
                
                self.present(MTP, animated: true, completion: nil)
                
                
                
            
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
        self.Mobtxt.setBottomLine(borderColor: lineColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
