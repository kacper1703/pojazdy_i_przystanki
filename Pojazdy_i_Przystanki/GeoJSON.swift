//
//  GeoJSON.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 25/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//



import Foundation

class Point {
    public init?(json: JSON) {
        if let jsonCoordinates =  json.array {
            if jsonCoordinates.count < 2 { return nil }

            _coordinates = jsonCoordinates.map {
                Double($0.doubleValue)
            }
        }
        else {
            return nil
        }
    }
}
