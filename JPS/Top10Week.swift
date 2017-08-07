//
//  Top10Week.swift
//  JPS
//
//  Created by Jerry U. on 8/7/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Top10Week: NSObject, NSTableViewDataSource {

    var myRay : [TW_Tabler] = []
    let uH = userHandler()
    
    override init() {
        let url = URL(string: "https://jps.lyshnia.com/api/top10.php?cdc=\(userHandler.cdc)&t=weekly")
        
        if uH.isLoggedIn() {
            do {
                let contents = try String.init(contentsOf: url!)
                let ldb = contents.data(using: .utf8, allowLossyConversion: false)
                let jsond = JSON(data: ldb!)
                
                var i: Int = 1
                for record in jsond.array! {
                    
                    let jps = "\(String(format: "%.2f", ceil(record["jps"].double!*100)/100))%"
                    let week = "Week \(record["week"].stringValue), \(record["year"].intValue)"
                    let work = "\(String(format: "%.2f", ceil(record["wh"].double!*100)/100)) hours"
                    let sleep = "\(String(format: "%.2f", ceil(record["sh"].double!*100)/100)) hours"
                    let inactive_study =
                    "\(String(format: "%.2f", ceil(record["ih"].double!*100)/100)) / \(String(format: "%.2f", ceil(record["ph"].double!*100)/100)) hours"
                    
                    myRay.append(TW_Tabler(jps: jps, week: week, work: work, sleep: sleep, inactive_study: inactive_study, num: i))
                    i += 1
                }
            } catch {
                // contents could not be loaded
                print("// contents could not be loaded")
            }
        } else {
            print("Something isnt right")
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

class TW_Tabler: NSObject {
    var no : Int
    var jps : String
    var week : String
    var work : String
    var sleep : String
    var inactive_study : String
    
    init(jps: String, week: String, work:String, sleep : String, inactive_study: String, num: Int) {
        self.no = num
        self.jps = jps
        self.week = week
        self.work = work
        self.sleep = sleep
        self.inactive_study = inactive_study
    }
}
