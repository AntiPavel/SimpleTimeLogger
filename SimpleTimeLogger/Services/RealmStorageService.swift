//
//  RealmStorageService.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/15/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

final public class RealmStorageService: LogReader, LogWriter  {
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    public func setLog(log: TimeLog, isUpdate: Bool) {
        try? realm.write { realm.add(log, update: isUpdate) }
    }
    
    public func getLogs(startDate: Date, endDate: Date) -> Results<TimeLog> {
        return realm.objects(TimeLog.self)
    }
}
