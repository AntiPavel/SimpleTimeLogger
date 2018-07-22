//
//  TimeLog.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

final public class TimeLog: Object {

    @objc dynamic var date: Date = Date()
    @objc dynamic var project: String = ""
    @objc dynamic var activity: String = ""
    @objc dynamic var hours: String = ""
    @objc dynamic var comments: String = ""
    @objc dynamic var status: String = Status.notApproved.rawValue
    @objc dynamic var timeLogId: String = "\(UUID().uuidString)\(Date().timeIntervalSince1970))"

    override public static func primaryKey() -> String? {
        return "timeLogId"
    }
}
