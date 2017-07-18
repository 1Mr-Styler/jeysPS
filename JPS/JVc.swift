//
//  JVc.swift
//  JPS
//
//  Created by Jerry U. on 5/8/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class JVc: NSViewController {
    
    // Save tags and their VCs
    static var tagManager = [Int: NSViewController]()
    
    fileprivate var activeViewCon : NSViewController?
    fileprivate var preWidth : CGFloat?
    fileprivate let sideBarWidth = CGFloat(256.0)
    
    fileprivate var parentSplit : NSSplitViewController? {
        guard let splitVC = parent as? Juveni else { return nil }
        return splitVC
    }
    
    fileprivate var asSplitGuy : NSSplitViewItem? {
        guard let myG = parentSplit?.splitViewItems[1] else { return nil }
        return myG
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func push(_ viewCon: NSViewController, tag: Int, isActivity: Bool = true) {
        
        guard !JVc.tagManager.keys.contains(tag) else {
            self.loadTag(tag: tag)
            
            return
        }
        
        if isActivity {
            self.addChildViewController(viewCon)
            activeViewCon = viewCon
            if self.view.subviews.count > 0 {
                self.view.subviews[0].removeFromSuperview()
            }
            resize(((activeViewCon?.view.frame.width)! + sideBarWidth))
            self.view.addSubview((activeViewCon?.view)!)

        } else {
            self.addChildViewController(viewCon)
            if (asSplitGuy?.isCollapsed)! {
                asSplitGuy?.isCollapsed = !(asSplitGuy?.isCollapsed)!
            }
            activeViewCon = viewCon
            if self.view.subviews.count > 0 {
                self.view.subviews[0].removeFromSuperview()
            }
            resize(((activeViewCon?.view.frame.width)! + sideBarWidth))
            self.view.addSubview((activeViewCon?.view)!)
        }
        
        JVc.tagManager[tag] = activeViewCon
    }
    
    func showActivities(_ withVC: NSViewController? = nil, restore: Bool = false) {
        
//        guard withVC != nil else {
//            if (asSplitGuy?.isCollapsed)! {
//                asSplitGuy?.isCollapsed = !(asSplitGuy?.isCollapsed)!
//                resize((preWidth! + sideBarWidth))
//            } else {
//                preWidth = activeViewCon?.view.frame.width
//                asSplitGuy?.isCollapsed = !(asSplitGuy?.isCollapsed)!
//                resize(CGFloat(sideBarWidth))
//            }
//            return
//        }
//        
//        
//        if (asSplitGuy?.isCollapsed)! {
//            asSplitGuy?.isCollapsed = !(asSplitGuy?.isCollapsed)!
//            preWidth = activeViewCon?.view.frame.width
//            resize((preWidth! + sideBarWidth))
//        }
        self.push(withVC!, tag: 0)
    }
    
    func loadTag(tag: Int) {
        activeViewCon = JVc.tagManager[tag]
        if self.view.subviews.count > 0 {
            self.view.subviews[0].removeFromSuperview()
        }
        resize(((activeViewCon?.view.frame.width)! + sideBarWidth))
        self.view.addSubview((activeViewCon?.view)!)

    }

    
    private func resize(_ to: CGFloat) {
        let windowFrame = self.view.window?.frame
        let oldHieght = windowFrame?.size.height
        
        let contentRect = NSRect(x: 0, y: 0, width: to, height: oldHieght!)
        let contentFrame = self.view.window?.frameRect(forContentRect: contentRect)
        let toolbarHeight = (windowFrame?.size.height)! - (contentFrame?.size.height)!
        let newOrigin = NSPoint(x: (windowFrame?.origin.x)!, y: (windowFrame?.origin.y)! + toolbarHeight)
        let newFrame = NSRect(origin: newOrigin, size: (contentFrame?.size)!)
        self.view.window?.setFrame(newFrame, display: false, animate: false)
    }
}
