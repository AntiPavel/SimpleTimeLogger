//
//  TimeLogFactory.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct TimeLogFactory {
    
    func createTimeEntry(with timeLog: TimeLog?) -> TimeEntry {
        
        guard let log = timeLog else {
            return TimeEntry()
        }
        
        return TimeEntry(date: log.date,
                         project: log.project,
                         activity: log.activity,
                         hours: log.hours,
                         comments: log.comments,
                         status: log.status,
                         timeLogId: log.timeLogId)
    }
    
    func createTimeLog(with timeEntry: TimeEntry) -> TimeLog {
        
        let log = TimeLog()
        log.date = timeEntry.date
        log.project = timeEntry.project ?? log.project
        log.activity = timeEntry.activity ?? log.activity
        log.hours = timeEntry.hours ?? log.hours
        log.comments = timeEntry.comments ?? log.comments
        log.status = timeEntry.status ?? log.status
        log.timeLogId = timeEntry.timeLogId ?? log.timeLogId
        
        return log
    }
}
