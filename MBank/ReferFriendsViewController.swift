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
                    let MobNumVar  = (ContctNumVar.value as! CNPhoneNumber).value(forKey: "digits") as? String
                    
                    
                    self.phoneNumber.text = MobNumVar!
                }
                
            }
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    
    
    func launchEmail(sender: AnyObject) {
         if MFMailComposeViewController.canSendMail() {
            let  emailTitle = "Feedback"
            let messageBody = "Feature request or bug report?"
            let toRecipents = ["friend@stackoverflow.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:Error) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
        
        
    
}


// mail  Link

//https://stackoverflow.com/questions/25981422/how-to-open-mail-app-from-swift
