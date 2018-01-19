//
//  ServicesMenuViewController.swift
//  MBank
//
//  Created by Mac on 08/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ServicesMenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var imageArray = [UIImage(named: "transactionhistory.png"),UIImage(named: "changeloginpin.png"),UIImage(named:"locatebranches.png"),UIImage(named:"referfriends.png")]
    var nameArray = ["Transaction History","Change login pin","Locate our branches","Refer Friends"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackPressed(_ sender: AnyObject) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Transaction") as! TransactionViewController
        
        self.present(vc, animated: true, completion: nil)
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistory2TableViewController
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
        if (indexPath.row == 3)
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
