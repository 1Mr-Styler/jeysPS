//
//  ViewController.swift
//  JPS
//
//  Created by Jerry U. on 4/7/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import ServiceManagement

class ViewController: NSViewController {

    @IBOutlet var enableMenu: NSButton!
    @IBOutlet var inactiveGuy: Inactive!
    @IBOutlet var sleepGuy: SleepHandler!
    @IBOutlet var studyingGuy: Studying!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if self.nibName == "General" {
            enableMenu.state = UserDefaults.standard.integer(forKey: "showMB")
        }
        
        let sidebarNibs: [String] = ["leaderboard", "TopWeek", "TopMonth"]
        if sidebarNibs.contains(self.nibName!)  {
            //Gif laoder         
            let loadingGif = self.view.subviews[2] as! NSImageView
            loadingGif.canDrawSubviewsIntoLayer = true
            loadingGif.imageScaling = .scaleProportionallyDown
        }
        
        let activityNibs: [String] = ["Working", "Inactive", "Sleeping", "Studying", "RollBack"]
        
        if activityNibs.contains(self.nibName!) {
            let vi = self.view.subviews[0]
            
            vi.layer?.backgroundColor = NSColor.white.cgColor
            vi.shadow = NSShadow()
            vi.layer?.shadowOpacity = 0.3
            vi.layer?.shadowRadius = 1.0
            vi.layer?.shadowOffset = CGSize(width: 4.0, height: -4.0)
            
            
            switch self.nibName! {
            case "Sleeping":
                NotificationCenter.default.addObserver(self, selector: #selector(self.forSleep(_:)), name: .MB_ACTIVITY_SLEEPING, object: nil)
            case "Working":
                NotificationCenter.default.addObserver(self, selector: #selector(self.forWork(_:)), name: .MB_ACTIVITY_WORKING, object: nil)
            case "Studying":
                NotificationCenter.default.addObserver(self, selector: #selector(self.forStudy(_:)), name: .MB_ACTIVITY_STUDYING, object: nil)
            default:
                NotificationCenter.default.addObserver(self, selector: #selector(self.forInactive(_:)), name: .MB_ACTIVITY_INACTIVE, object: nil)
            }
            
        }
        
    }
    
    @IBAction func enableMenuBar(_ sender: AnyObject) {
        let appDeli = NSApplication.shared().delegate as! AppDelegate
        
        if enableMenu.state == NSOnState {
            appDeli.menubar = MenuBar()
            appDeli.menubar?.setUp()
            UserDefaults.standard.set(1, forKey: "showMB")
        } else {
            appDeli.menubar?.remove()
            UserDefaults.standard.set(0, forKey: "showMB")
        }
    }
    
    func forWork(_ note: Notification) {
        let noteInfo = (note.userInfo as! [String: Any])
        
        if !noteInfo.keys.contains("FMB") {
            let workingClass = self.view as! WorkingClass
            workingClass.MBActivity(note)
        }
    }
    
    func forSleep(_ note: Notification) {
        let noteInfo = (note.userInfo as! [String: Any])
        
        if !noteInfo.keys.contains("FMB") {
            let sleeper = self.view as! SleepHandler
            sleeper.MBActivity(note)
        }
    }
    
    func forStudy(_ note: Notification) {
        let noteInfo = (note.userInfo as! [String: Any])
        
        if !noteInfo.keys.contains("FMB") {
            let study = self.view as! Studying
            study.MBActivity(note)
        }
    }
    
    func forInactive(_ note: Notification) {
        let noteInfo = (note.userInfo as! [String: Any])
        
        if !noteInfo.keys.contains("FMB") {
            let inactive = self.view as! Inactive
            inactive.MBActivity(note)
        }
    }
    
    @IBOutlet var launchAtLoginCheckbox: NSButton!
    
    @IBAction func launchAtLogin(_ sender: NSButton) {
        let appBundleIdentifier = "com.lyshnia.JPSHelper"
        let autoLaunch = (launchAtLoginCheckbox.state == NSOnState)
        if SMLoginItemSetEnabled(appBundleIdentifier as CFString, autoLaunch) {
            if autoLaunch {
                NSLog("Successfully add login item.")
            } else {
                NSLog("Successfully remove login item.")
            }
            
        } else {
            NSLog("Failed to add login item.")
        }
    }
    
}

struct Savings {
    var activity : String
    var lenght : String
    var start : String
}
