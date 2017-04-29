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
    var date : Date
    
    override init() {
        no = 0
        act = ""
        date = Date()
    }
    
    init(no: Int, act: String, date: Date) {
        self.no = no
        self.act = act
        self.date = date
    }
}
