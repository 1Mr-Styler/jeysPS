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

    var statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    var Juuv = Juveni()

    var detailView: JVc? {
        guard let myG = Juuv.childViewControllers[1] as? JVc else {
            return nil
        }
        return myG
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        self.window.titleVisibility = .hidden
        self.window.titlebarAppearsTransparent = true
        self.window.styleMask.insert(.fullSizeContentView)


        if uH.hasMenuBar {
            self.MenuBar()
        }

        self.window.backgroundColor = NSColor.init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1))

        self.window.contentViewController = Juuv
        self.window.orderFrontRegardless()

        detailView?.push(AcViewCon())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        // Cancel terminate if pref set
        if uH.hasMenuBar {
            self.window.close()
            NSApplication.shared().setActivationPolicy(NSApplicationActivationPolicy.accessory)
            return NSApplicationTerminateReply.terminateCancel
        } else {
            return NSApplicationTerminateReply.terminateNow
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillResignActive(_ notification: Notification) {
        if uH.hasMenuBar {
            self.window.orderOut(window)
        }
    }

    @IBAction func showPref(_ sender: AnyObject) {
        PrefPane.showWindow(self.window)
    }

    func toggleApp(_ sender: AnyObject) {
        if self.window!.isVisible {
            self.window.orderOut(window)
            NSApplication.shared().setActivationPolicy(NSApplicationActivationPolicy.accessory)

        } else {
            NSApplication.shared().setActivationPolicy(NSApplicationActivationPolicy.regular)
            self.window!.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func MenuBarRemove() {
        NSStatusBar.system().removeStatusItem(self.statusItem)
    }

    func MenuBar() {
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

        guard let button = self.statusItem.button else {
            exit(0)
        }

        button.image = NSImage(named: "StatusIcon")
        //        button.action = #selector(AppDelegate.toggleApp(_:))

        let OurMenu = NSMenu()
        let menuItem = NSMenuItem(title: "Show App", action: #selector(AppDelegate.toggleApp(_:)), keyEquivalent: "s")
        let menuItemQuit = NSMenuItem(title: "Quit JPS", action: #selector(AppDelegate.quitApp(_:)), keyEquivalent: "q")
        menuItem.target = self
        menuItemQuit.target = self
        OurMenu.addItem(menuItem)
        OurMenu.addItem(menuItemQuit)

        self.statusItem.menu = OurMenu
    }

    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard

        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }

    @IBAction func showAbout(_ sender: AnyObject) {
        About.showWindow(self.window)
    }

    func quitApp(_ sender: AnyObject) {
        exit(0)
    }
}


