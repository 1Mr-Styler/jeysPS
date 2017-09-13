//
//  RollBackView.swift
//  JPS
//
//  Created by Jerry U. on 9/13/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class RollBackView: NSView {

    static var prevActivityTo: Date = Date()
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        self.layer?.backgroundColor = NSColor(red: 236.0/255.0, green: 247.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor
        
        let vi = self.subviews[0]
        
        vi.layer?.backgroundColor = NSColor.white.cgColor
        vi.shadow = NSShadow()
        vi.layer?.shadowOpacity = 0.3
        vi.layer?.shadowRadius = 1.0
        vi.layer?.shadowOffset = CGSize(width: 4.0, height: -4.0)
        
        prevActivity.isEnabled = false
        prevActivity.selectItem(at: 3)
        
//        let mainView = self.subviews[1]
        
        from_plain_picker.dateValue = Date.init()
        (self.subviews[5] as! NSDatePicker).dateValue = Date.init()
        (self.subviews[8] as! NSDatePicker).dateValue = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 + 3600)
        (self.subviews[9] as! NSDatePicker).dateValue = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 + 3600)
        
        RollBackView.prevActivityTo = to_plain_picker.dateValue
    }
    
    @IBOutlet var prevActivity: NSPopUpButton!
    
    
    @IBOutlet var from_plain_picker: NSDatePicker!
    @IBAction func clock(_ sender: NSDatePicker) {
        Swift.print(sender.dateValue)
        from_plain_picker.dateValue = sender.dateValue
    }
    
    @IBOutlet var to_plain_picker: NSDatePicker!
    @IBAction func clock2(_ sender: NSDatePicker) {
        Swift.print(sender.dateValue)
        to_plain_picker.dateValue = sender.dateValue
    }
}
