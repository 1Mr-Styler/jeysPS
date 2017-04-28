//
//  dataRetro.swift
//  JPS
//
//  Created by Jerry U. on 4/19/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class dataRetro: NSObject {
    var no : Int
    var act : String
    var date : NSDate
    
    override init() {
        no = 0
        act = ""
        date = NSDate()
    }
    
    init(no: Int, act: String, date: NSDate) {
        self.no = no
        self.act = act
        self.date = date
    }
}
