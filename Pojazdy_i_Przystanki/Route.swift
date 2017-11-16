//
//  Route.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 16/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Alamofire
import CoreLocation
import ObjectMapper
import Foundation
import GoogleMaps

class Routes: NSObject, Mappable {
    private (set) var coordinates: [CLLocationCoordinate2D]

    required init?(map: Map) {
        <#code#>
    }

    func mapping(map: Map) {
        coordinates <- map["coordinates"]
    }
}

class Routes: NSObject, Mappable {
    private (set) var coordinates: [CLLocationCoordinate2D]

    required init?(map: Map) {
        <#code#>
    }

    func mapping(map: Map) {
        coordinates <- map["coordinates"]
    }
}
