//
//  ViewController.swift
//  JPS
//
//  Created by Jerry U. on 4/7/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var enableMenu: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if self.nibName == "General" {
            enableMenu.state = UserDefaults.standard.integer(forKey: "showMB")
        }
        
        let activityNibs: [String] = ["Working", "Inactive", "Sleeping", "Studying"]
        
        if activityNibs.contains(self.nibName!) {
            let vi = self.view.subviews[0]
            
            vi.layer?.backgroundColor = NSColor.white.cgColor
            vi.shadow = NSShadow()
            vi.layer?.shadowOpacity = 0.3
            vi.layer?.shadowRadius = 1.0
            vi.layer?.shadowOffset = CGSize(width: 4.0, height: -4.0)
        }
    }
    
    @IBAction func enableMenuBar(_ sender: AnyObject) {
        let appDeli = NSApplication.shared().delegate as! AppDelegate
        
        if enableMenu.state == NSOnState {
            appDeli.MenuBar()
            UserDefaults.standard.set(1, forKey: "showMB")
        } else {
            appDeli.MenuBarRemove()
            UserDefaults.standard.set(0, forKey: "showMB")
        }
    }
    
    
}

struct Savings {
    var activity : String
    var lenght : String
    var start : String
}
