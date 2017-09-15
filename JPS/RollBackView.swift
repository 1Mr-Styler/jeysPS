//
//  RollBackView.swift
//  JPS
//
//  Created by Jerry U. on 9/13/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

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
        
        if userHandler().isLoggedIn() {
            self.hideAll()
            //Gif laoder
            let loadingGif = self.subviews[10] as! NSImageView
            loadingGif.canDrawSubviewsIntoLayer = true
            loadingGif.imageScaling = .scaleProportionallyDown
            
            
            Alamofire.request("https://jps.lyshnia.com/api/roll.php?cdc=\(userHandler.cdc)&rollee").responseString { (response) in
                
                let contents = response.result.value
                let ldb = contents?.data(using: .utf8, allowLossyConversion: false)
                let jsond = JSON(data: ldb!)
                
                if jsond["status"] == 1 {
                    
                    self.prevActivity.isEnabled = false
                    self.prevActivity.selectItem(withTitle: jsond["activity"].stringValue.capitalized)
                    
                    
                    self.from_plain_picker.dateValue = Date.init(timeIntervalSince1970: TimeInterval(jsond["from"].intValue))
                    (self.subviews[5] as! NSDatePicker).dateValue = self.from_plain_picker.dateValue
                    
                    (self.subviews[8] as! NSDatePicker).dateValue = Date.init(timeIntervalSince1970: TimeInterval(jsond["to"].intValue))
                    self.to_plain_picker.dateValue = (self.subviews[8] as! NSDatePicker).dateValue
                    
                    self.unhideAll()
                } else {
                    for i in 0...12 {
                        self.subviews[i].isHidden = true
                    }
                    
                    self.subviews[13].isHidden = false
                }
                
            }
        } else {
            for i in 0...11 {
                self.subviews[i].isHidden = true
            }
            
            self.subviews[12].isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clock2(_:)), name: RollBack.NA_DateChange, object: nil)
    }
    
    private func hideAll() {
        for i in 0...9 {
            self.subviews[i].isHidden = true
        }
        self.subviews[10].isHidden = false
        self.subviews[11].isHidden = false
    }
    
    private func unhideAll() {
        self.subviews[10].isHidden = true
        self.subviews[11].isHidden = true
        for i in 0...9 {
            self.subviews[i].isHidden = false
        }
    }
    
    @IBOutlet var prevActivity: NSPopUpButton!
    @IBOutlet var to_plain_picker: NSDatePicker!
    @IBOutlet var from_plain_picker: NSDatePicker!
    
    
    @IBAction func clock(_ sender: NSDatePicker) {
        from_plain_picker.dateValue = sender.dateValue
    }
    
    
    @IBAction func clock2(_ sender: Any) {
        if let sendr = sender as? NSDatePicker {
            NotificationCenter.default.post(name: RollBack.RB_DateChange, object: nil, userInfo: ["V": sendr.dateValue])
            to_plain_picker.dateValue = sendr.dateValue
        } else {
            let note = sender as! Notification
            let noteInfo = (note.userInfo as! [String: Date])
            
            to_plain_picker.dateValue = noteInfo["V"]! - 1
            (self.subviews[8] as! NSDatePicker).dateValue = noteInfo["V"]! - 1
        }
    }
    
    @IBAction func toPicker(_ sender: NSDatePicker) {
        NotificationCenter.default.post(name: RollBack.RB_DateChange, object: nil, userInfo: ["V": sender.dateValue])
        (self.subviews[8] as! NSDatePicker).dateValue = sender.dateValue
    }
}
