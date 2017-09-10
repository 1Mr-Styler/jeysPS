//
//  WorkingClass.swift
//  JPS
//
//  Created by Jerry U. on 3/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import Alamofire

class WorkingClass: NSView, WYDoing {
    var timer = Timer()
    var startTime = TimeInterval()
    var isActive = false
    var StartedAt : Int = 0
    var StopAt : Int = 0
    var Ran : Int = 0
    var lastUpdated = 0
    var contents: NSString = ""
    
    
    var appDeli : AppDelegate!
    var MBVC: MenuBarVC!
    
    var displayTimeLabel: NSTextField!
    var lA: NSTextField!
    var button: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.lA = self.subviews[2] as! NSTextField
        self.button = self.subviews[3] as! NSButton
        self.displayTimeLabel = self.subviews[4] as! NSTextField
        
        self.button.target = self
        self.button.action = #selector(self.toggle(_:))
        
        self.appDeli = NSApplication.shared().delegate as! AppDelegate
        
    }
    
    func MBActivity(_ note: Notification) {
        let note = (note.userInfo as! [String: Any])
        let msg = note["V"] as! MB_Activity
        
        switch msg {
        case .Start:
            DispatchQueue.main.async {
                self.start()
            }
        case .Stop:
            if let _ = note["A"] as? String {
                self.stop(upload: false)
                let uH = userHandler()
                uH.couldntUpload(Savings(activity: "Working", lenght: String(self.Ran), start: String(self.StartedAt + 6)))
            } else {
                self.stop()
            }

        }
    }
    
    func toggle(_ sender: AnyObject) {
        if userHandler.activeClass.isEmpty {
            userHandler.activeClass = "Working"
        }
        
        if userHandler.activeClass != "Working" {
            userHandler.createAlert("Warning!", txt: "Stop previous activity before starting a new one")
            (sender as! NSButton).state = NSOffState
        } else {
            if !isActive {
                self.start()
            } else {
                self.stop()
            }
        }
    }
    
    func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0)
        
        elapsedTime -= (TimeInterval(hours) * 3600)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        displayTimeLabel.stringValue = "\(strHours):\(strMinutes):\(strSeconds)"
        self.isAlmost12()
    }
    
    func updateData() {
        
        Alamofire.request("http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=\(Ran)&ach=0&ts=\(StartedAt + 6)").responseString { (response) in
        
            if response.result.value == "done" {
                
                self.WYDupload()
                self.lA.objectValue = Date()
                // update menubar
                if userHandler().hasMenuBar {
                    let mbLa = self.appDeli.menubar?.popover.contentViewController?.view.subviews[1].subviews[3] as! NSTextField
                    mbLa.stringValue = self.lA.stringValue
                }
                self.Ran = 0
                
            } else {

                let uH = userHandler()
                uH.couldntUpload(Savings(activity: "Working", lenght: String(self.Ran), start: String(self.StartedAt + 6)))
                
                userHandler.createAlert("Server Unreachable", txt: "We're having issues uploading your data. Check your internet connection and try again by going to Preferences -> Upload")
            }
        }
        
    }
    
    func stop(upload: Bool = true) {
        userHandler.activeClass = ""
        StopAt = Int(Date().timeIntervalSince1970)
        timer.invalidate()
        isActive = false
        Ran = StopAt - StartedAt
        if upload {
            updateData()
        }
        self.button.state = NSOffState
    }
    
    func isAlmost12() {
        let form = DateFormatter()
        
        form.timeStyle = .medium
        form.dateStyle = .none
        
        let l = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        let theTimeIs = form.string(from: l) //"12:49:17 AM"
        
        if theTimeIs == "11:59:55 PM" {
            //Cuz its almost a new day, stop current activity and start new one
            self.stop()
            self.start()
        }
        
    }
    
    func start() {
        let aSelector : Selector = #selector(SleepHandler.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        StartedAt = Int(Date().timeIntervalSince1970)
        isActive = true
        button.state = NSOnState
    }

    func WYDupload() {
        Alamofire.request("http://jps.lyshnia.com/apr.php?api_hash=\(userHandler.cdc)&to=\(Ran)&from=\(StartedAt)&activity=working&wyd").responseString { (response)  in
            
        }
    }
    
    func WYDupload(cdc: String, from: Int, to: Int) throws {
        Alamofire.request("http://jps.lyshnia.com/apr.php?api_hash=\(cdc)&to=\(to)&from=\(from)&activity=working&wyd").responseString { (response) in
            
        }
    }
}
