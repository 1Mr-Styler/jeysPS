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
        
        self.btnHlght.layer?.backgroundColor = NSColor.white.cgColor
        self.btnHlght.shadow = NSShadow()
        self.btnHlght.layer?.shadowOpacity = 0.5
        self.btnHlght.layer?.shadowRadius = 3.0
        self.btnHlght.layer?.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.hgBtnTo()
        
        AcViewCon.currVC = Activity.working.getView()
        AcViewCon.currVC?.view.layer?.backgroundColor = NSColor.white.cgColor
        AcViewCon.currVC?.view.shadow = NSShadow()
        AcViewCon.currVC?.view.layer?.shadowOpacity = 0.1
        AcViewCon.currVC?.view.layer?.shadowRadius = 1.0
        AcViewCon.currVC?.view.layer?.shadowOffset = CGSize(width: 4.0, height: 10.0)
        self.view.addSubview((AcViewCon.currVC?.view)!)
        self.loadVC(vc: Activity.working.getView(), activity: "work")
        
    }
    
    convenience init() {
        self.init(nibName: "Activity", bundle: nil)!
    }
    
    static var loadedVCs = [String: ViewController]()
    
    func loadVC(vc: ViewController, activity: String) {
        
        if AcViewCon.loadedVCs.keys.contains(activity) {
            let vc = AcViewCon.loadedVCs[activity]
            self.view.addSubview((vc?.view)!)
            self.view.replaceSubview((AcViewCon.currVC?.view)!, with: (vc?.view)!)
            AcViewCon.currVC = vc
            self.view.needsDisplay = true
        } else {
            vc.view.layer?.backgroundColor = NSColor(red: 236.0/255.0, green: 247.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor//init(red: CGFloat(0.941), green: CGFloat(0.973), blue: CGFloat(1.0), alpha: CGFloat(1)).cgColor
            vc.view.shadow = NSShadow()
            vc.view.layer?.shadowOpacity = 0.1
            vc.view.layer?.shadowRadius = 1.0
            vc.view.layer?.shadowOffset = CGSize(width: 4.0, height: 10.0)
            
            self.view.addSubview(vc.view)
            self.view.replaceSubview((AcViewCon.currVC?.view)!, with: vc.view)
            AcViewCon.currVC = vc
            self.view.needsDisplay = true
            
            AcViewCon.loadedVCs[activity] = vc        }
    }
    
    @IBAction func sleep(_ sender: Any) {
        self.hgBtnTo(-3, y: 273)
        self.loadVC(vc: Activity.sleeping.getView(), activity: "sleep")
    }
    
    @IBAction func work(_ sender: Any) {
        self.hgBtnTo()
        self.loadVC(vc: Activity.working.getView(), activity: "work")
    }
    
    @IBAction func inactive(_ sender: Any) {
        self.hgBtnTo(-3, y: 143)
        self.loadVC(vc: Activity.inactive.getView(), activity: "inactive")
    }
    
    @IBAction func study(_ sender: Any) {
        self.hgBtnTo(-3, y: 75)
        self.loadVC(vc: Activity.studying.getView(), activity: "study")
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
//            Swift.print("completed")
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
