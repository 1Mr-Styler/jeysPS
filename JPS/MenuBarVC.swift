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
    
    // MARK - Outlets for Main Texts
    @IBOutlet var jps: NSTextField!
    @IBOutlet var rank: NSTextField!
    @IBOutlet var info: NSTextField!
    @IBOutlet var lastUpdated: NSTextField!
    @IBOutlet var titleActivity: NSTextField!
    
    
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
        
        let loadingGif = self.view.subviews[5] as! NSImageView
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
        self.activitiesMenu.addItem(NSMenuItem(title: "Sleeping", action: #selector(self.quitApp(_:)), keyEquivalent: "s"))
        self.activitiesMenu.addItem(NSMenuItem(title: "Working", action: #selector(self.quitApp(_:)), keyEquivalent: "w"))
        self.activitiesMenu.addItem(NSMenuItem(title: "Inactive", action: #selector(self.quitApp(_:)), keyEquivalent: "i"))
        self.activitiesMenu.addItem(NSMenuItem(title: "Studying", action: #selector(self.quitApp(_:)), keyEquivalent: "r"))
        
        if uH.isLoggedIn() {
            self.jps.stringValue = String(format: "%0.2f%%", (mbdtails?["jps"].floatValue)!)
            self.rank.stringValue = (mbdtails?["rank"].string!)!
            self.info.stringValue = {() -> String  in
                if (mbdtails?["diff"].floatValue)! >= 0 {
                    return "(Thats a \((mbdtails?["diff"].floatValue)!)% increase from yesterday)"
                } else {
                    return "(Thats a \(abs((mbdtails?["diff"].floatValue)!))% decrease from yesterday)"
                }
                
            }()
        } else {
            jps.stringValue = "N/A"
            rank.stringValue = "N/A"
            info.stringValue = "(You need to be logged in to view this)"
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
        exit(0)
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
}
