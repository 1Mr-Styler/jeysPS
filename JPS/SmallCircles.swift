//
//  SmallCircles.swift
//  JPS
//
//  Created by Jerry U. on 9/28/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class SmallCircles: NSView {

    override func draw(_ dirtyRect: NSRect) {
        self.layer?.cornerRadius = 50
        self.layer?.backgroundColor = NSColor.black.cgColor
        super.draw(dirtyRect)
        // Drawing code here.
        
        
    }
    
}
