//
//  TransactionViewController.swift
//  MBank
//
//  Created by Mac on 11/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class TransactionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    var json : NSDictionary?
    
    var beninfo = [BeneficiaryName]()
    
    var temp2 = [Login]()
    
//    var imageArray = [UIImage(named: "payusingmmid.png"),UIImage(named: "accounts_mbank.png"),UIImage(named: "balanceinquiry.png"),UIImage(named: "generatemmid.png"),UIImage(named: "mmid_retrieve.png"),UIImage(named: "disablemmid.png"),UIImage(named: "transinquiry.png"),UIImage(named: "mini_state.png"),UIImage(named: "addbeneficary.png")]
    
//    var nameArray = [NSLocalizedString("Pay using MMID",comment:""),
//                     NSLocalizedString("P2A using IFS Code",comment:""),
//                     NSLocalizedString("Balance inquiry",comment:""),
//                     NSLocalizedString("Generate MMID",comment:""),
//                     NSLocalizedString("Retrieve MMID",comment:""),
//                     NSLocalizedString("Cancel MMID",comment:""),
//                     NSLocalizedString("Transaction inquiry",comment:""),
//                     NSLocalizedString("Mini statement",comment:""),
//                     NSLocalizedString("Add beneficiary",comment:"")]
//    
//    
    
    
     var imageArray = [UIImage(named: "accounts_mbank.png"),UIImage(named: "balanceinquiry.png"),UIImage(named: "transactionhistory.png"),UIImage(named: "generatemmid.png"),UIImage(named: "mmid_retrieve.png"),UIImage(named: "disablemmid.png"),UIImage(named: "transinquiry.png"),UIImage(named: "mini_state.png"),UIImage(named: "addbeneficary.png")]

    
    var userDefaultLang : String!
    
    var nameArray = [String]()
    

    
    var MMID : String!
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    let kingfisherSource = [KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"1.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"2.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"3.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"4.png")!,]
    

    
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
     //   let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu1ViewController
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get current language value from userDefaults
        self.userDefaultLang = UserDefaults.standard.string(forKey: "lang")

    
        //  call to Image Slider View
        imageSlideShow.backgroundColor = UIColor.white
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageControlPosition = PageControlPosition.underScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
      //  imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        
        imageSlideShow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        imageSlideShow.setImageInputs(kingfisherSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.nameArray = ["Pay using Account".localized(lang : self.userDefaultLang),
                          "Balance inquiry".localized(lang : self.userDefaultLang),
                          "Transaction History".localized(lang : self.userDefaultLang),
                          "Generate MMID".localized(lang : self.userDefaultLang),
                          "Retrieve MMID".localized(lang : self.userDefaultLang),
                          "Cancel MMID".localized(lang : self.userDefaultLang),
                          "Transaction inquiry".localized(lang : self.userDefaultLang),
                          "Mini statement".localized(lang : self.userDefaultLang),
                          "Add beneficiary".localized(lang : self.userDefaultLang)]
        
    }

    
    // Function of Slider Image
    
    @objc func didTap() {
        let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //                        fullScreenController.imageSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
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
        
        
        if (indexPath.row == 0){
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayUsing") as! PayUsingAccountViewController
            
            vc.temp3 = self.temp2
            
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
        
        if(indexPath.row == 1)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Balance") as! BalanceEnqryViewController
            self.present(vc, animated: true, completion: nil)
            

        }
        
        if(indexPath.row == 2)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistory2TableViewController
            
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
             alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            
        }
        if(indexPath.row == 3)
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMMID") as! GenerateMMIDViewController
            self.present(vc, animated: true, completion: nil)
            
           
    }
        
        
        if(indexPath.row == 4)
        {
            
if Connectivity.isConnectedToInternet()
{
            
            
            
            let accountNumber = UserDefaults.standard.string(forKey: "AccountNO")
            let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
            
            var responseString : String!
            
            
            
    
            
            let url = URL(string: Constant.POST.RETRIEVEMMID.retrievemmid)!
            

            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let seck =  accountNumber! + mobileNumber!
            
            let postString = "account_no=\(accountNumber!)&mobile_no=\(mobileNumber!)&seck=\(seck)"
            
            print(postString)
            
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                
                do {
                   
                    self.json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    
                    
 
                    
                    
                    self.parsingTheJsonData(JSondata: self.json!)
                }   catch {
                    print(error)
                }
                
                
            }
            task.resume()
                
            }
            else
            {
                
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
            }

        }
        
        
        
        if(indexPath.row == 5){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisableMMID") as! DisableMMIDViewController
            self.present(vc, animated: true, completion: nil)
            
}
   
    
    }
    
    func parsingTheJsonData(JSondata:NSDictionary){
        
        
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            
            self.MMID = self.json?.value(forKey: "mmid") as! String!

            
            let alert = UIAlertController(title: "Your account MMID for IMPS transaction id", message: "\(self.MMID!)", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
          
            }
        }
        else if ((JSondata.value(forKey: "success") as! Int) == 0){
            
            let msg = self.json?.value(forKey: "message") as! String!
            
            let alert = UIAlertController(title: "", message: "\(msg!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            
            OperationQueue.main.addOperation {
                
                self.present(alert, animated:true, completion:nil)
                
            }
            
            
            
        }
        

        

        
    }
    
}
