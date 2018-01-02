//
//  GeoJSON.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum GeoJSONType: String {
    case point              = "Point"
    case multiPoint         = "MultiPoint"
    case lineString         = "LineString"
    case multiLineString    = "MultiLineString"
    case polygon            = "Polygon"
    case multiPolygon       = "MultiPolygon"
    case geometryCollection = "GeometryCollection"
    case feature            = "Feature"
    case featureCollection  = "FeatureCollection"
    case unknown            = ""
}

public protocol GeoJSONDecodable {
    var prefix: String { get }
}

final class GeoJSON {
    var type: GeoJSONType = .unknown

    public var object: GeoJSONDecodable {
        get { return _object }
        set {
            _object = newValue
            switch newValue {
            case is Point:
                type = .point
            case is LineString:
                type = .lineString
            case is Feature:
                type = .feature
            case is FeatureCollection:
                type = .featureCollection
            default:
                _object = NSNull()
            }
        }
    }

    public init?(json: JSON) {
        guard let typeString = json["type"].string,
            let type = GeoJSONType(rawValue: typeString) else {
            return nil
        }

        let coordinatesField = json["coordinates"]

        switch type {
        case .point:
            object = Point(json: coordinatesField) ?? NSNull()
        case .lineString:
            object = LineString(json: coordinatesField) ?? NSNull()
        case .feature:
            object = Feature(json: json) ?? NSNull()
        case .featureCollection:
            object = FeatureCollection(json: json["features"]) ?? NSNull()
        default:
            return nil
        }

        if object is NSNull {
            self.type = .unknown
            return nil
        }
    }

    init() { }

    public var isGeometry: Bool {
        switch type {
        case .point, .multiPoint, .lineString, .multiLineString, .polygon, .multiPolygon, .geometryCollection:
            return true
        default:
            return false
        }
    }

    private var _object: GeoJSONDecodable = NSNull()
}

extension NSNull: GeoJSONDecodable {
    public var prefix: String { return "" }
}

