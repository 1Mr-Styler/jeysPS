//
//  MMPD.swift
//  JPS
//
//  Created by Jerry U. on 9/22/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Alamofire

class MMPD: NSView {
    @IBOutlet var MPD: NSTextField!
    var jsond : JSON!
    var vc: PieChartViewController!
    @IBOutlet weak var loadingGif: NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.subviews[0].layer?.backgroundColor = NSColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
        self.layer?.backgroundColor = NSColor.white.cgColor
        self.vc = self.window?.contentViewController?.childViewControllers[1].childViewControllers[1] as! PieChartViewController
        
        loadingGif.canDrawSubviewsIntoLayer = true
        loadingGif.imageScaling = .scaleProportionallyDown
        for i in self.subviews {
            i.isHidden = true
        }
        self.addSubview(loadingGif)
        
        if userHandler().isLoggedIn() {
            Alamofire.request("https://jps.lyshnia.com/api/pd.php?cdc=\(userHandler.cdc)&mm=0").responseString { (response) in
                
                let contents = response.result.value
                let ldb = contents?.data(using: .utf8, allowLossyConversion: false)
                self.jsond = JSON(data: ldb!)
                
                Swift.print(self.jsond)
                DispatchQueue.main.async {
                    self.MPD.stringValue = self.jsond["top"][0].stringValue.uppercased() + "S"
                    self.vc.initPlot()
                    self.loadingGif.removeFromSuperview()
                    for i in self.subviews {
                        i.isHidden = false
                    }
                }
            }
        } else {
            Swift.print("You need to be logged in")
        }
        
    }

    @IBAction func switchWitch(_ sender: NSSegmentedControl) {
        if sender.label(forSegment: sender.selectedSegment) == "Most Productive" {
            self.vc.initPlot()
        } else {
            self.vc.initPlot(with: "LP")
        }
    }
    
}
