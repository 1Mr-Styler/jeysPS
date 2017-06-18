//
//  sideBar.swift
//  JPS
//
//  Created by Jerry U. on 5/8/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class sideBar: NSViewController {
    
    var parentSplit : NSSplitViewController? {
        guard let splitVC = parent as? Juveni else { return nil }
        return splitVC
    }
    
    var detailView : JVc? {
        guard let myG = parentSplit?.childViewControllers[1] as? JVc else { return nil }
        return myG
    }
    
    var switchView : NSSplitViewItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBOutlet var QuickLook: NSButton!
    @IBAction func toog(_ sender: Any) {
        print("QS: ", QuickLook.state )
        if QuickLook.state == NSOnState {
            detailView?.showActivities(AcViewCon())
            
//            switchView = switchView == nil ? NSSplitViewItem.init(viewController: AcViewCon()) : switchView
            
//            parentSplit?.addSplitViewItem(switchView!)
        } else {
            detailView?.showActivities()
//            if switchView != nil {
//                //TODO: Figure out how this method works
//                parentSplit?.removeSplitViewItem(switchView!)
//            }
        }
    }
    
}
