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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleTableChange(_:)), name: .CS_TABLE_SELECTION_CHG, object: nil)
    }
    
    func handleTableChange(_ note: Notification) {
        let SL = note.userInfo?["TXT"] as! TableController.SELECTED_ROW
        
        switch SL {
        case .MOST_PRODUCTIVE_DAY:
            print("")
        case .LEAST_PRODUCTIVE_DAY:
            print("")
        case .LEADERBOARD:
            detailView?.push(ViewController(nibName: "leaderboard", bundle: nil)!, tag: 3, isActivity: false)
        case .MY_TOP10_WEEK:
            print("K")
        case .MY_TOP10_MONTH:
            print("J")
        }
    }
    
    @IBOutlet var QuickLook: NSButton!
    @IBAction func toog(_ sender: Any) {
        if QuickLook.state == NSOnState {
            detailView?.showActivities(AcViewCon(), restore: true)
        } else {
            detailView?.showActivities(AcViewCon())
        }
    }
    
}

extension Notification.Name {
    static let CS_TABLE_SELECTION_CHG = Notification.Name("tableSelectionChanged")
    static let UH_USER_LOGGED_OUT = Notification.Name("userLoggedOut")
    static let UH_USER_LOGGED_IN = Notification.Name("userLoggedIn")
}
