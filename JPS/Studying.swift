//
//  Studying.swift
//  JPS
//
//  Created by Jerry U. on 3/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Studying: NSObject {
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var isActive = false
    var StartedAt : Int = 0
    var StopAt : Int = 0
    var Ran : Int = 0
    var lastUpdated = 0
    var contents: NSString = ""
    
    
    @IBOutlet weak var displayTimeLabel: NSTextField!
    @IBOutlet weak var lA: NSTextField!
    
    @IBAction func toggleStudy(sender: AnyObject) {
        if userHandler.activeClass.isEmpty {
            userHandler.activeClass = "Studying"
        }
        
        if userHandler.activeClass != "Studying" {
            userHandler.createAlert("Warning!", txt: "Stop previous activity before starting a new one")
        } else {
            if !isActive {
                self.start()
            } else {
                self.stop()
            }
        }
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0)
        
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
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
        if let url = NSURL(string: "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=\(Ran)&wh=0&ach=0") {
            do {
                contents = try NSString(contentsOfURL: url, usedEncoding: nil)
                lA.objectValue = NSDate()
                Ran = 0
                print(contents)
            } catch {
                // contents could not be loaded
                let uH = userHandler()
                uH.couldntUpload(Savings(activity: "Studying", lenght: String(Ran), start: String(StartedAt)))
                print("// contents could not be loaded")
                userHandler.createAlert("Server Unreachable", txt: "We're having issues uploading your data. Check your internet connection and try again by going to Preferences -> Upload")
            }
        } else {
            print("Something isnt right")
        }
    }
    
    func stop() {
        userHandler.activeClass = ""
        StopAt = Int(NSDate().timeIntervalSince1970)
        timer.invalidate()
        isActive = false
        Ran = StopAt - StartedAt
        updateData()
        print("Timer ran for \(Ran) seconds")
    }
    
    func isAlmost12() {
        let form = NSDateFormatter()
        
        form.timeStyle = .MediumStyle
        form.dateStyle = .NoStyle
        
        let l = NSDate.init(timeIntervalSince1970: NSDate().timeIntervalSince1970)
        
        let theTimeIs = form.stringFromDate(l) //"12:49:17 AM"
        
        if theTimeIs == "11:59:55 PM" {
            //Cuz its almost a new day, stop current activity and start new one
            self.stop()
            self.start()
        }
        
    }
    
    func start() {
        let aSelector : Selector = #selector(SleepHandler.updateTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        StartedAt = Int(NSDate().timeIntervalSince1970)
        isActive = true
    }

}
