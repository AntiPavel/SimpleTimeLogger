//
//  TimeLogCellViewModelImplementation.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct TimeLogCellViewModelImplementation: TimeLogCellViewModel {
    
    let project: String
    let activity: String
    let hours: String
    let status: String
    
    init(log: TimeLog) {
        self.project = log.project
        self.activity = log.activity
        self.hours = log.hours
        self.status = log.status
    }
}
