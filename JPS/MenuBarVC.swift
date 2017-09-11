//
//  MenuBarVC.swift
//  Logga
//
//  Created by Jerry U. on 7/19/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MenuBarVC: NSViewController {

    let settingsMenu = NSMenu()
    let activitiesMenu = NSMenu()
    let appDeli = NSApplication.shared().delegate as! AppDelegate
    let uH = userHandler()
    var mbdtails: JSON?
    var MBaH: MBActivityHandler!
    
    // MARK - Outlets for Main Texts
    @IBOutlet var jps: NSTextField!
    @IBOutlet var rank: NSTextField!
    @IBOutlet var info: NSTextField!
    @IBOutlet var lastUpdated: NSTextField!
    @IBOutlet var titleActivity: NSTextField!
    
    
    // MARK - Outlets for Activities
    @IBOutlet var mainTitle: NSTextField!
    @IBOutlet var currently: NSTextField!
    @IBOutlet var currentActivity: NSTextField!
    @IBOutlet var prevActivity: NSTextField!
    
    
    // MARK - Timer stuff
    var timer = Timer()
    var startTime = TimeInterval()
    var isActive = false
    var StartedAt : Int = 0
    var StopAt : Int = 0
    var Ran : Int = 0
    var contents: NSString = ""
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //Gif laoder
        let loadingGif = self.view.subviews[4] as! NSImageView
        loadingGif.canDrawSubviewsIntoLayer = true
        loadingGif.imageScaling = .scaleProportionallyDown
        
        self.settingsMenu.addItem(NSMenuItem(title: "Preferences", action: #selector(self.appDeli.showPref(_:)), keyEquivalent: ","))
        self.settingsMenu.addItem(NSMenuItem.separator())
        self.settingsMenu.addItem(NSMenuItem(title: "About JPS", action: #selector(self.showAbout(_:)), keyEquivalent: ""))
        self.settingsMenu.addItem(NSMenuItem.separator())
        self.settingsMenu.addItem(NSMenuItem(title: "Quit JPS", action: #selector(self.quitApp(_:)), keyEquivalent: "q"))
        
        let titleBarView = self.view.subviews[0]
        self.view.layer?.backgroundColor = NSColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        
        titleBarView.layer?.backgroundColor = NSColor(red: 114.0/255.0, green: 114.0/255.0, blue: 113.0/255.0, alpha: 1.0).cgColor
        
        // Activities stuff
        let actvWrking = NSMenuItem(title: "Working", action: #selector(self.activityLoad(_:)), keyEquivalent: "w")
        self.activitiesMenu.addItem(NSMenuItem(title: "Sleeping", action: #selector(self.activityLoad(_:)), keyEquivalent: "s"))
        self.activitiesMenu.addItem(actvWrking)
        self.activitiesMenu.addItem(NSMenuItem(title: "Inactive", action: #selector(self.activityLoad(_:)), keyEquivalent: "i"))
        self.activitiesMenu.addItem(NSMenuItem(title: "Studying", action: #selector(self.activityLoad(_:)), keyEquivalent: "r"))
        
        (self.view.subviews[3] as! MBmainView).loadData()
        self.activityLoad(actvWrking)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forWork(_:)), name: .MB_ACTIVITY_WORKING, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forWork(_:)), name: .MB_ACTIVITY_SLEEPING, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forWork(_:)), name: .MB_ACTIVITY_INACTIVE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forWork(_:)), name: .MB_ACTIVITY_STUDYING, object: nil)
        
    }
    
    func forWork(_ note: Notification) {
        let noteInfo = (note.userInfo as! [String: Any])
        
        if noteInfo.keys.contains("FMB") {
            let msg = noteInfo["V"] as! MB_Activity
            let btn =  self.view.subviews[2].subviews[5] as! NSButton
            
            if self.currentActivity.stringValue != "Nothing"
            {self.prevActivity.stringValue = self.currentActivity.stringValue}
            
            /** Load the activity */
            MBaH.load()
            self.mainTitle.stringValue = noteInfo["ACT"] as! String
            self.currently.stringValue = MBaH.toHMS(seconds: MBaH.current)
            
            self.view.subviews[2].subviews[0].isHidden = false
            self.view.subviews[2].subviews[6].isHidden = true
            btn.isEnabled = true
            
            /** Load the activity */
            
            
            switch msg {
            case .Start:
                btn.state = NSOnState
                self.start()
                self.currentActivity.stringValue = noteInfo["ACT"] as! String
            case .Stop:
                btn.state = NSOffState
                self.stop()
                self.currentActivity.stringValue = "Nothing"
            }
        }
    }
    
    @IBAction func settngs(_ sender: Any) {
        let p = NSPoint(x: (sender as AnyObject).frame.origin.x, y: (sender as AnyObject).frame.origin.y - ((sender as AnyObject).frame.height / 2))
        self.settingsMenu.popUp(positioning: nil, at: p, in: (sender as AnyObject).superview)
    }
    
    @IBAction func showActivityMenu(_ sender: Any) {
        
        let event = NSApp.currentEvent!
        
        guard event.type == NSEventType.leftMouseUp else {
            print("got you")
            return
        }
        
        
        let p = NSPoint(x: (sender as AnyObject).frame.origin.x, y: (sender as AnyObject).frame.origin.y - ((sender as AnyObject).frame.height / 2))
        self.activitiesMenu.popUp(positioning: nil, at: p, in: (sender as AnyObject).superview)
    }
    
    func quitApp(_ sender: AnyObject) {
        appDeli.menubar?.statusItem.isEnabled = false
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func toggleJPS(_ sender: Any) {
        appDeli.toggleApp(sender as AnyObject)
        
    }
    
    func showAbout(_ sender: AnyObject) {
        self.appDeli.showAbout(sender)
    }
    
    func loadData() {
        if uH.isLoggedIn() {
            if let url = URL(string: "https://jps.lyshnia.com/api/menubar.php?cdc=\(userHandler.cdc)") {
                do {
                    let contents = try String.init(contentsOf: url)
                    let ldb = contents.data(using: .utf8, allowLossyConversion: false)
                    mbdtails = JSON(data: ldb!)
                } catch {
                    // contents could not be loaded
                    print("// contents could not be loaded")
                }
            } else {
                print("Something isnt right")
            }
        }

    }
    
    @IBAction func toggleActivity(_ sender: Any) {
        let me = (sender as! NSButton)
        
        if self.currentActivity.stringValue != "Nothing"
        {self.prevActivity.stringValue = self.currentActivity.stringValue}
        
        if me.state == NSOnState {
            self.currentActivity.stringValue = self.mainTitle.stringValue
            self.start()
            
            switch self.currentActivity.stringValue {
            case "Sleeping":
                NotificationCenter.default.post(name: .MB_ACTIVITY_SLEEPING, object: nil, userInfo: ["V": MB_Activity.Start])
            case "Working":
                NotificationCenter.default.post(name: .MB_ACTIVITY_WORKING, object: nil, userInfo: ["V": MB_Activity.Start])
            case "Studying":
                NotificationCenter.default.post(name: .MB_ACTIVITY_STUDYING, object: nil, userInfo: ["V": MB_Activity.Start])
            default:
                NotificationCenter.default.post(name: .MB_ACTIVITY_INACTIVE, object: nil, userInfo: ["V": MB_Activity.Start])
            }
            
        } else {
            switch self.currentActivity.stringValue {
            case "Sleeping":
                NotificationCenter.default.post(name: .MB_ACTIVITY_SLEEPING, object: nil, userInfo: ["V": MB_Activity.Stop])
            case "Working":
                NotificationCenter.default.post(name: .MB_ACTIVITY_WORKING, object: nil, userInfo: ["V": MB_Activity.Stop])
            case "Studying":
                NotificationCenter.default.post(name: .MB_ACTIVITY_STUDYING, object: nil, userInfo: ["V": MB_Activity.Stop])
            default:
                NotificationCenter.default.post(name: .MB_ACTIVITY_INACTIVE, object: nil, userInfo: ["V": MB_Activity.Stop])
            }
            
            self.currentActivity.stringValue = "Nothing"
            self.stop()
            MBaH.current = self.Ran
            MBaH.save()
        }
    }
    
    func activityLoad(_ sender: Any) {
        
        let SL = TableController.SELECTED_ROW(rawValue: 5)
        switch (sender as! NSMenuItem).title {
        case "Working":
            NotificationCenter.default.post(name: .CS_TABLE_SELECTION_CHG, object: nil, userInfo: ["TXT": SL!, "MB_INFO": "Working"])
            self.MBaH = MBActivityHandler(currently: .WORKING)
        case "Sleeping":
            NotificationCenter.default.post(name: .CS_TABLE_SELECTION_CHG, object: nil, userInfo: ["TXT": SL!, "MB_INFO": "Sleeping"])
            self.MBaH = MBActivityHandler(currently: .SLEEPING)
        case "Studying":
            NotificationCenter.default.post(name: .CS_TABLE_SELECTION_CHG, object: nil, userInfo: ["TXT": SL!, "MB_INFO": "Studying"])
            self.MBaH = MBActivityHandler(currently: .STUDYING)
        default:
            NotificationCenter.default.post(name: .CS_TABLE_SELECTION_CHG, object: nil, userInfo: ["TXT": SL!, "MB_INFO": "Inactive"])
            self.MBaH = MBActivityHandler(currently: .INACTIVE)
        }
        
        MBaH.load()
        self.mainTitle.stringValue = (sender as! NSMenuItem).title
        self.currently.stringValue = MBaH.toHMS(seconds: MBaH.current)
        
        if self.currentActivity.stringValue != "Nothing" {
            if (sender as! NSMenuItem).title != userHandler.activeClass {
                self.view.subviews[2].subviews[0].isHidden = true
                self.view.subviews[2].subviews[6].isHidden = false
                (self.view.subviews[2].subviews[6] as! NSTextField).stringValue = MBaH.description
                (self.view.subviews[2].subviews[5] as! NSButton).isEnabled = false
            } else {
                self.view.subviews[2].subviews[0].isHidden = false
                self.view.subviews[2].subviews[6].isHidden = true
                (self.view.subviews[2].subviews[5] as! NSButton).isEnabled = true
            }
        } else {
            self.view.subviews[2].subviews[0].isHidden = false
            self.view.subviews[2].subviews[6].isHidden = true
            (self.view.subviews[2].subviews[5] as! NSButton).isEnabled = true
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
        
        currently.stringValue = "\(strHours):\(strMinutes):\(strSeconds)"
        self.isAlmost12()
    }
    
    func stop() {
        userHandler.activeClass = ""
        StopAt = Int(Date().timeIntervalSince1970)
        timer.invalidate()
        isActive = false
        Ran = StopAt - StartedAt
//        updateData()
        
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
        userHandler.activeClass = self.mainTitle.stringValue
        let aSelector : Selector = #selector(self.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        StartedAt = Int(Date().timeIntervalSince1970)
        isActive = true
    }
}

extension Notification.Name {
    static let MB_MA_ACTIVITY_CHG = Notification.Name("mbMaActChange")
}
