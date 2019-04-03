//
//  Reachability.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 03/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Reachability {
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
     func checkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            print(flags)
            if flags.contains(.isWWAN) {
               UIAlertController(title: "via mobile", message: "Reachable", preferredStyle: .alert)
                print("via mobile")
                return true
            }
            UIAlertController(title: "via wifi", message: "Reachable", preferredStyle: .alert)
            print("via wifi")
            return true
        } else if (!isNetworkReachable(with: flags)) {
            UIAlertController(title: "Sorry no connection", message: "Unreachable", preferredStyle: .alert)
            print(flags)
            print("no connection")
            return false
        }
        return false
    }
    
     func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectAutomatically)
    }
}
