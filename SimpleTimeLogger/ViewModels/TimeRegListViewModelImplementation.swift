//
//  TimeRegListViewModelImplementation.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

struct TimeRegListViewModelImplementation: TimeRegistrationListViewModel {
    
    public var logs: Results<TimeLog>
    
    private let reader: LogReader
    
    init(reader: LogReader) {
        self.reader = reader
        self.logs = reader.getLogs()
    }
    
    public mutating func updateLogsWithDates(startDate: Date, endDate: Date) {
        self.logs = reader
            .getLogs()
            .filter(NSPredicate(format: "date >=  %@ AND date <=  %@",
                                argumentArray: [startDate, endDate]))
    }
}
