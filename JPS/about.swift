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
        
        self.window!.backgroundColor = NSColor.whiteColor()
//        self.window!.backgroundColor = NSColor(patternImage: NSImage(named: "bgAbout.png")!)
        
    }
    
    @IBAction func openLYS(sender: AnyObject) {
        if let url = NSURL(string: "http://www.lyshnia.com") {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }
    
    @IBAction func openJPSweb(sender: AnyObject) {
        if let url = NSURL(string: "http://jps.lyshnia.com") {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }
    
    
    func windowDidResignKey(notification: NSNotification) {
        self.window!.close()
    }
}
