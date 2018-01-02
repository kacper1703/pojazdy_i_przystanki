//
//  RoutesCollection.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 27/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

class RoutesCollection {
    init?(with geoJson: GeoJSON) {
        guard let features = geoJson.featureCollection?.features else { return nil }
        let routes = features.flatMap({ Route(with: $0.feature?.geometry) })
        guard !routes.isEmpty else { return nil }
        self.routes = routes
    }
    private (set) var routes: [Route] = []
}
