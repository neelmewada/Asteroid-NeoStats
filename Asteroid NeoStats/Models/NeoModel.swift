//
//  NearEarthObjectModel.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import Foundation

/// Model struct used to represent a single Near Earth Object from NASA's API
struct NearEarthObjectModel: Codable {
    let id: String
    var neoReferenceId: String
    var name: String
    var nasaJplUrl: String
    var absoluteMagnitudeH: Double
    var estimatedDiameter: [Dimension: EstimatedDiameter]
    var isPotentiallyHazardousAsteroid: Bool
    var isSentryObject: Bool
    var closeApproachData: [CloseApproachData]
}

struct EstimatedDiameter: Codable {
    var estimatedDiameterMin: Double
    var estimatedDiameterMax: Double
}

enum Dimension: String, Codable {
    case kilometers
    case meters
    case miles
    case feet
}

struct CloseApproachData: Codable {
    var closeApproachDate: String
    var closeApproachDateFull: String
    var epochDateCloseApproach: UInt64
    var relativeVelocity: Velocity
    var missDistance: Distance
    var orbitingBody: String
}

struct Velocity: Codable {
    var kilometersPerSecond: String
    var kilometersPerHour: String
    var milesPerHour: String
}

struct Distance: Codable {
    var astronomical: String
    var lunar: String
    var kilometers: String
    var miles: String
}
