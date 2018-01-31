//
//  Vehicle.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import MapKit
import ObjectMapper
import GoogleMaps

class Vehicle: NSObject, Mappable, GMUClusterItem {
    private (set) var id: String
    private (set) var line: String
    private (set) var lineType: LineType
    private (set) var route: Int
    private (set) var nextStop: String
    private (set) var previousStop: String
    private (set) var coordinate: (latitude: Double, longitude: Double) = (0, 0)
    private (set) var punctuality: (description: String, amount: Int) = ("", 0)
    private (set) var gmvid: Int

    var position: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    var shortDescription: String {
        switch self.punctuality.amount {
        case 0:
            return "0"
        case let a where a > 0:
            return "+\(a)"
        case let a where a < 0:
            return "-\(a)"
        default:
            return ""
        }
    }

    private enum VehicleKeys: String {
        case id = "id"
        case line = "linia"
        case lineType = "typlinii"
        case route = "trasa"
        case nextStop = "do"
        case previousStop = "z"
        case latitude = "lat"
        case longitude = "lon"
        case punctuality1 = "punktualnosc1"
        case punctuality2 = "punktualnosc2"
        case gmvid = "gmvid"
    }

    required init?(map: Map) {
        if let id = map[VehicleKeys.id.rawValue].stringValue,
            let line = map[VehicleKeys.line.rawValue].stringValue,
            let lineType = LineType(with: map[VehicleKeys.lineType.rawValue].currentValue),
            let route = map[VehicleKeys.route.rawValue].stringValue,
            let routeInt = Int(route),
            let nextStop = map[VehicleKeys.nextStop.rawValue].stringValue,
            let previousStop = map[VehicleKeys.previousStop.rawValue].stringValue,
            let latitude = map[VehicleKeys.latitude.rawValue].stringValue,
            let latDouble = Double(latitude),
            let longitude = map[VehicleKeys.longitude.rawValue].stringValue,
            let lonDouble = Double(longitude),
            let punctuality1 = map[VehicleKeys.punctuality1.rawValue].stringValue,
            let punctuality2 = Vehicle.punctuality(from: map[VehicleKeys.punctuality2.rawValue].currentValue),
            let gmvid = map[VehicleKeys.gmvid.rawValue].currentValue as? Int {
            self.id = id
            self.line = line
            self.lineType = lineType
            self.route = routeInt
            self.nextStop = nextStop.isEmpty ? "n/a" : nextStop
            self.previousStop = previousStop.isEmpty ? "n/a" : previousStop
            self.coordinate = (latDouble, lonDouble)
            self.punctuality = (punctuality1, punctuality2)
            self.gmvid = gmvid
        } else {
            return nil
        }
    }

    func mapping(map: Map) {
        id                      <- map[VehicleKeys.id.rawValue]
        line                    <- map[VehicleKeys.line.rawValue]
        lineType                <- (map[VehicleKeys.lineType.rawValue], TransformOf<LineType, String> (fromJSON: { if let raw = $0 {
                                                                                                                        return LineType(rawValue: raw)
                                                                                                                  }
                                                                                                                  return nil },
                                                                                                        toJSON: { $0.map { $0.rawValue }}))
        route                   <- map[VehicleKeys.route.rawValue]
        nextStop                <- map[VehicleKeys.nextStop.rawValue]
        previousStop            <- map[VehicleKeys.previousStop.rawValue]
        coordinate.latitude     <- map[VehicleKeys.latitude.rawValue]
        coordinate.longitude    <- map[VehicleKeys.longitude.rawValue]
        punctuality.description <- map[VehicleKeys.punctuality1.rawValue]
        punctuality.amount      <- map[VehicleKeys.punctuality2.rawValue]
        gmvid                   <- map[VehicleKeys.gmvid.rawValue]
    }

    var icon: UIImage {
        switch self.lineType {
        case .busExpedited: return Asset.busExp.image
        case .busNight: return Asset.busNight.image
        case .busNormal: return Asset.busNorm.image
        case .tramNormal: return Asset.tramNormal.image
        case .temporary: return Asset.busTemp.image
        }
    }

    var lineColor: UIColor {
        switch self.lineType {
        case .busExpedited: return UIColor(red:0.9882, green:0.0510, blue:0.1059, alpha:1.0000)
        case .busNight: return UIColor.white
        case .busNormal: return UIColor(red:0.5137, green:0.7294, blue:0.1373, alpha:1.0000)
        case .tramNormal: return UIColor(red:0.0980, green:0.6157, blue:0.8549, alpha:1.0000)
        case .temporary: return UIColor(red:0.9922, green:0.7686, blue:0.2314, alpha:1.0000)
        }
    }

    var annotationColors: (backgroundColor: UIColor, textColor: UIColor) {
        if self.lineType == .busNight {
            return (.black, lineColor)
        } else {
            return (.white, lineColor)
        }
    }

    func update(with map: Map) {
        if let nextStop = map[VehicleKeys.nextStop.rawValue].stringValue,
        let previousStop = map[VehicleKeys.previousStop.rawValue].stringValue,
        let latitude = map[VehicleKeys.latitude.rawValue].stringValue,
        let latDouble = Double(latitude),
        let longitude = map[VehicleKeys.longitude.rawValue].stringValue,
        let lonDouble = Double(longitude),
        let punctuality1 = map[VehicleKeys.punctuality1.rawValue].stringValue,
            let punctuality2 = Vehicle.punctuality(from: map[VehicleKeys.punctuality2.rawValue].currentValue) {
            self.nextStop = nextStop
            self.previousStop = previousStop
            self.coordinate = (latDouble, lonDouble)
            self.punctuality = (punctuality1, punctuality2)
        }
    }

    static private func punctuality(from value: Any?) -> Int? {
        guard let string = value as? String else { return nil }

        if string.contains("&plus;") {
            return Int(string.replacingOccurrences(of: "&plus;", with: ""))
        } else if string.contains("&minus;") {
            return Int(string.replacingOccurrences(of: "&minus;", with: ""))
        } else {
            return Int(string)
        }
    }
}

//http://www.zditm.szczecin.pl/json/pojazdy.inc.php
