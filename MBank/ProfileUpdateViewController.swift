    //
    //  ProfileUpdateViewController.swift
    //  MBank
    //
    //  Created by Mac on 18/01/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //

    import UIKit
    import Foundation

    class ProfileUpdateViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
        
        let button = UIButton(type: UIButtonType.custom)

        var activeTextField : UITextField!

        
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

        
        let kUserDefault = UserDefaults.standard

        
        var customerName : String?
        

        var url1  = Constant.Domain

        @IBOutlet weak var stateTxt: UITextField!

        @IBOutlet weak var emailTxt: UITextField!
        
        @IBOutlet weak var mobiletxt: UITextField!
        @IBOutlet weak var cityTxt: UITextField!
        @IBOutlet weak var addressTxt: UITextField!
        var picker = UIImagePickerController()
        @IBOutlet weak var profileimg: UIImageView!
        @IBOutlet weak var nametxt: UITextField!
        
        var img : UIImage!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.mobiletxt.delegate = self
            self.nametxt.delegate = self
            self.cityTxt.delegate = self
            self.addressTxt.delegate = self
            self.emailTxt.delegate = self
            self.stateTxt.delegate = self
            
            
            // View Frame will Move Up when Keyboard hide the frame
            
            let center : NotificationCenter = NotificationCenter.default;
            center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
            
            
            
            
            
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            
            
            
            //Retrieving Image Name from UsrDefaults
            
            
            self.customerName = UserDefaults.standard.string(forKey: "CustomerName")
            
            //retrieving filename from user defaults
            let imageName = UserDefaults.standard.string(forKey: "FileName")
            
            //generating url from filename
            var img2 = self.url1 + "uploads/"
            img2  +=   (self.customerName?.removingWhitespaces())! + "/profile_images/" + imageName! + ".jpg"
            
            //converting image url to imageData
            let imgData = try! Data.init(contentsOf: URL(string: img2)!)
            
            //converting imageData to image
            self.img = UIImage.init(data: imgData)!
            self.profileimg.image = img
            
            //applying circle effect
            self.view.layoutIfNeeded()
            self.profileimg.layer.cornerRadius = self.profileimg.frame.size.width / 2
            self.profileimg.clipsToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            self.profileimg.isUserInteractionEnabled = true
            self.profileimg.addGestureRecognizer(tapGestureRecognizer)
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
        
        


        
        func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            
            let alert = UIAlertController(title: "Take Profile Photo", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (Next) in
                self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
                
                
            }))
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (Next) in
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
                
                
            }))
            
            
            
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            img = info["UIImagePickerControllerOriginalImage"] as! UIImage
            
            self.profileimg.image = img
            
            
            self.dismiss(animated: true, completion: nil)
            
            
            
        }
        @IBAction func Back(_ sender: AnyObject) {
            
            
            
            self.dismiss(animated: true, completion: nil)
        }

        @IBAction func savePressed(_ sender: AnyObject) {
            
            
            
            self.indicator.startAnimating()
            
            if Connectivity.isConnectedToInternet
                
                
            {
                
                
                
                
                self.customerName = UserDefaults.standard.string(forKey: "CustomerName")
                let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
                let clientID = UserDefaults.standard.string(forKey: "ClientID")
                let fileName = UserDefaults.standard.string(forKey: "FileName")
                var responseString : String!
                
                
                
                
                
                if((emailTxt.text?.isEmpty)! || (addressTxt.text?.isEmpty)! || (cityTxt.text?.isEmpty)! || (stateTxt.text?.isEmpty)! ){
                    
                    
                    
                    let alert = UIAlertController(title: "Required field is Empty", message: "Please enter the missing Field", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
                
                
                let myUrl = URL(string: Constant.POST.SAVEPROFILE.saveprofile)!
                
                
                
                let request = NSMutableURLRequest(url:myUrl);
                request.httpMethod = "POST";
                
                let param = [
                    "name"  : self.customerName!,
                    "email"    : emailTxt.text!,
                    "address"    : addressTxt.text!,
                    "city" : cityTxt.text!,
                    "state" : stateTxt.text!,
                    "client_id"  : clientID!
                ]
                
                let boundary = generateBoundaryString()
                
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                
                let imageData = UIImageJPEGRepresentation(profileimg.image!, 1)
                
                
                print(imageData)
                
                if(imageData==nil)
                { return; }
                
                request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imageData! as NSData, boundary: boundary) as Data
                
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                    
                    // You can print out response object
                    print("******* response = \(response)")
                    
                    // Print out reponse body
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("****** response data = \(responseString!)")
                    
                    
                    self.indicator.stopAnimating()
                    
                    //            do {
                    //                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    //
                    //                print(json)
                    //
                    //
                    //
                    //
                    
                    DispatchQueue.main.async(execute: {
                        
                        
                        self.profileimg.image = nil;
                        
                    });
                    
                    var json: NSDictionary?
                    do {
                        json = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                        
                        
                        let imgurl = json?.value(forKey: "profile_image")as? String
                        if (imgurl != nil)
                        {
                            self.kUserDefault.setValue(imgurl, forKey: "FileName")
                            var img2 = self.url1 + "uploads/"
                            img2  +=   (self.customerName?.removingWhitespaces())! + "/profile_images/" + imgurl! + ".jpg"
                            
                            
                            let imgData = try! Data.init(contentsOf: URL(string: img2)!)
                            
                            self.img = UIImage.init(data: imgData)!
                            
                            
                            
                            self.profileimg.image = self.img
                            
                            
                       UserDefaults.standard.register(defaults: ["key":UIImageJPEGRepresentation(self.profileimg.image!, 100)!])
                            
                            
                            UserDefaults.standard.set(UIImageJPEGRepresentation(self.profileimg.image!, 100), forKey: "key")

                            
                        }
                        print(json)
                        
                        self.parsingTheJsonData(JSondata: json!)
                    }   catch {
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
            
            
            //            }catch
            //            {
            //                print(error)
            //            }
            //            
            //        }
            //        
            //        task.resume()
            
        }
        
        func parsingTheJsonData(JSondata:NSDictionary){
            
            
            if((JSondata.value(forKey: "success") as! Int) == 1){
                
                let alert = UIAlertController()
                
                alert.addAction(UIAlertAction(title: "Profile Updated Successfully", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                

            }
            
            
            
        }
        
        func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
            let body = NSMutableData();
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }
            
            let filename = "user-profile.jpg"
            let mimetype = "image/jpg"
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            
            
            
            body.appendString(string: "--\(boundary)--\r\n")
            
            return body
        }
        
        
        
        
        func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
        
        
        
        
        
    }
    
    
    
    extension NSMutableData {
        
        func appendString(string: String) {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            append(data!)
        }
    }
    
