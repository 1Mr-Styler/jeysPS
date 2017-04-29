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
