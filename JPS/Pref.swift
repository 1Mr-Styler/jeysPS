//
//  Pref.swift
//  JPS
//
//  Created by Jerry U. on 3/30/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import Alamofire

class Pref: NSWindowController {
    
    var mainW: NSWindow = NSWindow()
    @IBOutlet var loginWindow: NSWindow!
    

    @IBOutlet var mainView: NSView!
    @IBOutlet var tabBar: NSToolbar!
    
    @IBOutlet weak var loggedInAs: NSTextField!
    @IBOutlet weak var since: NSTextField!
    
    @IBOutlet weak var ArrayController: NSArrayController!
    
    let uH = userHandler();
    
    let loginView = ViewController(nibName: "LogOut", bundle: nil)!
    let updView = ViewController(nibName: "Updates", bundle: nil)
    let uloView = ViewController(nibName: "Upload", bundle: nil)
    let genView = ViewController(nibName: "General", bundle: nil)
    
    var username = "Not Logged In"
    
    var loginDate = Date()
    var unsaved: [dataRetro] = []
    var activeSub : NSView!
    
    @IBOutlet weak var label: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
            self.resize(.account)
            
            self.mainView.addSubview((genView!.view))
            activeSub = (genView!.view)
            
            if !uH.isLoggedIn() {
                //loginView.view.layer?.backgroundColor = NSColor(patternImage: NSImage(named: "collec.png")!).CGColor
                
                self.window!.beginSheet(loginWindow, completionHandler: nil)
                
            }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loggedOut(_:)), name: .UH_USER_LOGGED_OUT, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.loggedIn(_:)), name: .UH_USER_LOGGED_IN, object: nil)
        
    }
    
    override init(window: NSWindow!) {
        if uH.isLoggedIn() {
            self.username = UserDefaults.standard.string(forKey: "username")!
            self.loginDate = Date.init(timeIntervalSince1970: UserDefaults.standard.double(forKey: "loginDate"))
        }
        
        super.init(window: window)
        //Initialization code here.
        
        /*********************** Stuff for unsaved data *******************/
        
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = UserDefaults.standard
            var cObj : [String]
            for i in 0..<keys.count {
                cObj = OBJ.object(forKey: keys[i]) as! [String]
                unsaved.append(
                    dataRetro(no: i+1, act: cObj[0], date: Date.init(timeIntervalSince1970: Double(cObj[2])!)
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

    @IBAction func accMenu(_ sender: AnyObject) {
        self.mainView.replaceSubview(activeSub, with: loginView.view)
        self.resize(ResizeGuy.account)
        activeSub = loginView.view
        
        if !uH.isLoggedIn() {
            self.window!.beginSheet(loginWindow, completionHandler: nil)
        }
    }
    
    @IBAction func uploadMenu(_ sender: AnyObject) {
        self.mainView.addSubview((uloView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (uloView?.view)!)
        self.resize(ResizeGuy.update)
        activeSub = (uloView?.view)!
    }
    
    @IBAction func updateMenu(_ sender: AnyObject) {
        self.mainView.addSubview((updView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (updView?.view)!)
        self.resize(ResizeGuy.update)
        activeSub = (updView?.view)!
    }
    
    @IBAction func generalMenu(_ sender: AnyObject) {
        self.mainView.addSubview((genView?.view)!)
        self.mainView.replaceSubview(activeSub, with: (genView?.view)!)
        self.resize(ResizeGuy.general)
        activeSub = (genView?.view)!
    }
    
    @IBAction func help(_ sender: AnyObject) {
        label.stringValue = "I said no updates available!"
    }
    
    //TODO: Make this method send WYD too
    @IBAction func retryUpload(_ sender: AnyObject) {
        
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = UserDefaults.standard
            var cObj : [String]
            for i in 0..<keys.count {
                cObj = OBJ.object(forKey: keys[i]) as! [String]
                var uRL : String
                let del : WYDoing
                
                
                switch cObj[0] {
                case "Sleeping":
                    uRL = "http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=\(cObj[1])&ih=0&ph=0&wh=0&ach=0&ts=\(cObj[2])"
                    del = SleepHandler() as WYDoing
                case "Working":
                    uRL = "http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=\(cObj[1])&ach=0&ts=\(cObj[2])"
                    del = WorkingClass() as WYDoing
                case "Inactive":
                    uRL = "http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=\(cObj[1])&ph=0&wh=0&ach=0&ts=\(cObj[2])"
                    del = Inactive() as WYDoing
                case "Studying":
                    uRL = "http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=\(cObj[1])&wh=0&ach=0&ts=\(cObj[2])"
                    del = Studying() as WYDoing
                default:
                    // It'll never fall into here so everything here
                    // is just for formality
                    uRL = ""
                    del = WYDoing.self as! WYDoing
                    break
                }
                
                Alamofire.request(uRL).responseString { (response) in
                    
                    if response.result.value == "done" {
                        
                        try? del.WYDupload(cdc: userHandler.cdc, from: Int(cObj[2])!, to: Int(cObj[1])!)
                        
                        OBJ.removeObject(forKey: keys[i])
                        
                        userHandler.createAlert("Successfully Uploaded", txt: "Activity: \(cObj[0]) at \(Date.init(timeIntervalSince1970: Double(cObj[2])!))")
                        _ = self.uH.arrayOfKeys("popKorn \(keys[i])")
                        
                    } else {
                        userHandler.createAlert("Server Unreachable", txt: "We're having issues uploading your data. Check your internet connection and try again by going to Preferences -> Upload")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var passWord: NSSecureTextField!
    
    @IBAction func login(_ sender: AnyObject) {
        
        if userName.stringValue.isEmpty || passWord.stringValue.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Both fields are required!"
            alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
        } else {
            let tryLogin = uH.login(userName.stringValue, pass: passWord.stringValue)
            let alert = NSAlert()
            
            switch tryLogin {
            case .loggedIn:
                self.username = userName.stringValue
                self.window!.endSheet(sender.window)
                sender.window.orderOut(self.window!)
                
                NotificationCenter.default.post(name: .UH_USER_LOGGED_IN, object: nil, userInfo: ["USN" : userName.stringValue])
            case .serverUnreachable:
                alert.messageText = "Server Unreachable. Check your internet connection and try again."
                alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
            case .incorrect:
                alert.messageText = "Incorrect Login. Check your login details and try again."
                alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
            }
        }
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        if userName.stringValue.isEmpty || passWord.stringValue.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Both fields are required!"
            alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
        } else {
            let tryLogin = uH.createAccount(userName.stringValue, pass: passWord.stringValue)
            let alert = NSAlert()
            
            switch tryLogin {
            case .loggedIn:
//                self.loggedInAs.stringValue = userName.stringValue
                self.window!.endSheet(sender.window)
                sender.window.orderOut(self.window!)
            case .serverUnreachable:
                alert.messageText = "Server Unreachable. Check your internet connection and try again."
                alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
            case .incorrect:
                alert.messageText = "Incorrect Login. Check your login details and try again."
                alert.beginSheetModal(for: (sender.superview!!.window!), completionHandler: nil)
            }
        }
    }
    
    @IBAction func closePref(_ sender: AnyObject) {
        self.window!.endSheet(sender.window)
        sender.window.orderOut(self.window!)
    }
    
    @objc private func loggedOut(_ note: Notification) {
        self.window!.beginSheet(loginWindow, completionHandler: nil)
    }
    
    func loggedIn(_ note: Notification) {
        _ = note.userInfo?["USN"] as! String
//        self.loggedInAs.stringValue = usn
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        if uH.isLoggedIn() {
            UserDefaults.standard.removeObject(forKey: "loginDate")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "cdc")
            
            let lgt_username = sender.superview??.superview?.subviews[0].subviews[1] as! NSTextField
            lgt_username.stringValue = "N/A"
        }
        NotificationCenter.default.post(name: .UH_USER_LOGGED_OUT, object: nil)
        
    }
    
    func resize(_ who: ResizeGuy) {
        let windowFrame = window!.frame
        let oldWidth = windowFrame.size.width
        
        var toAdd : CGFloat
        
        switch who {
        case .account:
            toAdd = CGFloat(272.0)
        case .update:
            toAdd = CGFloat(416.0)
        case .upload:
            toAdd = CGFloat(416.0)
        case .general:
            toAdd = CGFloat(272.0)
        }
        
        let contentRect = NSRect(x: 0, y: 0, width: oldWidth, height: toAdd)
        let contentFrame = mainView.window!.frameRect(forContentRect: contentRect)
        let toolbarHeight = windowFrame.size.height - contentFrame.size.height
        let newOrigin = NSPoint(x: windowFrame.origin.x, y: windowFrame.origin.y + toolbarHeight)
        let newFrame = NSRect(origin: newOrigin, size: contentFrame.size)
        window!.setFrame(newFrame, display: false, animate: true)
    }
    
    @IBAction func delItem(_ sender: NSButton) {
        let table = sender.superview?.subviews[0].subviews[0].subviews[0] as! NSTableView
        let selectedRow = table.selectedRow
        
        let selectedObjectIndexes = ArrayController.arrangedObjects as! [dataRetro]
        
        /*********************** Stuff for unsaved data *******************/
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = UserDefaults.standard
            OBJ.removeObject(forKey: keys[selectedObjectIndexes[selectedRow].no - 1])
            _ = self.uH.arrayOfKeys("popKorn \(keys[selectedObjectIndexes[selectedRow].no - 1])")

        }
        /*********************** Stuff for unsaved data *******************/
        
        ArrayController.remove(atArrangedObjectIndex: selectedRow)
    }
    
}

enum LoginGuy {
    case loggedIn
    case incorrect
    case serverUnreachable
}

enum ResizeGuy {
    case account
    case upload
    case update
    case general
}
