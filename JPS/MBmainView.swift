//
//  MBmainView.swift
//  JPS
//
//  Created by Jerry U. on 7/21/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MBmainView: NSView {
    
    var bgQueue = OperationQueue()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func loadData() {
        bgQueue.addOperation {
            DispatchQueue.main.async {
                self.hideData()}
        }
        let uH = userHandler()
        let jps = self.subviews[1] as! NSTextField
        let rank = self.subviews[4] as! NSTextField
        let info = self.subviews[3] as! NSTextField
        
        if uH.isLoggedIn() {
            if let url = URL(string: "https://jps.lyshnia.com/api/menubar.php?cdc=\(userHandler.cdc)") {
                bgQueue.addOperation {
                    do {
                        let contents = try String.init(contentsOf: url)
                        let ldb = contents.data(using: .utf8, allowLossyConversion: false)
                        let mbdtails = JSON(data: ldb!)
                        
                        DispatchQueue.main.async {
                            jps.stringValue = String(format: "%0.2f%%", mbdtails["jps"].floatValue)
                            rank.stringValue = mbdtails["rank"].string!
                            info.stringValue = {() -> String  in
                                if mbdtails["diff"].floatValue >= 0 {
                                    return "(Thats a \(mbdtails["diff"].floatValue)% increase from yesterday)"
                                } else {
                                    return "(Thats a \(abs(mbdtails["diff"].floatValue))% decrease from yesterday)"
                                }
                            }()
                            
                            self.unhideData()
                        }
                        
                    } catch {
                        // contents could not be loaded
                        DispatchQueue.main.async {
                            jps.stringValue  = "N/A"
                            rank.stringValue = "N/A"
                            info.stringValue = "(Are you sure your internet is working?)"
                            self.unhideData()
                        }
                    }
                }
            } else {
                Swift.print("Something isnt right")
            }
        }
        
        
    }
    
    func hideData() {
        self.isHidden = true
        self.superview?.subviews[4].isHidden = false
    }
    
    func unhideData() {
        self.superview?.subviews[4].isHidden = true
        self.isHidden = false
    }
}
