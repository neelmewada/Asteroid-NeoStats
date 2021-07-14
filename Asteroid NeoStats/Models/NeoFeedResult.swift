//
//  NeoFeedResult.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import Foundation

struct NeoFeedResult: Codable {
    var elementCount: Int
    var nearEarthObjects: [String: [NearEarthObjectModel]] // format: [Date: NEO Array]
}

