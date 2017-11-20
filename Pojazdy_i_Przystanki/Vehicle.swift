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

    private enum VehicleKeys: String, Iterable {
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
        if let id = map[VehicleKeys.id.rawValue].currentValue as? String,
            let line = map[VehicleKeys.line.rawValue].currentValue as? String,
            let lineType = LineType(with: map[VehicleKeys.lineType.rawValue].currentValue),
            let route = map[VehicleKeys.route.rawValue].currentValue as? String,
            let routeInt = Int(route),
            let nextStop = map[VehicleKeys.nextStop.rawValue].currentValue as? String,
            let previousStop = map[VehicleKeys.previousStop.rawValue].currentValue as? String,
            let latitude = map[VehicleKeys.latitude.rawValue].currentValue as? String,
            let latDouble = Double(latitude),
            let longitude = map[VehicleKeys.longitude.rawValue].currentValue as? String,
            let lonDouble = Double(longitude),
            let punctuality1 = map[VehicleKeys.punctuality1.rawValue].currentValue as? String,
            let gmvid = map[VehicleKeys.gmvid.rawValue].currentValue as? Int {
            self.id = id
            self.line = line
            self.lineType = lineType
            self.route = routeInt
            self.nextStop = nextStop.isEmpty ? "n/a" : nextStop
            self.previousStop = previousStop.isEmpty ? "n/a" : previousStop
            self.coordinate = (latDouble, lonDouble)
            self.punctuality = (punctuality1, 0)
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
}

//http://www.zditm.szczecin.pl/json/pojazdy.inc.php
