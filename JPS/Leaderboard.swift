//
//  Leaderboard.swift
//  JPS
//
//  Created by Jerry U. on 7/17/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Alamofire

class Leaderboard: NSObject, NSTableViewDataSource {
    var myRay : [Leaderboard_Tabler] = []
    @IBOutlet weak var table: NSTableView!
    
    override init() {
        super.init()
        
        Alamofire.request("https://jps.lyshnia.com/api/ranking.php").responseString { (response) in
            
            let contents = response.result.value
            let ldb = contents?.data(using: .utf8, allowLossyConversion: false)
            let jsond = JSON(data: ldb!)
            
            for rank in jsond.array! {
                
                let yestdy = rank["yesterday"]["rank"].string ?? "N/A"
                let today = rank["today"]["rank"].string ?? "N/A"
                let peak = rank["today"]["peak"].string ?? "N/A"
                var jps = rank["today"]["jps"].string ?? "N/A"
                if jps != "N/A"{
                    jps = "\(String(format: "%.2f", ceil(Double(jps)!*100)/100))%"
                }
                
                let image: NSImage
                var prev = rank["today"]["prev"].intValue
                if prev == 0 {
                    prev = rank["today"]["rank"].intValue + 1
                }
                
                switch rank["today"]["rank"].intValue {
                case let x where x < prev:
                    image = NSImage.init(named: "Green_Arrow_Up")!
                case let x where x > prev:
                    image = NSImage.init(named: "Red_Arrow_Down")!
                default:
                    image = NSImage.init(named: "left_right")!
                    
                }
                
                self.myRay.append(Leaderboard_Tabler("", today: "#\(today)", yesterday: "#\(yestdy)", peak: "#\(peak)", jps: jps, image: image))
                
                
                self.table.reloadData()
                DispatchQueue.main.async {
                    self.table.superview?.superview?.superview?.subviews[2].isHidden = true
                }
            }
        }
    }
    
    func numberOfRows(in _: NSTableView) -> Int {
        return myRay.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return myRay[row]
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return MyNSTableRowView()
    }
    
    @IBAction func refresh(_ sender: Any) {
        // Broadcast TableSelection changed so as to refresh leaderboard
        let SL = TableController.SELECTED_ROW(rawValue: 2)
        NotificationCenter.default.post(name: .CS_TABLE_SELECTION_CHG, object: nil, userInfo: ["TXT": SL!])
    }
}

class Leaderboard_Tabler: NSObject {
    var jps : String
    var peak : String
    var today : String
    var username : String
    var yesterday : String
    var image : NSImage
    
    init(_ username: String, today: String, yesterday: String, peak: String, jps: String, image: NSImage) {
        self.username = username
        self.today = today
        self.yesterday = yesterday
        self.peak = peak
        self.jps = jps
        self.image = image
    }
}
