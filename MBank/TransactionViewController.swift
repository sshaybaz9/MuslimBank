//
//  TransactionViewController.swift
//  MBank
//
//  Created by Mac on 11/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

//    var imageArray = [UIImage(named: "payusingmmid.png"),UIImage(named: "accounts_mbank.png"),UIImage(named: "generatemmid.png"),UIImage(named: "mmid_retrieve.png"),UIImage(named: "disablemmid.png"),UIImage(named: "transinquiry.png"),UIImage(named: "mini_state.png"),UIImage(named:"shoppingcart.png")]
//    
//    var nameArray = ["Pay using MMID(IMPS)","P2A using IFS Code(IMPS)","Bill payment and Reminder","Generate MMID","Retrieve MMID","Cancel MMID","Transaction inquiry","Mini statement","Add beneficiary"]
//    
    
    var beninfo = [BeneficiaryName]()
    
    var temp2 = [Login]()
    
    var imageArray = [UIImage(named: "payusingmmid.png"),UIImage(named: "accounts_mbank.png"),UIImage(named: "balanceinquiry.png"),UIImage(named: "generatemmid.png"),UIImage(named: "mmid_retrieve.png"),UIImage(named: "disablemmid.png"),UIImage(named: "transinquiry.png"),UIImage(named: "mini_state.png"),UIImage(named: "addbeneficary.png")]
    
    var nameArray = ["Pay using MMID(IMPS)","P2A using IFS Code(IMPS)","Balance inquiry","Generate MMID","Retrieve MMID","Cancel MMID","Transaction inquiry","Mini statement","Add beneficiary"]
    
    var MMID : String!
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu1ViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        // Do any additional setup after loading the view.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Transaction", for: indexPath) as! TransactionCollectionViewCell
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
        
        
        if(indexPath.row == 1)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayUsing") as! PayUsingAccountViewController
            
            vc.temp3 = self.temp2
            
            self.present(vc, animated: true, completion: nil)
        }
        
        if(indexPath.row == 2)
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Balance") as! BalanceEnqryViewController
            self.present(vc, animated: true, completion: nil)

            
        }
        if (indexPath.row == 6)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionEnquiry") as! TransactionStatusViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        
        if(indexPath.row == 7)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MiniStatment") as! MiniStatementViewController
            self.present(vc, animated: true, completion: nil)

        }
        
        if(indexPath.row == 8)
        {
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Add new beneficiary", style: .default, handler: { (Next) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Beneficiary")as!AddNewBeneficiaryViewController
                    self.present(vc, animated: true, completion: nil)
                    }))
            alert.addAction(UIAlertAction(title: "View beneficiary list", style: .default, handler: { (Next) in
let vc = self.storyboard?.instantiateViewController(withIdentifier: "BeneficiaryList") as! BeneficiaryListViewController
                self.present(vc, animated: true, completion: nil)
                
            }))
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: { (Finished) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "setUp")
                as! AccSetupLoginViewController
                self.present(vc, animated: true
                    , completion: nil)
            }))
            self.present(alert,animated: true, completion: nil)
        }
        if(indexPath.row == 3)
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMMID") as! GenerateMMIDViewController
            self.present(vc, animated: true, completion: nil)
            
           
    }
        
        
        if(indexPath.row == 4)
        {
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            var responseString : String!
            
            
            
    let url = URL(string: "http://115.117.44.229:8443/Mbank_api/retrievemmid.php")!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            var seck =  accountNumber! + mobileNumber!
            
            let postString = "account_no=\(accountNumber!)&mobile_no=\(mobileNumber!)&seck=\(seck)"
            
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
                    
                    
                    self.MMID = json?.value(forKey: "mmid") as! String!
 
                    
                    print(self.MMID)
                    
                    self.parsingTheJsonData(JSondata: json!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()

        }
        
        
        
        if(indexPath.row == 5){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisableMMID") as! DisableMMIDViewController
            self.present(vc, animated: true, completion: nil)
            
}
   
    
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            let alert = UIAlertController(title: "Your account MMID for IMPS transaction id", message: "\(self.MMID!)", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
          
            }
        }
        
        

        
    }
    
}
