//
//  TimeEntry.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

public struct TimeEntry {
    
    var date: Date = Date()
    var project: String?
    var activity: String?
    var hours: Int?
    var comments: String?
    var status: String?
    var timeLogId: String?
    //var isUpdate: Bool = false
}
