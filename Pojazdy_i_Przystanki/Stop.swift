//
//  Stop.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import CoreLocation
import Foundation
import ObjectMapper
import GoogleMaps

class Stop: NSObject, Mappable, GMUClusterItem {
    private (set) var id: Int
    private (set) var name: String?
    private (set) var latitude: Double
    private (set) var longitude: Double
    private (set) var setNumber: Int?
    private (set) var poleNumber: String?

    required init?(map: Map) {
        guard let id = map.JSON["id"] as? Int,
            let lat = map.JSON["szerokoscgeo"] as? Double,
            let lon = map.JSON["dlugoscgeo"] as? Double else {
            return nil
        }
        self.id = id
        self.latitude = lat
        self.longitude = lon
    }

    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["nazwa"]
        latitude    <- map["szerokoscgeo"]
        longitude   <- map["dlugoscgeo"]
        setNumber   <- map["nrzespolu"]
        poleNumber  <- map["nrslupka"]
    }

    var position: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

//http://www.zditm.szczecin.pl/json/tablica.inc.php?slupek=34111
//http://www.zditm.szczecin.pl/json/slupki.inc.php
