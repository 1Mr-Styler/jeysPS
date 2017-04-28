//
//  Pref.swift
//  JPS
//
//  Created by Jerry U. on 3/30/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Pref: NSWindowController {
    
    var mainW: NSWindow = NSWindow()
    @IBOutlet var loginWindow: NSWindow!
    

    @IBOutlet var mainView: NSView!
    @IBOutlet var tabBar: NSToolbar!
    
    @IBOutlet weak var loggedInAs: NSTextField!
    @IBOutlet weak var since: NSTextField!
    
    let uH = userHandler();
    
    let loginView = ViewController(nibName: "LogOut", bundle: nil)!
    let updView = ViewController(nibName: "Updates", bundle: nil)
    let uloView = ViewController(nibName: "Upload", bundle: nil)
    let genView = ViewController(nibName: "General", bundle: nil)
    
    var username = "Not Logged In" //To display if user is logged in
    var loginDate = NSDate()
    
    var unsaved: [dataRetro] = []
    
    var activeSub : NSView!
    
    @IBOutlet weak var label: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.resize(.Account)
        
        self.mainView.addSubview((genView!.view))
        activeSub = (genView!.view)
        
        if !uH.isLoggedIn() {
            //loginView.view.layer?.backgroundColor = NSColor(patternImage: NSImage(named: "collec.png")!).CGColor
            
            self.window!.beginSheet(loginWindow, completionHandler: nil)
            
        }
        
    }
    
    override init(window: NSWindow!) {
        if uH.isLoggedIn() {
            self.username = NSUserDefaults.standardUserDefaults().stringForKey("username")!
            self.loginDate = NSDate.init(timeIntervalSince1970: NSUserDefaults.standardUserDefaults().doubleForKey("loginDate"))
        }
        
        super.init(window: window)
        //Initialization code here.

        /*********************** Stuff for unsaved data *******************/
        
        
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = NSUserDefaults.standardUserDefaults()
            var cObj : [String]
            for i in 0..<keys.count {
                cObj = OBJ.objectForKey(keys[i]) as! [String]
                unsaved.append(
                    dataRetro(no: i+1, act: cObj[0], date: NSDate.init(timeIntervalSince1970: Double(cObj[2])!)
                    )
                )
            }
        }
        
        /*********************** Stuff for unsaved data *******************/
 /**/
    }
    
    required init(coder: NSCoder){
        super.init(coder: coder)!;
    }

    @IBAction func accMenu(sender: AnyObject) {
        self.mainView.replaceSubview(activeSub, with: loginView.view)
        self.resize(ResizeGuy.Account)
        activeSub = loginView.view
        
        if !uH.isLoggedIn() {
            self.window!.beginSheet(loginWindow, completionHandler: nil)
        }
    }
    
    @IBAction func uploadMenu(sender: AnyObject) {
        self.mainView.addSubview((uloView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (uloView?.view)!)
        self.resize(ResizeGuy.Update)
        activeSub = (uloView?.view)!
    }
    
    @IBAction func updateMenu(sender: AnyObject) {
        self.mainView.addSubview((updView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (updView?.view)!)
        self.resize(ResizeGuy.Update)
        activeSub = (updView?.view)!
    }
    
    @IBAction func generalMenu(sender: AnyObject) {
        self.mainView.addSubview((genView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (genView?.view)!)
        self.resize(ResizeGuy.General)
        activeSub = (genView?.view)!
    }
    
    
    @IBAction func help(sender: AnyObject) {
        label.stringValue = "I said no updates available!"
    }
    
    @IBAction func retryUpload(sender: AnyObject) {
        
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = NSUserDefaults.standardUserDefaults()
            var cObj : [String]
            for i in 0..<keys.count {
                cObj = OBJ.objectForKey(keys[i]) as! [String]
                var uRL : String
                
                switch cObj[0] {
                case "Sleeping":
                    uRL = "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=\(cObj[1])&ih=0&ph=0&wh=0&ach=0"
                case "Working":
                    uRL = "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=\(cObj[1])&ach=0"
                case "Inactive":
                    uRL = "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=\(cObj[1])&ph=0&wh=0&ach=0"
                case "Studying":
                    uRL = "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=\(cObj[1])&wh=0&ach=0"
                default:
                    uRL = ""
                    break
                }
                
                if let url = NSURL(string: uRL) {
                    do {
                        _ = try NSString(contentsOfURL: url, usedEncoding: nil)
                        OBJ.removeObjectForKey(keys[i])
                        
                        userHandler.createAlert("Successfully Uploaded", txt: "Activity: \(cObj[0]) at \(NSDate.init(timeIntervalSince1970: Double(cObj[2])!))")
                        uH.arrayOfKeys("popKorn \(keys[i])")
                    } catch {
                        // contents could not be loaded
                       
                    }
                } else {
                    print("Something isnt right")
                }
            }
        }
    }
    
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var passWord: NSSecureTextField!
    
    @IBAction func login(sender: AnyObject) {
        
        if userName.stringValue.isEmpty || passWord.stringValue.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Both fields are required!"
            alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
            
        } else {
            let tryLogin = uH.login(userName.stringValue, pass: passWord.stringValue)
            let alert = NSAlert()
            
            switch tryLogin {
            case .LoggedIn:
//                self.loggedInAs.stringValue = userName.stringValue
                self.window!.endSheet(sender.window)
                sender.window.orderOut(self.window!)
            case .ServerUnreachable:
                alert.messageText = "Server Unreachable. Check your internet connection and try again."
                alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
            case .Incorrect:
                alert.messageText = "Incorrect Login. Check your login details and try again."
                alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
            }
        }
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        if userName.stringValue.isEmpty || passWord.stringValue.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Both fields are required!"
            alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
        } else {
            let tryLogin = uH.createAccount(userName.stringValue, pass: passWord.stringValue)
            let alert = NSAlert()
            
            switch tryLogin {
            case .LoggedIn:
//                self.loggedInAs.stringValue = userName.stringValue
                self.window!.endSheet(sender.window)
                sender.window.orderOut(self.window!)
            case .ServerUnreachable:
                alert.messageText = "Server Unreachable. Check your internet connection and try again."
                alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
            case .Incorrect:
                alert.messageText = "Incorrect Login. Check your login details and try again."
                alert.beginSheetModalForWindow((sender.superview!!.window!), completionHandler: nil)
            }
        }
    }
    
    @IBAction func closePref(sender: AnyObject) {
        self.window!.endSheet(sender.window)
        sender.window.orderOut(self.window!)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        if uH.isLoggedIn() {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("loginDate")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("cdc")
            
            
        }
    }
    
    
    func resize(who: ResizeGuy) {
        let windowFrame = window!.frame
        let oldWidth = windowFrame.size.width
        
        var toAdd : CGFloat
        
        switch who {
        case .Account:
            toAdd = CGFloat(272.0)
        case .Update:
            toAdd = CGFloat(416.0)
        case .Upload:
            toAdd = CGFloat(416.0)
        case .General:
            toAdd = CGFloat(272.0)
        }
        
        let contentRect = NSRect(x: 0, y: 0, width: oldWidth, height: toAdd)
        let contentFrame = mainView.window!.frameRectForContentRect(contentRect)
        let toolbarHeight = windowFrame.size.height - contentFrame.size.height
        let newOrigin = NSPoint(x: windowFrame.origin.x, y: windowFrame.origin.y + toolbarHeight)
        let newFrame = NSRect(origin: newOrigin, size: contentFrame.size)
        window!.setFrame(newFrame, display: false, animate: true)
    }
}

enum LoginGuy {
    case LoggedIn
    case Incorrect
    case ServerUnreachable
}

enum ResizeGuy {
    case Account
    case Upload
    case Update
    case General
}
