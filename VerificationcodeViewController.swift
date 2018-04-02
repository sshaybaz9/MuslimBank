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

    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    let kUserDefault = UserDefaults.standard

    var delegate:PassVerfication? = nil
    @IBOutlet weak var Mobtxt: UITextField!
    var mobileno : String!
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // -- then, further if you want to close the keyboard when pressed somewhere else on the screen you can implement the following method too:
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    //9975252427
    @IBAction func getVerCode(_ sender: AnyObject) {
        
        self.indicator.startAnimating()
    
        
       if ((Mobtxt.text?.isEmpty)!)
       {
        
        let alert = UIAlertController(title: "Required Field is Empty", message: "Please Enter the Mobile Number", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        }
        
        
        
        
        self.kUserDefault.setValue(Mobtxt.text, forKey: "ResendMobile")
   
        if  Connectivity.isConnectedToInternet{

        
   var request = URLRequest(url: URL(string: Constant.POST.VERIFYMOBILEUPDATEACTIVATIONCODE.VMUA)!)
        
  
     
        
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
    //Function call to parse and check the Verifcation response
    func parsingTheJsonData(JSondata:NSDictionary){
        var successMessage : String = String()
        var verificationStatus:Int = Int()
        
        let verficationAlert = UIAlertController()
        if((JSondata.value(forKey: "success") as! Int) == 1){//

                let MTP = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! MobileOTPViewController
        //800515320360
                
          // Passing Data to Other ViewController
                self.delegate = MTP
                self.delegate?.PasstheVerifiationData(mobileNumberM: self.Mobtxt.text!, deviceIdM: self.deviceID!)
                self.navigationController?.pushViewController(MTP, animated: true)
                
            
            OperationQueue.main.addOperation {
                
                self.present(MTP, animated: true, completion: nil)

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
