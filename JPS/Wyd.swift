//
//  Wyd.swift
//  JPS
//
//  Created by Jerry U. on 7/4/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Wyd: NSObject {
    
    init(activity: String) throws {
        
    }
    
}


protocol WYDoing {
    func WYDupload(cdc: String, from: Int, to: Int) throws
    func WYDupload() throws
}

enum JPSServer: Error {
    case UNREACHABLE
}

enum WYDError: Error {
    case NO_CONFORM
}
