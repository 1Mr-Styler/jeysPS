//
//  NewActivityView.swift
//  JPS
//
//  Created by Jerry U. on 9/13/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class NewActivityView: NSView {

    var clock: NSDatePicker!
    var clock2: NSDatePicker!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        self.layer?.backgroundColor = NSColor(red: 236.0/255.0, green: 247.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor
        
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
                    self.clock = (self.subviews[4] as! NSDatePicker)
                    self.clock2 = (self.subviews[7] as! NSDatePicker)
                    
                    self.new_from_plain_picker.dateValue = Date.init(timeIntervalSince1970: TimeInterval(jsond["from"].intValue))
                    self.clock.dateValue = self.new_from_plain_picker.dateValue
                    
                    self.clock2.dateValue = Date.init(timeIntervalSince1970: TimeInterval(jsond["to"].intValue))
                    self.new_to_plain_picker.dateValue = self.clock2.dateValue
                    
                    if !jsond["gma_pred"].stringValue.isEmpty {
                        self.newActivity.selectItem(withTitle: jsond["gma_pred"].stringValue)
                    }
                    
                    self.new_from_plain_picker.maxDate = self.new_to_plain_picker.dateValue
                    self.clock.maxDate = self.new_to_plain_picker.dateValue
                    
                    self.new_from_plain_picker.minDate = self.new_from_plain_picker.dateValue
                    self.clock.minDate = self.new_from_plain_picker.dateValue
                    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.new_clock(_:)), name: RollBack.RB_DateChange, object: nil)
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
    
    @IBOutlet var newActivity: NSPopUpButton!
    @IBOutlet var new_from_plain_picker: NSDatePicker!
    @IBOutlet var new_to_plain_picker: NSDatePicker!
    
    
    @IBAction func new_clock(_ sender: Any) {
        if let sendr = sender as? NSDatePicker {
            NotificationCenter.default.post(name: RollBack.NA_DateChange, object: nil, userInfo: ["V": sendr.dateValue])
            new_from_plain_picker.dateValue = sendr.dateValue
        } else {
            let note = sender as! Notification
            let noteInfo = (note.userInfo as! [String: Date])
            
            new_from_plain_picker.dateValue = noteInfo["V"]! + 1
            clock.dateValue = noteInfo["V"]! + 1
        }

    }
    
    @IBAction func new_clock2(_ sender: NSDatePicker) {
        new_to_plain_picker.dateValue = sender.dateValue
    }
    
    
    @IBAction func new_fromPicker(_ sender: NSDatePicker) {
        NotificationCenter.default.post(name: RollBack.NA_DateChange, object: nil, userInfo: ["V": sender.dateValue])
        clock.dateValue = sender.dateValue
    }
    @IBAction func new_toPicker(_ sender: NSDatePicker) {
        clock2.dateValue = sender.dateValue
    }
    
    @IBAction func roll(_ sender: NSButton) {
        sender.isEnabled = false
        hideAll()
        self.subviews[11].isHidden = true
        
        Alamofire.request("https://jps.lyshnia.com/api/roll.php?cdc=\(userHandler.cdc)&roll&activity=\((newActivity.selectedItem?.title)!)&from=\(Int(clock.dateValue.timeIntervalSince1970))").responseString { (response) in
            
            Swift.print(response.result.value ?? "ok")
            
            let contents = response.result.value
            let ldb = contents?.data(using: .utf8, allowLossyConversion: false)
            let jsond = JSON(data: ldb!)
            
            if jsond["status"] == 1 {
                (self.subviews[9] as! NSButton).image = NSImage(named: "check.png")
                (self.subviews[9] as! NSButton).title = "Success!"
            } else {
                (self.subviews[9] as! NSButton).image = NSImage(named: "x-check.png")
                (self.subviews[9] as! NSButton).title = "Failed!"
            }
            self.unhideAll()
        }
        
    }
}
