//
//  Breach.swift
//  Breaches
//
//  Created by Robert Ryan on 4/18/19.
//  Copyright © 2019 Robert Ryan. All rights reserved.
//

import Foundation

struct Breach: Codable {
    let name: String
    let title: String
    let domain: String
    var breachDate: Date? { return Breach.dateOnlyFormatter.date(from: breachDateString) }
    let breachDateString: String
    let addedDate: Date
    let modifiedDate: Date
    let pwnCount: Int
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case title = "Title"
        case domain = "Domain"
        case breachDateString = "BreachDate"
        case addedDate = "AddedDate"
        case modifiedDate = "ModifiedDate"
        case pwnCount = "PwnCount"
        case description = "Description"
    }
    
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension RandomAccessCollection where Element == Breach {
    func sortedByName() -> [Breach] {
        return sorted { breach1, breach2 in
            breach1.name.caseInsensitiveCompare(breach2.name) == .orderedAscending
        }
    }
}
