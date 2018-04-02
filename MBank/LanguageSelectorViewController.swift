//
//  LanguageSelectorViewController.swift
//  MBank
//
//  Created by Mac on 22/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LanguageSelectorViewController: UIViewController {
    @IBOutlet weak var marathi: RadioButton!

    @IBOutlet weak var urdu: RadioButton!
    @IBOutlet weak var hindi: RadioButton!
    @IBOutlet weak var english: RadioButton!
    
    var selectedLanguage : Languages!

    
    
    lazy var radioButtons: [RadioButton] = {
        return [
            self.english,
            self.hindi,
            self.marathi,
            self.urdu,
            ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EnglishPressed(_ sender: RadioButton) {
        
        updateRadioButton(sender)

        print("English Pressed")
        self.selectedLanguage = .en
        
    }
    
    @IBAction func HindiPressed(_ sender: RadioButton) {
        
        updateRadioButton(sender)

        print("Hindi Pressed")
        self.selectedLanguage = .hi


    }
    
    @IBAction func MarathiPressed(_ sender: RadioButton) {
        updateRadioButton(sender)
        self.selectedLanguage = .mr

        print("Marathi Pressed")

    }
    
    @IBAction func UrduPressed(_ sender: RadioButton) {
        updateRadioButton(sender)
        self.selectedLanguage = .ur

        print("Urdu Pressed")

    }
    
    
    
    func updateRadioButton(_ sender: RadioButton){
        radioButtons.forEach { $0.isSelected = false }
        sender.isSelected = !sender.isSelected
        
    }
    
    func getSelectedRadioButton() -> RadioButton? {
        var radioButton: RadioButton?
        radioButtons.forEach { if($0.isSelected){ radioButton =  $0 } }
        return radioButton
    }
    
    

    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
 
    
    
    
   
    
    
    
    
    
    
    @IBAction func applyLanguage(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Do You Want to Change Languages", message: "You have to restart the application for this process", preferredStyle: .alert)
        

        let okaction = UIAlertAction(title: "Proceed", style: .default, handler: self.changeLanguage)
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        
        alert.addAction(okaction)
        OperationQueue.main.addOperation {
            
            
            self.present(alert, animated: true, completion: nil)
        }
    
    
      //  changeLanguage()
    }
    
    func changeLanguage(alert: UIAlertAction)
    {
        
        LanguageManger.shared.setLanguage(language: selectedLanguage)
        
              
        
    //    exit(EXIT_SUCCESS)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
        
        
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginMobileViewController
        //
        //        self.present(vc, animated: true, completion: nil)
        //        
        //    
        
    }

}
// I have use this link 
//https://github.com/Abedalkareem/LanguageManger-iOS


//https://www.factorialcomplexity.com/blog/2015/01/28/how-to-change-localization-internally-in-your-ios-application.html
