//
//  ReferFriendsViewController.swift
//  MBank
//
//  Created by Mac on 11/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class ReferFriendsViewController: UIViewController,MFMessageComposeViewControllerDelegate,CNContactPickerDelegate,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var name: UITextField!
    var messageComposeDelegate : MFMessageComposeViewControllerDelegate?
    
        
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func Submit(_ sender: AnyObject) {
        
        let activityVC = UIActivityViewController.init(activityItems: ["www.google.com"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
        if (MFMessageComposeViewController.canSendText()) {
            
            let controller = MFMessageComposeViewController()
            controller.body = "https://www.google.com"
            controller.recipients = [phoneNumber.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ContactInfo(_ sender: AnyObject) {
        
        
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    
    
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                
                
                
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
                
                
                for ContctNumVar: CNLabeledValue in contact.phoneNumbers
                {
                    let MobNumVar  = (ContctNumVar.value ).value(forKey: "digits") as? String
                    
                    
                    self.phoneNumber.text = MobNumVar!
                }
                
            }
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
 
}




