//
//  RollBack.swift
//  JPS
//
//  Created by Jerry U. on 9/14/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import Alamofire

class RollBack: NSObject {

    override init() {
        super.init()
        
        Alamofire.request("https://jps.lyshnia.com/api/roll.php?cdc=\(userHandler.cdc)&rollee").responseJSON { (response) in
            
            print(response)
        }
    }
    
    static func rollee() {
        
    }
    
}
