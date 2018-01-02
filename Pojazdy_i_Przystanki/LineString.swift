//
//  LineString.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import SwiftyJSON

final class LineString: GeoJSONDecodable {
    public var prefix: String { return "coordinates" }

    private (set) var points: [Point] = []

    public init?(json: JSON) {
        guard let jsonPoints = json.array, jsonPoints.count >= 2 else { return nil }
        for jsonPoint in jsonPoints {
            if let point = Point(json: jsonPoint) {
                points.append(point)
            } else {
                return nil
            }
        }
    }

    public init?(points: [Point]) {
        if points.count < 2 { return nil }
        self.points = points
    }

    public var pointCount: Int { return points.count }

    public subscript(index: Int) -> Point {
        get { return points[index] }
        set(newValue) { points[index] = newValue }
    }
}
 extension GeoJSON {
    public var lineString: LineString? {
        get {
            guard case GeoJSONType.lineString = self.type else { return nil }
            return object as? LineString
        } set {
            object = newValue ?? NSNull()
        }
    }
}

