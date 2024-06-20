//
//  Item.swift
//  GeoLocationE2
//
//  Created by Kadeem Cherman on 2024-06-19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
