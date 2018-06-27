    //
    //  LocateOnMapViewController.swift
    //  MBank
    //
    //  Created by Mac on 08/02/18.
    //  Copyright © 2018 Mac. All rights reserved.
    //

    import UIKit
    import  GoogleMaps
    import CoreLocation
    import GooglePlaces
    class LocateOnMapViewController: UIViewController, GMSMapViewDelegate {

        
        var flag : String!
        
        var Latt : Double?
        var Long : Double?
        
        var locationArray = [LocationPojo]()
        
           @IBOutlet fileprivate weak var mapView: GMSMapView!
        var gmsFetcher: GMSAutocompleteFetcher!

        
        let currentLocationMarker = GMSMarker()
        var locationManager = CLLocationManager()
        var currentLocation: CLLocation?
        var placesClient: GMSPlacesClient!
        var zoomLevel: Float = 15.0
        
        let customMarkerWidth: Int = 50
        let customMarkerHeight: Int = 70
        
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        @IBAction func BackButton(_ sender: AnyObject) {
            
             self.dismiss(animated: true, completion: nil)
            
           
            
           
        }
       
        override func viewDidLoad(){
            
            super.viewDidLoad()

            if Connectivity.isConnectedToInternet(){
            
            print(flag)
            locationManager = CLLocationManager()

            
            placesClient = GMSPlacesClient.shared()
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                locationManager.distanceFilter = 500
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
            mapView.settings.myLocationButton = true
            mapView.settings.zoomGestures = true
            mapView.animate(toViewingAngle: 45)
            mapView.delegate = self
        
          
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            }
            
            else
            {
                
                let alert = UIAlertController(title:"No Internet Connection" , message:"Make sure your device is connected to the internet." , preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)

                
            }
            
        }
        
        
        func showPartyMarkers(lat: Double, long: Double ,locName :String) {

            DispatchQueue.main.async {
                
                let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let marker = GMSMarker(position: position)
   //             marker.icon = GMSMarker.markerImage(with: .black)
              
                if (self.flag == "atm"){
                marker.icon = UIImage(named : "Webp.net-resizeimage (1).png")
                }
                else{
                    
                    marker.icon = UIImage(named : "bankMarker.png")

                    
                }
                marker.title = locName
                marker.snippet = locName
                marker.map = self.mapView
                
            }
           
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

    }
    extension LocateOnMapViewController: CLLocationManagerDelegate {
        
        // Handle incoming location events.
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location: CLLocation = locations.last!
            print("Location: \(location)")
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
            
            let lat = (location.coordinate.latitude)
            let long = (location.coordinate.longitude)
            
            showPartyMarkers(lat: lat, long: long,locName : "This is your Location")
            getLocation(mLat: String(format:"%f",lat),mLong: String(format:"%f",long))

        }
        
        
        // Handle authorization for the location manager.
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                manager.startUpdatingLocation()
                // ...
                
                mapView.isMyLocationEnabled = true
                           }
        }
        
        // Handle location manager errors.
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            locationManager.stopUpdatingLocation()
            print("Error: \(error)")
        }
        
        
        func getLocation(mLat:String,mLong:String)
        {
            if Connectivity.isConnectedToInternet()
            {
            
            var responseString : String!
            
            let url = URL(string: Constant.POST.GETNEARBYATMS.atms)!
            
            var request = URLRequest(url: url)
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let seck = mLat + mLong
            
            var postString = "lat=\(mLat)&lng=\(mLong)&seck=\(seck)"
            
            
            if(self.flag == "atm"){
                postString += "type=\("atm")&name=\("")"
            } else {
                postString += "type=\("bank")&name=\("Muslim")"
            }
            
            print(postString)
            
            self.indicator.startAnimating()
            
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
                
                DispatchQueue.main.async(execute: {
                    self.indicator.stopAnimating()

                })
                var json: NSDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    
                    
                    let res = json?.value(forKey: "results") as? NSArray
                    
                    
                    for item in res!
                    {
                     let obj = item as! NSDictionary
                        
                        let locObj = LocationPojo()

                        locObj.atmName = obj.value(forKey: "name") as! String!
                        
                    let geom = obj.value(forKey: "geometry") as? NSDictionary
                        
                    let loc = geom?.value(forKey: "location") as? NSDictionary
                        
                        var intlat : Double!
                        intlat =    loc?.value(forKey: "lat") as! Double!
                        locObj.mLatitude = String(describing: intlat!)
                        
                        print(locObj.mLatitude)
                        
                        var intLng : Double?
                        intLng = loc?.value(forKey: "lng") as? Double

                        locObj.mLongitude = String(describing: intLng!)
                        
                         print(locObj.mLongitude)
                        
                        self.locationArray.append(locObj)
                    
                    }
                    
                    print(self.locationArray.count)
                   // var idArray = [String]()
                    for employee in self.locationArray {
                        
                        self.showPartyMarkers(lat: Double(employee.mLatitude)!, long: Double(employee.mLongitude)!,locName:employee.atmName!)
                        
                    }
                    
                  
                    self.parsingTheJsonData(JSondata: json!)
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
        
        func parsingTheJsonData(JSondata:NSDictionary){
        }

    }


    class LocationPojo
    {
        
        var mLatitude : String!
        var mLongitude : String!
        var atmName : String!
        
        init()
        {
            
        }
        init(mLatitude1: String, mLongitude1: String, atmName1: String) {
            self.mLatitude = mLatitude1
            self.mLongitude = mLongitude1
            self.atmName = atmName1
        }
        
    }



   
