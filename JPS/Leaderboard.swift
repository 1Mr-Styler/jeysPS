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
                    myRay.append(Leaderboard_Tabler(rank["user"].string!, today: "#\(rank["today"]["rank"].string!)", yesterday: "#\(yestdy)"))
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
}

class Leaderboard_Tabler: NSObject {
    var username : String
    var today : String
    var yesterday : String
    
    init(_ username: String, today: String, yesterday: String) {
        self.username = username
        self.today = today
        self.yesterday = yesterday
    }
}
