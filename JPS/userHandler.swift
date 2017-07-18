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
            if let bl3 =  UserDefaults.standard.string(forKey: "cdc") {
                return bl3
            } else {
                return ""
            }
        }
    }
    
    var hasMenuBar : Bool {
        let hmb = UserDefaults.standard.integer(forKey: "showMB")
        if hmb == 1 {
            return true
        } else {
            return false
        }
    }
    
    
    static var activeClass : String = ""
    
    @IBOutlet weak var window: NSWindow!
    
    class func createAlert(_ title : String, txt: String){
        let alert : NSAlert = NSAlert()
        alert.messageText = title
        alert.informativeText = txt
        alert.alertStyle = NSAlertStyle.warning
        
        alert.runModal()
    }
    
   
    @IBOutlet weak var ach: NSTextField!
    var contents: NSString = ""
    
    @IBAction func setAchi(_ sender: AnyObject) {
        if let url = URL(string: "http://jps.lyshnia.com/apr.php?cdc=\(userHandler.cdc)&sh=0&ih=0&ph=0&wh=0&ach=\(ach.stringValue)") {
            do {
                contents = try NSString(contentsOf: url, usedEncoding: nil)
                print(contents)
            } catch {
                // contents could not be loaded
                print("// contents could not be loaded")
            }
        } else {
            print("Something isnt right")
        }
    }
    
    func couldntUpload(_ sav : Savings) {
        UserDefaults.standard.set([sav.activity, sav.lenght, sav.start], forKey: self.arrayOfKeys("add") as! String)
        UserDefaults.standard.synchronize()
        
        print(self.arrayOfKeys(""))
    }
    
    func arrayOfKeys(_ key: String) -> AnyObject {
        let OBJ = UserDefaults.standard
        var keys = OBJ.object(forKey: "keys") as? [String]
        
        if key.isEmpty {
            if keys == nil {
                return [] as AnyObject
            } else {
                return keys! as AnyObject //[Blessed0,Blessed1,Blessed2,...]
            }
            
        } else {
            var keyname: String
            
            if key.contains("popKorn") {//Delete entry
                print("popkorn")
                
                keyname = key.components(separatedBy: " ")[1]
                
                if keys != nil {
                    if let i = keys?.index(of: keyname) {
                        keys?.remove(at: i)
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
            OBJ.set(keys, forKey: "keys")
            OBJ.synchronize()
        
            return keyname as AnyObject
        }
    }
    
    func isLoggedIn() -> Bool {
        let OBJ = UserDefaults.standard
        
        if OBJ.string(forKey: "cdc") != nil {
            return true
        }
        return false
    }
    
    func login(_ user: String, pass: String) -> LoginGuy {
        
        let uRL = "http://jps.lyshnia.com/apr.php?login=\(user)&pas=\(pass)"
        let OBJ = UserDefaults.standard

        if let url = URL(string: uRL) {
            do {
                let res = try NSString(contentsOf: url, usedEncoding: nil)
                print(res)
                if res == "invalid" {
                    return LoginGuy.incorrect
                }
                OBJ.set(res as String, forKey: "cdc")
                OBJ.set(Date().timeIntervalSince1970, forKey: "loginDate")
                OBJ.set(user, forKey: "username")
                
                return LoginGuy.loggedIn
            } catch {
                // contents could not be loaded
                return LoginGuy.serverUnreachable
            }
        } else {
            return LoginGuy.serverUnreachable
        }
    }
    
    func createAccount(_ user: String, pass: String) -> LoginGuy {
        let uRL = "http://jps.lyshnia.com/apr.php?login=\(user)&pass=\(pass)"
        let OBJ = UserDefaults.standard
        
        if let url = URL(string: uRL) {
            do {
                let res = try NSString(contentsOf: url, usedEncoding: nil)
                print(res)
                if res == "error" {
                    return LoginGuy.serverUnreachable
                }
                OBJ.set(res as String, forKey: "cdc")
                OBJ.set(Date().timeIntervalSince1970, forKey: "loginDate")
                OBJ.set(user, forKey: "username")
                
                return LoginGuy.loggedIn
            } catch {
                // contents could not be loaded
                return LoginGuy.serverUnreachable
            }
        } else {
            return LoginGuy.serverUnreachable
        }
    }
}
