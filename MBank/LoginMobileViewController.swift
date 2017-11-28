//
//  LoginMobileViewController.swift
//  MBank
//
//  Created by Mac on 21/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class LoginMobileViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var pin1txt: UITextField!

    @IBOutlet weak var pin2txt: UITextField!
    @IBOutlet weak var Mobtxt: UITextField!
    @IBOutlet weak var pin3txt: UITextField!
    @IBOutlet weak var pin4txt: UITextField!
    var lineView1 = UIView(frame: CGRect(x: 0, y: 80, width: 400, height: 5))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To Hide Cursor
        
         pin1txt.tintColor = UIColor.clear
         pin2txt.tintColor = UIColor.clear
         pin3txt.tintColor = UIColor.clear
         pin4txt.tintColor = UIColor.clear
        
        
        pin1txt.isSecureTextEntry = true
        pin2txt.isSecureTextEntry = true
        pin3txt.isSecureTextEntry = true
        pin4txt.isSecureTextEntry = true
        
        pin1txt.delegate = self
        pin2txt.delegate = self
        pin3txt.delegate = self
        pin4txt.delegate = self
        
        
        pin1txt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        pin2txt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        pin3txt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        pin4txt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        
       // Vertically line in view
        lineView1.layer.borderWidth = 10
       lineView1.layer.borderColor = UIColor.orange.cgColor
       self.view.addSubview(lineView1)
        
               
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        
        // Border line TextBox Code
        let lineColor = UIColor(red:0.12, green:0.23, blue:0.35, alpha:1.0)
        self.Mobtxt.setBottomLine(borderColor: lineColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pin1txt.becomeFirstResponder()
        
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case pin1txt:
                pin2txt.becomeFirstResponder()
            case pin2txt:
                pin3txt.becomeFirstResponder()
            case pin3txt:
                pin4txt.becomeFirstResponder()
            case pin4txt:
                pin4txt.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
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
