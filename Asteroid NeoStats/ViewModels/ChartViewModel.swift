//
//  ChartViewModel.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import Foundation
import Combine

class ChartViewModel {
    // MARK: - Lifecycle
    
    typealias ViewState = ChartViewController.ViewState
    typealias ViewDelegate = ChartViewModelViewDelegate
    
    init() {
        
    }
    
    // MARK: - Properties
    
    private(set) var state: ViewState = .init() {
        didSet {
            viewDelegate?.render(state: state)
        }
    }
    
    weak var viewDelegate: ViewDelegate?
    
    var observer: AnyCancellable?
    
    private var startDate = Date()
    private var endDate = Date()
    
    // MARK: - Commands / Events
    
    func viewDidLoad() {
        state = .init() // set default viewstate on load
    }
    
    func viewWillAppear() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        startDate = state.startDate
        endDate = state.endDate
        
        observer = NeoStatsFeedStore.shared.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .idle: print("idle")
                case .loading: self.state.isLoading = true
                case .error(let error): self.state.isLoading = false; print("ERROR: \(error)")
                case .loaded(let result): self.toLoaded(result, self.startDate, self.endDate)
                }
            })
        
        NeoStatsFeedStore.shared.fetchFeed(dateFormatter.string(from: startDate), dateFormatter.string(from: endDate))
    }
    
    func viewWillDisappear() {
        observer?.cancel()
    }
    
    func viewDidApplyFilters(_ startDate: Date, _ endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDate = startDate
        self.endDate = endDate
        NeoStatsFeedStore.shared.fetchFeed(dateFormatter.string(from: startDate), dateFormatter.string(from: endDate))
    }
    
    // MARK: - Private Methods
    
    private func toLoaded(_ result: NeoFeedResult, _ startDate: Date, _ endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDay = Calendar.current.dateComponents([.day], from: startDate).day!
        let endDay = Calendar.current.dateComponents([.day], from: endDate).day!
        
        var asteroidsPerDay = [Int]()
        
        for i in 0...(endDay - startDay) {
            let currentDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            if let asteroids = result.nearEarthObjects[dateFormatter.string(from: currentDate)] {
                asteroidsPerDay.append(asteroids.count)
            } else {
                asteroidsPerDay.append(0)
            }
        }
        
        var maxSpeed = Double(0)
        var maxSpeedAsteroid = ""
        
        var closestAsteroidDistance = Double(0)
        var closestAsteroidName = ""
        var averageAsteroidSize = Double(0)
        var totalAsteroids = Double(0)
        
        for (_, asteroids) in result.nearEarthObjects {
            for asteroid in asteroids {
                let speed = Double(asteroid.closeApproachData[0].relativeVelocity.kilometersPerHour)!
                if speed > maxSpeed {
                    maxSpeed = speed
                    maxSpeedAsteroid = asteroid.name
                }
                averageAsteroidSize += asteroid.estimatedDiameter.kilometers.average
                
                for approachData in asteroid.closeApproachData {
                    let distance = Double(approachData.missDistance.kilometers)!
                    if distance > closestAsteroidDistance {
                        closestAsteroidDistance = distance
                        closestAsteroidName = asteroid.name
                    }
                }
                totalAsteroids += 1
            }
        }
        
        averageAsteroidSize /= totalAsteroids
        
        state = ViewState(startDate: startDate,
                          endDate: endDate,
                          asteroidsPerDay: asteroidsPerDay,
                          fastestAsteroidName: maxSpeedAsteroid,
                          fastestAsteroidSpeed: maxSpeed,
                          closestAsteroidName: closestAsteroidName,
                          closestAsteroidDistance: closestAsteroidDistance,
                          averageAsteroidSize: averageAsteroidSize,
                          isLoading: false)
    }
}

protocol ChartViewModelViewDelegate: AnyObject {
    typealias ViewState = ChartViewController.ViewState
    
    func render(state: ViewState)
}
