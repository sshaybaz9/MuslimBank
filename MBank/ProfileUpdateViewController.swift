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
    @IBOutlet weak var stateTxt: UITextField!

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    var picker = UIImagePickerController()
    @IBOutlet weak var profileimg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        profileimg.image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }

    @IBAction func savePressed(_ sender: AnyObject) {
        
        let customerName = UserDefaults.standard.string(forKey: "CustomerName")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let fileName = UserDefaults.standard.string(forKey: "FileName")
        var responseString : String!
        
        
        
        let url = URL(string: "http://115.117.44.229:8443/Mbank_api/saveprofile.php")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let postString = "image=\(profileimg)&name=\(customerName!)&email=\(emailTxt.text!)&address=\(addressTxt.text!)&city=\(cityTxt.text!)&state=\(stateTxt.text!)&client_id=\(clientID!)&filename=\(fileName!)"
        
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
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
    }
}
