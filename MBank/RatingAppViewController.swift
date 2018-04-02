//
//  RatingAppViewController.swift
//  Pods
//
//  Created by Mac on 21/02/18.
//
//

import UIKit

class RatingAppViewController: UIViewController {

    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    
    @IBOutlet weak var RatingControl: RatingControl!
    
    
    var ratingMessage : String!
    
    var rat : Int!

    
    let kuserDefualts = UserDefaults.standard
    
    @IBAction func Back(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        

        
        
        let call = RatingControl
        
        
    let userRating = UserDefaults.standard.string(forKey: "Rating")

        
        print(userRating)
        
        
    
        
       call?.updateButtonSelectionStates(rating: Int(userRating!)!)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Submit(_ sender: AnyObject) {
    
    self.indicator.startAnimating()
        if Connectivity.isConnectedToInternet{
        
        
        
        let temp = RatingControl
        
       self.rat = temp?.rating
    
        
    
        
        
let clientID = UserDefaults.standard.string(forKey: "ClientID")
        let mobileNumber = UserDefaults.standard.string(forKey: "MobileText")
        
        var responseString : String!
        
        
        
        let url = URL(string: Constant.POST.UPDATERATING.updaterating)!

        
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        
        let tempMobile = "8149122032"
        
        let tempCleint = "4398972"
        
        
        let seck = tempMobile + tempCleint
        
        let postString = "mobile_no=\(mobileNumber!)&client_id=\(clientID!)&rating=\(rat!)&seck=\(seck)"
        
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
            self.indicator.stopAnimating()
            
            var json: NSDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                
                print(json)
                
                self.ratingMessage = json?.value(forKey: "message") as! String!
                
                
                self.parsingTheJsonData(JSondata: json!)
            }   catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        }else
        
        {
            self.indicator.stopAnimating()
            
            
            let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

        }
        
    }
   
    func parsingTheJsonData(JSondata:NSDictionary){
        
        if((JSondata.value(forKey: "success") as! Int) == 1){
            
            
            
            self.kuserDefualts.set(self.rat, forKey: "Rating")
            
            
            let alert = UIAlertController()
            
            alert.addAction(UIAlertAction(title: "\(self.ratingMessage!)", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
            

        }
        
        else{
            self.indicator.stopAnimating()
            
            
            let alert = UIAlertController(title: "Error" , message: "Could not update rating!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
            
            

    }
}
