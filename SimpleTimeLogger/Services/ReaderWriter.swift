//
//  ReaderWriter.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/16/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

typealias ReaderWriter = LogWriter & LogReader

public protocol LogWriter {
    func setLog(log: TimeLog, isUpdate: Bool)
}


public protocol LogReader {
    func getLogs(startDate: Date, endDate: Date ) -> Results<TimeLog>
}




extension LogWriter {
    func setLog(log: TimeLog, isUpdate: Bool = false) {
        return setLog(log: log, isUpdate: isUpdate)
    }
}


extension LogReader {
    func getLogs(startDate: Date = Date.distantPast, endDate: Date = Date()) -> Results<TimeLog> {
        return getLogs(startDate: startDate, endDate: endDate)
    }
}
