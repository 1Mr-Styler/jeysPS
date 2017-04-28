//
//  AppDelegate.swift
//  JPS
//
//  Created by Jerry U. on 3/23/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var mainTabView: NSTabView!
    var PrefPane = Pref(windowNibName: "Pref")
    let About = about(windowNibName: "about")
    var uH = userHandler()
    
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("showMB")
        if uH.hasMenuBar {
            self.MenuBar()
        }
        
        self.window.backgroundColor = NSColor.init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1))
//        mainTabView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        mainTabView.tabViewItems
        for i in  1..<mainTabView.tabViewItems.count {
//            mainTabView.subviews[i].layer?.backgroundColor = NSColor.whiteColor().CGColor
            mainTabView.tabViewItems[i].view!.layer?.backgroundColor = NSColor.whiteColor().CGColor
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        // Cancel terminate if pref set
        if uH.hasMenuBar {
            self.window.close()
            NSApplication.sharedApplication().setActivationPolicy(NSApplicationActivationPolicy.Accessory)
            return NSApplicationTerminateReply.TerminateCancel
        } else {
            return NSApplicationTerminateReply.TerminateNow
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        if uH.hasMenuBar {
            self.window.orderOut(window)
        }
    }
    
    @IBAction func showPref(sender: AnyObject) {
        PrefPane.showWindow(self.window)
    }
    
    func toggleApp(sender: AnyObject) {
        if self.window!.visible {
            self.window.orderOut(window)
            NSApplication.sharedApplication().setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        
        } else {
            NSApplication.sharedApplication().setActivationPolicy(NSApplicationActivationPolicy.Regular)
            self.window!.makeKeyAndOrderFront(nil)
            NSApp.activateIgnoringOtherApps(true)
        }
    }
    
    func MenuBarRemove() {
        NSStatusBar.systemStatusBar().removeStatusItem(self.statusItem)
    }
    
    func MenuBar() {
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
        
        guard let button = self.statusItem.button else { exit(0) }
        
        button.image = NSImage(named: "StatusIcon")
        //        button.action = #selector(AppDelegate.toggleApp(_:))
        
        let OurMenu = NSMenu()
        let menuItem = NSMenuItem(title: "Show App", action: #selector(AppDelegate.toggleApp(_:)), keyEquivalent: "s")
        menuItem.target = self
        OurMenu.addItem(menuItem)
        
        self.statusItem.menu = OurMenu
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    @IBAction func showAbout(sender: AnyObject) {
        About.showWindow(self.window)
    }
    
}


