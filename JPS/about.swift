//
//  about.swift
//  JPS
//
//  Created by Jerry U. on 4/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class about: NSWindowController {

    var mainW = NSWindow()
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init(coder: NSCoder){
        super.init(coder: coder)!;
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.window!.backgroundColor = NSColor.white
//        self.window!.backgroundColor = NSColor(patternImage: NSImage(named: "bgAbout.png")!)
        
    }
    
    @IBAction func openLYS(_ sender: AnyObject) {
        if let url = URL(string: "http://www.lyshnia.com") {
            NSWorkspace.shared().open(url)
        }
    }
    
    @IBAction func openJPSweb(_ sender: AnyObject) {
        if let url = URL(string: "http://jps.lyshnia.com") {
            NSWorkspace.shared().open(url)
        }
    }
    
    
    func windowDidResignKey(_ notification: Notification) {
        self.window!.close()
    }
}
