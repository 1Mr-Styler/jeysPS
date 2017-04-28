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
            enableMenu.state = NSUserDefaults.standardUserDefaults().integerForKey("showMB")
        }
    }
    
    @IBAction func enableMenuBar(sender: AnyObject) {
        let appDeli = NSApplication.sharedApplication().delegate as! AppDelegate
        
        if enableMenu.state == NSOnState {
            appDeli.MenuBar()
            NSUserDefaults.standardUserDefaults().setObject(1, forKey: "showMB")
        } else {
            appDeli.MenuBarRemove()
            NSUserDefaults.standardUserDefaults().setObject(0, forKey: "showMB")
        }
    }
    
    
}

struct Savings {
    var activity : String
    var lenght : String
    var start : String
}