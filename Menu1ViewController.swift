//
//  Menu1ViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Menu1ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var SliderView: UIView!
   var  imageFromData : UIImage!
    
    @IBOutlet weak var changeloginpin: UIButton!
    
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var view1Img: UIImageView!
    
    var img : UIImage!

    @IBOutlet weak var profielLatestimg: UIImageView!
    var temp1 = [Login]()
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblCustomerName: UILabel!
       var menuShowing = false
    
    var userDefaultLang : String!
    
    var nameArray = [String]()

    
    var imageArray = [UIImage(named: "accounts_mbank.png"),UIImage(named: "transfer.png"),UIImage(named: "tax_payment.png"),UIImage(named: "bill_paym.png"),UIImage(named: "upi.png"),UIImage(named: "locate_atm.png"),UIImage(named: "shoppingcart.png"),UIImage(named: "services.png"),UIImage(named: "cards.png")]
    
    
    
//    var nameArray = [NSLocalizedString("Accounts", comment:""),
//                     NSLocalizedString("Transactions", comment:""),
//                     NSLocalizedString("Loans", comment:""),
//                     NSLocalizedString("Bill payment and Reminder", comment:""),
//                     NSLocalizedString("UPI", comment:""),
//                     NSLocalizedString("Locate ATMs", comment:""),
//                     NSLocalizedString("Offer", comment:""),
//                     NSLocalizedString("Services", comment:""),
//                     NSLocalizedString("Cards", comment:"")]
//    

    let kUserDefault = UserDefaults.standard

    @IBOutlet weak var profileButton: UIButton!
    @IBAction func ContactUsPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "contactus") as! ContactusViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func HomePressed(_ sender: AnyObject) {
        if(menuShowing)
        {
        
            view1Img.image = img
            
            LeadingConstraint.constant = -245
            
            
        }
        else{
   
            view1Img.image = img
            
            LeadingConstraint.constant = 0
        }
        
        menuShowing = !menuShowing
    
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            
            
            
        self.userDefaultLang = UserDefaults.standard.string(forKey: "lang")
    
        changeloginpin.contentHorizontalAlignment = LanguageManger.shared.isRightToLeft ? .right : .left
            
 
        lblCustomerName.text = UserDefaults.standard.string(forKey: "CustomerName")

            self.SliderView.layer.borderWidth = 1
            self.SliderView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
            
//            self.view.layoutIfNeeded()
//
//     self.profielLatestimg.layer.cornerRadius = self.profielLatestimg.frame.size.width / 2
//     self.profielLatestimg.clipsToBounds = true
//       
            
            
//            let imageData = UserDefaults.standard.value(forKey: "key") as? Data
//            
//            if (imageData != nil)
//            
//            {
//             self.imageFromData = UIImage.init(data: imageData!)!
//
////            imageFromData = img
//            
//            profielLatestimg.image = imageFromData
//                
//            }
//            else
//            {
//            }
            
            
            
            profielLatestimg.image = img

            
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            self.profielLatestimg.isUserInteractionEnabled = true
            self.profielLatestimg.addGestureRecognizer(tapGestureRecognizer)
            
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.nameArray =  ["Accounts".localized(lang : self.userDefaultLang),
                          "Transactions".localized(lang : self.userDefaultLang),
                          "Loans".localized(lang : self.userDefaultLang),
                          "Bill payment and Reminder".localized(lang : self.userDefaultLang),
                          "UPI".localized(lang : self.userDefaultLang),
                          "Locate ATMs".localized(lang : self.userDefaultLang),
                          "Offer".localized(lang : self.userDefaultLang),
                          "Services".localized(lang : self.userDefaultLang),
                          "Cards".localized(lang : self.userDefaultLang)]

        
    }
   
    
    override  func  viewDidLayoutSubviews() {
        
                    self.view.layoutIfNeeded()

        self.profielLatestimg.layer.cornerRadius = self.profielLatestimg.frame.size.width / 2
        
        
        self.profielLatestimg.clipsToBounds = true
    }
    
    
   

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileUpdateViewController
        
        self.present(vc, animated: true, completion: nil)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionCollectionViewCell", for: indexPath) as! MenuCollectionCollectionViewCell
        
//        cell.layer.cornerRadius = 30
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.borderWidth = 3
//        
        cell.imgImage.image = imageArray[indexPath.row]
        cell.lblName.text! = nameArray[indexPath.row].localiz()
        
          return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3-1
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 2){
            let alert = UIAlertController(title: "", message: "This feature is under development", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }
        if(indexPath.row == 3){
            let alert = UIAlertController(title: "", message: "This feature is under development", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }
        if(indexPath.row == 4){
            let alert = UIAlertController(title: "", message: "This feature is under development", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }
        if(indexPath.row == 8){
            let alert = UIAlertController(title: "", message: "This feature is under development", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }
        if(indexPath.row == 9){
            let alert = UIAlertController(title: "", message: "This feature is under development", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
        }
        
        if(indexPath.row == 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! AccountsTabBarController
            
            
            
            
            self.present(vc, animated: true, completion: nil)
        }
        if (indexPath.row == 1){
            
        let Transaction = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
            
        
            Transaction.temp2 = self.temp1
            
            self.navigationController?.pushViewController(Transaction, animated: true)
            
            OperationQueue.main.addOperation{
                self.present(Transaction, animated: true, completion: nil)
            }

        }
        if(indexPath.row == 5)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! LocateOnMapViewController
            
            let flagSent = "atm"
            
            vc.flag = flagSent
            self.navigationController?.pushViewController(vc, animated: true)
            
            OperationQueue.main.addOperation {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        if (indexPath.row == 7)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "services") as!  ServicesMenuViewController
            self.present(vc, animated: true, completion: nil)
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    
   
    @IBAction func MenuShow(_ sender: AnyObject) {
        

        
        if(menuShowing)
        {
            self.welcomeLbl.isHidden = false

            
                            self.view1Img.image = img

                
                self.view1Img.layer.cornerRadius = self.view1Img.frame.size.width / 2
                self.view1Img.clipsToBounds = true
                

                LeadingConstraint.constant = -245

                
            
            
        
        }
        else {

            self.welcomeLbl.isHidden = true

            
                            self.view1Img.image = img
                
                LeadingConstraint.constant = 0
          
           
        }
        
        menuShowing = !menuShowing
    }
    
    @IBAction func Rating(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "rate") as! RatingAppViewController
        
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func MyAccount(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! AccountsTabBarController
        
    //    let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "Sum1Account") as! Summary1AccountBalanceViewController
        

        
        self.present(vc, animated: true, completion: nil)

        
        
        
        
    }
    
    
    
    @IBAction func Profile(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileUpdateViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func ChangeLoginPin(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePin") as! ChangeLoginPinViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func ContactUs(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "contactus") as! ContactusViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func changeLanguage(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Language") as! LanguageSelectorViewController
        
        
        
        vc.img = self.img
        vc.temp1 = self.temp1
        self.present(vc, animated: true, completion: nil)
        
        
    }
    @IBAction func Logout(_ sender: AnyObject) {

        
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginMobileViewController
        
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        self.welcomeLbl.isHidden = false
//
//        self.SliderView.isHidden = true
//    }
//    
   
}

extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }}

