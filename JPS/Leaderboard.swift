//
//  Leaderboard.swift
//  JPS
//
//  Created by Jerry U. on 7/17/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Leaderboard: NSObject, NSTableViewDataSource {
    var myRay : [Leaderboard_Tabler] = []
    
    override init() {
        
        if let url = URL(string: "https://jps.lyshnia.com/api/ranking.php") {
            do {
                let contents = try String.init(contentsOf: url)
                let ldb = contents.data(using: .utf8, allowLossyConversion: false)
                let jsond = JSON(data: ldb!)
                
                for rank in jsond.array! {
                    print(rank)
                    let yestdy = rank["yesterday"]["rank"].string ?? "N/A"
                    let today = rank["today"]["rank"].string ?? "N/A"
                    let peak = rank["today"]["peak"].string ?? "N/A"
                    let jps = rank["today"]["jps"].string ?? "N/A"
                    myRay.append(Leaderboard_Tabler(rank["user"].string!, today: "#\(today)", yesterday: "#\(yestdy)", peak: "#\(peak)", jps: "\(jps)%"))
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

class Leaderboard_Tabler: NSObject {
    var jps : String
    var peak : String
    var today : String
    var username : String
    var yesterday : String
    
    init(_ username: String, today: String, yesterday: String, peak: String, jps: String) {
        self.username = username
        self.today = today
        self.yesterday = yesterday
        self.peak = peak
        self.jps = jps
    }
}
