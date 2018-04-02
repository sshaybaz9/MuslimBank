//
//  Connectivity.swift
//  MBank
//
//  Created by Mac on 13/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import Alamofire


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
