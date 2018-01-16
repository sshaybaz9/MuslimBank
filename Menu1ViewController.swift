//
//  Menu1ViewController.swift
//  MBank
//
//  Created by Mac on 23/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Menu1ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    var temp1 = [Login]()
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblCustomerName: UILabel!
       var menuShowing = false
   
    
    var imageArray = [UIImage(named: "accounts_mbank.png"),UIImage(named: "transfer.png"),UIImage(named: "locate_atm.png"),UIImage(named: "bill_paym.png"),UIImage(named: "upi.png"),UIImage(named: "services.png"),UIImage(named: "shoppingcart.png"),UIImage(named: "tax_payment.png"),UIImage(named: "cards.png")]
    
    var nameArray = ["Accounts","Transfer","Locate ATMs","Bill payment and Reminder","UPI","Services","Offer","Tax payment","Cards"]
    
    let kUserDefault = UserDefaults.standard

    @IBAction func ContactUsPressed(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "contactus") as! ContactusViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
            
        lblCustomerName.text = UserDefaults.standard.string(forKey: "CustomerName")
        
        
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
        cell.lblName.text! = nameArray[indexPath.row]
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
        if (indexPath.row == 5)
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
            LeadingConstraint.constant = -245
            
        }
        else{
            
            LeadingConstraint.constant = 0
        }
        
        menuShowing = !menuShowing
    }
    
}
