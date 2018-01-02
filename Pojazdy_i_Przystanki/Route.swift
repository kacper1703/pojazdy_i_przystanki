//
//  Route.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 16/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation
import GoogleMaps

class Route {
    init?(with geoJson: GeoJSON?) {
        guard let geoJson = geoJson else { return nil }
        guard let points: [Point] = geoJson.lineString?.points else { return nil }
        guard !points.isEmpty else { return nil }
        self.coordinates = points.map({ $0.clLocationCoordinate })
    }
    let coordinates: [CLLocationCoordinate2D]
    var start: CLLocationCoordinate2D { return coordinates.first! }
    var end: CLLocationCoordinate2D { return coordinates.last! }
    var polyline: GMSPolyline {
        let path = GMSMutablePath()
        for coordinate in coordinates {
            path.add(coordinate)
        }
        return GMSPolyline(path: path)
    }
    var polylineReversed: GMSPolyline {
        let path = GMSMutablePath()
        for coordinate in coordinates.reversed() {
            path.add(coordinate)
        }
        return GMSPolyline(path: path)
    }
}
