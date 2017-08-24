//
//  MBActivityHandler.swift
//  Logga
//
//  Created by Jerry U. on 7/20/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MBActivityHandler: NSObject {
    private var currAct: MBActivity
    private var isLoading = false
    var total: Int = 0
    var previous: Int = 0
    var current: Int = 0 {
        willSet {
            if !isLoading {
                previous = current
                total = total + newValue
            }
        }
    }
    
    override var description: String {
        return "Total time \(self.currAct.activity) today: \(self.toHMS(seconds: self.total))"
    }
    
    init(currently activity: MBActivity) {
        self.currAct = activity
    }
    
    func toHMS(seconds: Int) -> String {
        let secs = seconds / 3600
        let mins = ( seconds % 3600) / 60
        let hrs = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", secs, mins, hrs)
    }
    
    func save() {
        self.currAct.save(total: total, prev: previous, curr: current)
    }
    
    func load() {
        self.isLoading = true
        let data = self.currAct.load()
        self.total = (data?.total)!
        self.current = (data?.current)!
        self.isLoading = false
    }
    
    deinit {
        self.save()
    }
    
}

enum MBActivity {
    case WORKING
    case SLEEPING
    case INACTIVE
    case STUDYING
    
    var activity: String {
        switch self {
        case .WORKING:
            return "Working"
        case .SLEEPING:
            return "Sleeping"
        case .INACTIVE:
            return "Inactive"
        case .STUDYING:
            return "Studying"
            
        }
    }
    
    func save(total: Int, prev: Int, curr: Int) {
        let MBAD = MBActivityData(activity: self.activity)
        MBAD.previous = prev
        MBAD.current = curr
        MBAD.total = total
        
        MBAD.save()
    }
    
    func load() -> MBActivityData? {
        return MBActivityData(activity: self.activity)
    }
    
}

class MBActivityData: NSObject {
    var activity: String = "Working"
    var total: Int?
    var previous: Int?
    var current: Int?
    var json: JSON?
    let fileurl : URL = Bundle.main.url(forResource: "mbdata", withExtension: "json")!
    
    init(activity: String) {
        self.activity = activity
        
        super.init()
        self.load()
    }
    
    func save() {
        json?[self.activity]["total"].intValue = self.total!
        json?[self.activity]["previous"].intValue = self.previous!
        json?[self.activity]["current"].intValue = self.current!
        
        json?[self.activity]["LastRun"].doubleValue = Date().timeIntervalSince1970
        json?["LastRun"].doubleValue = Date().timeIntervalSince1970
        
        let rep = json?.rawString([.castNilToNSNull: true])
        
        do {
            try rep?.write(to: fileurl, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }

    func load() {
        let js = try? Data.init(contentsOf: fileurl)
        
        self.json = JSON(data: js!)
        self.total = json?[self.activity]["total"].intValue
        self.previous = json?[self.activity]["previous"].intValue
        self.current = json?[self.activity]["current"].intValue
        
        // Reset timers to 0 if its a new day
        let fromLoaded = Date.init(timeIntervalSince1970: (json?[self.activity]["LastRun"].double)!)
        let fromNow = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970)
        let form = DateFormatter()
        
        form.timeStyle = .none
        form.dateStyle = .short
        
        
        if form.string(from: fromLoaded) != form.string(from: fromNow) {
            //Cuz its almost a new day, stop current activity and start new one
            self.total = 0
            self.previous = 0
            self.current = 0
        }
        
    }
    
}

extension Notification.Name {
    static let MB_ACTIVITY_SLEEPING = Notification.Name("MB_ACTIVITY_SLEEPING")
    static let MB_ACTIVITY_WORKING = Notification.Name("MB_ACTIVITY_WORKING")
    static let MB_ACTIVITY_INACTIVE = Notification.Name("MB_ACTIVITY_INACTIVE")
    static let MB_ACTIVITY_STUDYING = Notification.Name("MB_ACTIVITY_STUDYING")
}

enum MB_Activity {
    case Start
    case Stop
}
