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
    var estimatedDiameter: EstimatedDiameterDimensions
    var isPotentiallyHazardousAsteroid: Bool
    var isSentryObject: Bool
    var closeApproachData: [CloseApproachData]
}

struct EstimatedDiameterDimensions: Codable {
    var kilometers: EstimatedDiameter
    var meters: EstimatedDiameter
    var miles: EstimatedDiameter
    var feet: EstimatedDiameter
}

struct EstimatedDiameter: Codable {
    var estimatedDiameterMin: Double
    var estimatedDiameterMax: Double
    
    var average: Double { (estimatedDiameterMin + estimatedDiameterMax) / 2.0 }
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
