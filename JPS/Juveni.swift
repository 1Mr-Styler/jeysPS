//
//  Juveni.swift
//  JPS
//
//  Created by Jerry U. on 5/8/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Juveni: NSSplitViewController {
    
    var master: sideBar!
    var detail: JVc!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.translatesAutoresizingMaskIntoConstraints = true
        master = sideBar(nibName: "sideBar", bundle: nil)
        detail = JVc(nibName: "detail", bundle: nil)
        if #available(OSX 10.11, *) {
            self.addSplitViewItem(NSSplitViewItem.init(sidebarWithViewController: master))
        } else {
            // Fallback on earlier versions
        }
        self.addSplitViewItem(NSSplitViewItem.init(viewController: detail))
    }
    
}
