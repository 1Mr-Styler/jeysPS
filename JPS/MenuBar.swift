//
//  MenuBar.swift
//  Logga
//
//  Created by Jerry U. on 7/19/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class MenuBar: NSObject {
    var statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    var button = NSStatusBarButton()
    var eventMonitor: EventMonitor?
    
    func setUp() {
        guard let button = self.statusItem.button else {
            exit(0)
        }
        self.button = button
        self.button.target = self
        self.button.image = NSImage(named: "StatusIcon")
        self.button.action = #selector(self.display(sender:))
        
        popover.contentViewController = MenuBarVC(nibName: "Main", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.popover.performClose(event)
                self.eventMonitor?.stop()
            }
        }
        eventMonitor?.start()
        
        // Add right click functionality
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x2 // right mouse
        gesture.target = self
        gesture.action = #selector(MenuBar.rightMenu(_:))
        self.button.addGestureRecognizer(gesture)
    }
    
    func display(sender: NSStatusBarButton) {
        if self.popover.isShown {
            self.hide(sender)
        } else {
//            print(popover.contentViewController?.view.subviews)
            let MBmv = popover.contentViewController?.view.subviews[4] as? MBmainView
            
            MBmv?.loadData()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
        
    }
    
    func hide(_ sender: NSStatusBarButton) {
        self.popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func rightMenu(_ sender: Any) {
        print("Hi everybody")
        
    }
    
    func remove() {
        NSStatusBar.system().removeStatusItem(self.statusItem)
    }
    
}
