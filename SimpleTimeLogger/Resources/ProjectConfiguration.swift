//
//  ProjectConfiguration.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

public let projects = ["Fly to Mars",
                "Colonization of the Moon",
                "Google for aliens",
                "Piter Pen project",
                "Olympic games"]

public let activities = ["Deep diving",
                         "Dreaming", "Singing in shower",
                         "Walking with dog",
                         "Playing chess",
                         "Coding the matrix",
                         "Computing the hash of the Universe"]

public enum Status: String {
    case approved = "Approved"
    case notApproved = "Not Approved"
}

// fill some test logs for filtering

struct TestLogsFiller {
    var realm: Realm?
    
    func setTestLogs() {
        guard let realm = realm else { return }
        let storage: ReaderWriter = RealmStorageService(realm: realm)
        for _ in 0...20 {
            let timeLog = TimeLog()
            timeLog.date = Calendar.current.date(byAdding: .year, value: -Int(arc4random_uniform(10)), to: Date())!
            timeLog.project = projects[Int(arc4random_uniform(UInt32(projects.count)))]
            timeLog.activity = activities[Int(arc4random_uniform(UInt32(activities.count)))]
            timeLog.hours = String(arc4random_uniform(50))
            storage.setLog(log: timeLog, isUpdate: false)
        }
    }
    
    
}
