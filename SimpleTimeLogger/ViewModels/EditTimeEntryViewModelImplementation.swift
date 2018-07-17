//
//  EditTimeEntryViewModelImplementation.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

struct EditTimeEntryViewModelImplementation: EditTimeEntryViewModel {
    
    public var timeEntry: TimeEntry
    
    private let writer: LogWriter
    private let timeLogFabric: TimeLogFabric
    
    init(writer: LogWriter, log: TimeLog?) {
        self.writer = writer
        timeLogFabric = TimeLogFabric()
        timeEntry = timeLogFabric.createTimeEntry(with: log)
    }
    
    public func saveLog() {
        writer.setLog(log: timeLogFabric.createTimeLog(with: timeEntry),
                      isUpdate: timeEntry.timeLogId != nil)
    }
}
