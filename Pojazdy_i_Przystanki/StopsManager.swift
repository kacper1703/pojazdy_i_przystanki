//
//  StopsManager.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import GoogleMaps

protocol StopsManagerDelegate: class {
    func manager(manager: StopsManager, didSet stops: [Stop])
    func manager(manager: StopsManager, didFailWith error: Error)
}

class StopsManager {
    weak var delegate: StopsManagerDelegate?

    init(withDelegate delegate: StopsManagerDelegate) {
        self.delegate = delegate
    }

    var stops: [Stop] = [] {
        didSet {
            delegate?.manager(manager: self, didSet: stops)
        }
    }

    func start() {
        let url = "http://www.zditm.szczecin.pl/json/slupki.inc.php"
        Alamofire.request(url).responseArray { (response: DataResponse<[Stop]>) in
            if let error = response.error {
                self.delegate?.manager(manager: self, didFailWith: error)
                return
            }
            if let stopsArray = response.result.value {
                self.stops = stopsArray
            }
        }
    }

    var markers: [GMSMarker] {
        return self.stops.map({ (stop) -> GMSMarker in
            let marker = GMSMarker()
            marker.position = stop.position
            marker.title = stop.name
            marker.snippet = stop.name
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
            marker.icon = Asset.stop.image
            return marker
        })
    }
}
