//
//  EditTimeEntryViewModel.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import RealmSwift

public protocol EditTimeEntryViewModel {
    
    var timeEntry: TimeEntry { get set }
    
    func saveLog()
}
