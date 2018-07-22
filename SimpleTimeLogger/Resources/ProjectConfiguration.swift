//
//  ProjectConfiguration.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

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
