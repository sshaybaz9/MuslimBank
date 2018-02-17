    //
    //  ProfileUpdateViewController.swift
    //  MBank
    //
    //  Created by Mac on 18/01/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //

    import UIKit
    import Foundation

    class ProfileUpdateViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
        let kUserDefault = UserDefaults.standard

        
        var customerName : String?
        
        var url1 = "http://115.117.44.229:8443/Mbank_api/"

        @IBOutlet weak var stateTxt: UITextField!

        @IBOutlet weak var emailTxt: UITextField!
        
        @IBOutlet weak var cityTxt: UITextField!
        @IBOutlet weak var addressTxt: UITextField!
        var picker = UIImagePickerController()
        @IBOutlet weak var profileimg: UIImageView!
        
        var img : UIImage!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
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

        func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (Next) in
                 self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
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
            
            self.customerName = UserDefaults.standard.string(forKey: "CustomerName")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            let clientID = UserDefaults.standard.string(forKey: "ClientID")
            let fileName = UserDefaults.standard.string(forKey: "FileName")
            var responseString : String!
            
            
            let myUrl = URL(string: "http://115.117.44.229:8443/Mbank_api/saveprofile.php")!
            
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
                        
                    }
                    print(json)
                    
                    self.parsingTheJsonData(JSondata: json!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()

                    
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

