//
//  TimeLogCellViewModel.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

public protocol TimeLogCellViewModel {
    
    var project: String { get }
    var activity: String { get }
    var hours: Int { get }
    var status: String { get }
}
