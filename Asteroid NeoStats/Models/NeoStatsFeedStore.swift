//
//  NeoStatsFeedStore.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import Foundation
import Combine

fileprivate let NASA_API_KEY = "8nmMKf89ZDgC3K4QvVJGHK1rvl8MUvaeNRFVlXdh"

fileprivate let kNeoStatsFeedUrl = "https://api.nasa.gov/neo/rest/v1/feed"

final class NeoStatsFeedStore {
    // MARK: - Lifecycle
    
    private init() { }
    
    static let shared = NeoStatsFeedStore()
    
    // MARK: - Properties
    
    @Published var state: StoreState = .idle
    
    private var observer: AnyCancellable?
    
    // MARK: - Commands
    
    func fetchFeed(_ startDate: String, _ endDate: String? = nil) {
        switch state {
        case .loading: return // don't fetch anything if we're already loading
        default: break
        }
        
        var urlString = "\(kNeoStatsFeedUrl)?start_date=\(startDate)"
        if let endDate = endDate {
            urlString.append("&end_date=\(endDate)")
        }
        urlString.append("&api_key=\(NASA_API_KEY)")
        
        guard let url = URL(string: urlString) else { return }
        
        state.toLoading()
        observer = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { comp in
                switch comp {
                case .failure(let error):
                    print("ERROR: \(error)")
                    self.state.toError(error)
                case .finished: break
                }
            }, receiveValue: { self.decodeResult($0.data) })
    }
    
    // MARK: - Methods
    
    private func decodeResult(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(NeoFeedResult.self, from: data)
            state.toLoaded(result)
        } catch {
            state.toError(error)
        }
    }
}

// MARK: - State

extension NeoStatsFeedStore {
    
    enum StoreState {
        case idle
        case loading
        case loaded(NeoFeedResult)
        case error(Error)
    }
}

// MARK: - State - Queries

extension NeoStatsFeedStore.StoreState {
    
    var feedResult: NeoFeedResult? {
        switch self {
        case .loaded(let feedResult): return feedResult
        default: return nil
        }
    }
}

// MARK: - State - Commands

extension NeoStatsFeedStore.StoreState {
    
    mutating func toIdle() {
        self = .idle
    }
    
    mutating func toLoading() {
        self = .loading
    }
    
    mutating func toLoaded(_ feedResult: NeoFeedResult) {
        self = .loaded(feedResult)
    }
    
    mutating func toError(_ error: Error) {
        self = .error(error)
    }
}
