//
//  Point.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Point: GeoJSONDecodable {
    private (set) var coordinates: [Double] = [0.0, 0.0]

    public init?(json: JSON) {
        guard let jsonArray = json.array, jsonArray.count >= 2 else { return nil }
        coordinates = jsonArray.map { $0.doubleValue }
    }

    public var prefix: String { return "coordinates" }

    public var latitude: Double { return coordinates[1] }
    public var longitude: Double { return coordinates[0] }

    public var clLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    public subscript(index: Int) -> Double {
        get { return coordinates[index] }
        set(newValue) { coordinates[index] = newValue }
    }
}

extension GeoJSON {
    public var point: Point? {
        guard case GeoJSONType.point = self.type else { return nil }
        return object as? Point
    }
}
