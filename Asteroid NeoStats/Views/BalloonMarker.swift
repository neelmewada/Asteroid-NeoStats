//
//  BalloonMarker.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import UIKit
import Charts

class BalloonMarker: MarkerView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Configuration
    
    private func configure() {
        self.clipsToBounds = true
        self.backgroundColor = .red
        self.layer.cornerRadius = bounds.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.height / 2
    }
}

