//
//  AcViewCon.swift
//  JPS
//
//  Created by Jerry U. on 6/7/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class AcViewCon: NSViewController {

    static var currVC: ViewController?
    
    @IBOutlet var btnHlght: NSView!
    @IBOutlet var ActBar: NSView! //Right-side MB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //Color Actbar
        self.ActBar.layer?.backgroundColor = NSColor(red: 225.0/255.0, green: 222.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
        
        self.btnHlght.layer?.backgroundColor = NSColor.white.cgColor//NSColor.init(red: 0.941, green: 0.973, blue: 1.0, alpha: 1).cgColor
        
        self.btnHlght.shadow = NSShadow()
        self.btnHlght.layer?.shadowOpacity = 0.5
        self.btnHlght.layer?.shadowRadius = 3.0
        self.btnHlght.layer?.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.hgBtnTo()
        
//        self.ActBar.addSubview(self.btnHlght, positioned: .below, relativeTo: self.ActBar.subviews[0])
        
        AcViewCon.currVC = Activity.working.getView()
        AcViewCon.currVC?.view.layer?.backgroundColor = NSColor.white.cgColor// NSColor.init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1)).cgColor
        AcViewCon.currVC?.view.shadow = NSShadow()
        AcViewCon.currVC?.view.layer?.shadowOpacity = 0.1
        AcViewCon.currVC?.view.layer?.shadowRadius = 1.0
        AcViewCon.currVC?.view.layer?.shadowOffset = CGSize(width: 4.0, height: 10.0)
        self.view.addSubview((AcViewCon.currVC?.view)!)//, positioned: .below, relativeTo: self.ActBar)
        
    }
    
    convenience init() {
        self.init(nibName: "Activity", bundle: nil)!
    }
    
    func loadVC(vc: ViewController) {
        
        vc.view.layer?.backgroundColor = NSColor.white.cgColor//init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1)).cgColor
        vc.view.shadow = NSShadow()
        vc.view.layer?.shadowOpacity = 0.1
        vc.view.layer?.shadowRadius = 1.0
        vc.view.layer?.shadowOffset = CGSize(width: 4.0, height: 10.0)
        
        self.view.addSubview(vc.view)
        self.view.replaceSubview((AcViewCon.currVC?.view)!, with: vc.view)
        AcViewCon.currVC = vc
        self.view.needsDisplay = true
    }
    
    @IBAction func sleep(_ sender: Any) {
        self.hgBtnTo(-3, y: 273)
        self.loadVC(vc: Activity.sleeping.getView())
    }
    
    @IBAction func work(_ sender: Any) {
        self.hgBtnTo()
        self.loadVC(vc: Activity.working.getView())
    }
    
    @IBAction func inactive(_ sender: Any) {
        self.hgBtnTo(-3, y: 143)
        self.loadVC(vc: Activity.inactive.getView())
    }
    
    @IBAction func study(_ sender: Any) {
        self.hgBtnTo(-3, y: 75)
        self.loadVC(vc: Activity.studying.getView())
    }
    
    func getBGView() -> NSView {
        let vw = NSView.init(frame: NSRect.init(x: 20, y: 296, width: 86, height: 54))
        vw.layer?.backgroundColor = NSColor.red.cgColor// NSColor.init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1)).cgColor
        return vw
    }
    
    func hgBtnTo(_ x: CGFloat = -3, y: CGFloat = 205) {
        let newSize = NSMakeRect(x, y, self.btnHlght.frame.width, self.btnHlght.frame.height)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.1
            self.btnHlght.animator().frame = newSize
        }, completionHandler: {
            Swift.print("completed")
        })

    }
    
}



enum Activity {
    case sleeping
    case working
    case studying
    case inactive
    
    func getView() -> ViewController {
        switch self {
        case .sleeping:
            return ViewController(nibName: "Sleeping", bundle: nil)!
        case .working:
            return ViewController(nibName: "Working", bundle: nil)!
        case .studying:
            return ViewController(nibName: "Studying", bundle: nil)!
        case .inactive:
            return ViewController(nibName: "Inactive", bundle: nil)!
    
        }
    }
    
}
