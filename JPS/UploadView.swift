//
//  UploadView.swift
//  JPS
//
//  Created by Jerry U. on 9/11/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class UploadView: NSView {

    @IBOutlet weak var ArraayController: NSArrayController!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let selectedObjectIndexes = ArraayController.arrangedObjects as! [dataRetro]
        
        /*********************** Stuff for unsaved data *******************/
        let uH = userHandler()
        let keys = uH.arrayOfKeys("") as! [String]
        
        if keys.count > 0 {
            let OBJ = UserDefaults.standard
            var cObj : [String]
            
            //Remove all existing entries
            for i in 0..<selectedObjectIndexes.count {
                ArraayController.removeObject(selectedObjectIndexes[i])
            }
            
            // Repopulate
            for i in 0..<keys.count {
                
                cObj = OBJ.object(forKey: keys[i]) as! [String]
                
                ArraayController.addObject(dataRetro(no: i+1, act: cObj[0], date: Date.init(timeIntervalSince1970: Double(cObj[2])!))
                )
                
            }
        }
        
        /*********************** Stuff for unsaved data *******************/
        
    }
    
}
