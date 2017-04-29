//
//  WorkingClass.swift
//  JPS
//
//  Created by Jerry U. on 3/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class WorkingClass: NSObject {
    var timer = Timer()
    var startTime = TimeInterval()
    var isActive = false
    var StartedAt : Int = 0
    var StopAt : Int = 0
    var Ran : Int = 0
    var lastUpdated = 0
    var contents: NSString = ""
    
    
    @IBOutlet weak var displayTimeLabel: NSTextField!
    @IBOutlet weak var lA: NSTextField!
    
    @IBAction func toggleWork(_ sender: AnyObject) {
        if userHandler.activeClass.isEmpty {
            userHandler.activeClass = "WorkingClass"
        }
        
        if userHandler.activeClass != "WorkingClass" {
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
        if let url = URL(string: "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=\(Ran)&ach=0") {
            do {
                contents = try NSString(contentsOf: url, usedEncoding: nil)
                lA.objectValue = Date()
                Ran = 0
                print(contents)
            } catch {
                // contents could not be loaded
                let uH = userHandler()
                uH.couldntUpload(Savings(activity: "Working", lenght: String(Ran), start: String(StartedAt)))
                print("// contents could not be loaded")
                userHandler.createAlert("Server Unreachable", txt: "We're having issues uploading your data. Check your internet connection and try again by going to Preferences -> Upload")
            }
        } else {
            print("Something isnt right")
        }
    }
    
    func stop() {
        userHandler.activeClass = ""
        StopAt = Int(Date().timeIntervalSince1970)
        timer.invalidate()
        isActive = false
        Ran = StopAt - StartedAt
        updateData()
        print("Timer ran for \(Ran) seconds")
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
    }

}
