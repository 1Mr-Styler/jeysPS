//
//  jSQL.swift
//  JPS
//
//  Created by Jerry U. on 6/29/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import GRDB

class jSQL: NSObject {
    let dbQueue : DatabaseQueue?

    override init() {
        do {
            dbQueue = try DatabaseQueue(path: "/Users/mac/Downloads/temp.db")
        } catch {
            dbQueue = nil
        }
    }

    func execute(_ sql: String, arguements args: StatementArguments? = nil) -> (RowID: Int64?, Err: Error?) {
        var rowID: Int64?
        var Err: Error?

        do {
            try dbQueue?.inDatabase { db in

                try db.execute(sql, arguments: args)

                rowID = db.lastInsertedRowID
            }
        } catch {
            Err = error
        }
        return (rowID, Err)
    }

    func saveWYD() {
        do {
            try dbQueue?.inDatabase { db in
                var WYDset = WYD(id: Int64(Date().timeIntervalSince1970), from: "123023", to: "1000", activity: "sleeping")
                try WYDset.insert(db)
            }
        } catch {
            print("\n\t<---------------------------->\(error)")
        }
    }

}

struct WYD : MutablePersistable {
    /// The name of the database table
    static var databaseTableName = "wyd"

    var id: Int64
    var from: String
    var to: String
    var activity: String

    /// The values persisted in the database
    var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
                "id": id,
                "from": from,
                "to": to,
                "activity": activity
        ]
    }

    // Update id upon successful insertion:
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension WYD : RowConvertible {
    init(row: Row) {
        id = row.value(named: "id")
        from = row.value(named: "from")
        to = row.value(named: "to")
        activity = row.value(named: "activity")
    }

}
