//
//  TableController.swift
//  JPS
//
//  Created by Jerry U. on 5/8/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class TableController: NSObject, NSTableViewDataSource {

    var myRay : [Tabler] = []
    
    override init() {
        myRay.append(Tabler("My Most Productive Day", image: NSImage(named: "trophy.png")!))
        myRay.append(Tabler("Least Productive Day", image: NSImage(named: "el.png")!))
        myRay.append(Tabler("JPS Leaderboard", image: NSImage(named: "leader.png")!))
        myRay.append(Tabler("My Top 10 (Weekly)", image: NSImage(named: "graphup.png")!))
        myRay.append(Tabler("My Top 10 (Monthly)", image: NSImage(named: "yearly.png")!))
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
    
    @IBOutlet var QuickLook: NSButton!
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        if QuickLook.state == NSOnState {
            QuickLook.state = NSOffState //Turn off QuickLook button
        }
        print("Row: \(table.selectedRow)");
    }
}

class MyNSTableRowView: NSTableRowView {
    
    override var isEmphasized: Bool {
        set {}
        get {
            return false;
        }
    }
}

class Tabler: NSObject {
    var label : String
    var image : NSImage
    
    init(_ label: String, image: NSImage) {
        self.label = label
        self.image = image
    }
}