//
//  userHandler.swift
//  JPS
//
//  Created by Jerry U. on 3/25/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class userHandler: NSObject {
    class var cdc : String {
        get {
            if let bl3 =  NSUserDefaults.standardUserDefaults().stringForKey("cdc") {
                return bl3
            } else {
                return ""
            }
        }
    }
    
    var hasMenuBar : Bool {
        let hmb = NSUserDefaults.standardUserDefaults().integerForKey("showMB")
        if hmb == 1 {
            return true
        } else {
            return false
        }
    }
    
    
    static var activeClass : String = ""
    
    @IBOutlet weak var window: NSWindow!
    
    class func createAlert(title : String, txt: String){
        let alert : NSAlert = NSAlert()
        alert.messageText = title
        alert.informativeText = txt
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        
        alert.runModal()
    }
    
   
    @IBOutlet weak var ach: NSTextField!
    var contents: NSString = ""
    
    @IBAction func setAchi(sender: AnyObject) {
        if let url = NSURL(string: "http://localhost/jenny/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=0&ach=\(ach.stringValue)") {
            do {
                contents = try NSString(contentsOfURL: url, usedEncoding: nil)
                print(contents)
            } catch {
                // contents could not be loaded
                print("// contents could not be loaded")
            }
        } else {
            print("Something isnt right")
        }
    }
    
    func couldntUpload(sav : Savings) {
        NSUserDefaults.standardUserDefaults().setObject([sav.activity, sav.lenght, sav.start], forKey: self.arrayOfKeys("add") as! String)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        print(self.arrayOfKeys(""))
    }
    
    func arrayOfKeys(key: String) -> AnyObject {
        let OBJ = NSUserDefaults.standardUserDefaults()
        var keys = OBJ.objectForKey("keys") as? [String]
        
        if key.isEmpty {
            if keys == nil {
                return []
            } else {
                return keys! //[Blessed0,Blessed1,Blessed2,...]
            }
            
        } else {
            var keyname: String
            
            if key.containsString("popKorn") {
                print("popkorn")
                
                keyname = key.componentsSeparatedByString(" ")[1]
                
                if keys != nil {
                    if let i = keys?.indexOf(keyname) {
                        keys?.removeAtIndex(i)
                    }
                }
            } else {
                if keys == nil {
                    keyname = "Blessed0"
                    keys = [keyname]
                } else {
                    keyname = "Blessed\(keys!.count)"
                    
                    //Check if key already exists
                    if keys!.contains(keyname) {
                        //make new keyname
                        keyname = "Gifted\(Int(arc4random_uniform(10) + 10))"
                    }
                    
                    keys!.append(keyname)
                }
            }
            OBJ.setObject(keys, forKey: "keys")
            OBJ.synchronize()
        
            return keyname
        }
    }
    
    func isLoggedIn() -> Bool {
        let OBJ = NSUserDefaults.standardUserDefaults()
        
        if OBJ.stringForKey("cdc") != nil {
            return true
        }
        return false
    }
    
    func login(user: String, pass: String) -> LoginGuy {
        
        let uRL = "http://localhost/jenny/apr.php?login=\(user)&pas=\(pass)"
        let OBJ = NSUserDefaults.standardUserDefaults()

        if let url = NSURL(string: uRL) {
            do {
                let res = try NSString(contentsOfURL: url, usedEncoding: nil)
                print(res)
                if res == "invalid" {
                    return LoginGuy.Incorrect
                }
                OBJ.setObject(res as String, forKey: "cdc")
                OBJ.setObject(NSDate().timeIntervalSince1970, forKey: "loginDate")
                OBJ.setObject(user, forKey: "username")
                
                return LoginGuy.LoggedIn
            } catch {
                // contents could not be loaded
                return LoginGuy.ServerUnreachable
            }
        } else {
            return LoginGuy.ServerUnreachable
        }
    }
    
    func createAccount(user: String, pass: String) -> LoginGuy {
        let uRL = "http://localhost/jenny/apr.php?login=\(user)&pass=\(pass)"
        let OBJ = NSUserDefaults.standardUserDefaults()
        
        if let url = NSURL(string: uRL) {
            do {
                let res = try NSString(contentsOfURL: url, usedEncoding: nil)
                print(res)
                if res == "error" {
                    return LoginGuy.ServerUnreachable
                }
                OBJ.setObject(res as String, forKey: "cdc")
                OBJ.setObject(NSDate().timeIntervalSince1970, forKey: "loginDate")
                OBJ.setObject(user, forKey: "username")
                
                return LoginGuy.LoggedIn
            } catch {
                // contents could not be loaded
                return LoginGuy.ServerUnreachable
            }
        } else {
            return LoginGuy.ServerUnreachable
        }
    }
}
