//
//  ServicesMenuViewController.swift
//  MBank
//
//  Created by Mac on 08/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import ImageSlideshow

class ServicesMenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
var imageArray = [UIImage(named:"changeloginpin.png"),UIImage(named:"locatebranches.png"),UIImage(named:"referfriends.png")]
    
    
    var nameArray = [String]()
    var userDefaultLang : String!

    
    
    
    @IBOutlet weak var SlideImages: ImageSlideshow!
    
    
    let kingfisherSource = [KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"1.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"2.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"3.png")!,KingfisherSource(urlString: Constant.Domain+"appimages/other/"+"4.png")!,]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        
        
        myCollectionView.collectionViewLayout = layout
        
        
        
        
        
        
        
        self.userDefaultLang = UserDefaults.standard.string(forKey: "lang")

        
        
        //  call to Image Slider View
        SlideImages.backgroundColor = UIColor.white
        SlideImages.slideshowInterval = 5.0
        SlideImages.pageControlPosition = PageControlPosition.underScrollView
        SlideImages.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        SlideImages.pageControl.pageIndicatorTintColor = UIColor.black
    //    SlideImages.contentScaleMode = UIViewContentMode.scaleAspectFill
        SlideImages.frame = CGRect(x: 2, y: 2, width: 10, height: 10)
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        
        SlideImages.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        SlideImages.setImageInputs(kingfisherSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        SlideImages.addGestureRecognizer(recognizer)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func didTap() {
        
        let fullScreenController = SlideImages.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //                        fullScreenController.imageSlideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.nameArray = ["Change login pin".localized(lang : self.userDefaultLang),"Locate our branches".localized(lang : self.userDefaultLang),"Refer Friends".localized(lang : self.userDefaultLang)]
        

        
    }
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
 //       let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
          self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Services", for: indexPath) as! ServicesCollectionViewCell
        
        //        cell.layer.cornerRadius = 30
        //        cell.layer.borderColor = UIColor.lightGray.cgColor
        //        cell.layer.borderWidth = 3
        //
        cell.img.image = imageArray[indexPath.row]
        cell.serLbl.text! = nameArray[indexPath.row]
  //      cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    fileprivate func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
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
        
        
               
        
        if (indexPath.row == 0)
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "changePin") as! ChangeLoginPinViewController
            
            self.present(vc, animated: true, completion: nil)
            
        }
        if(indexPath.row == 1)
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! LocateOnMapViewController
            
            let flagSent = "bank"
            
            vc.flag = flagSent
            self.navigationController?.pushViewController(vc, animated: true)
            
            OperationQueue.main.addOperation {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        if (indexPath.row == 2)
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "referFriends") as! ReferFriendsViewController
            
            self.present(vc, animated: true, completion: nil)
            
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
