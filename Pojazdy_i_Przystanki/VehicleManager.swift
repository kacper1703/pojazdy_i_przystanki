//
//  VehicleManager.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import MapKit

protocol VehiclesManagerDelegate: class {
    func manager(manager: VehiclesManager, didSet vehicles: [Vehicle])
    func manager(manager: VehiclesManager, didFailWith error: Error)
}

class VehiclesManager {

    weak var delegate: VehiclesManagerDelegate?
    var timer: Timer?

    init(withDelegate delegate: VehiclesManagerDelegate) {
        self.delegate = delegate
    }

    private var vehicles: [Vehicle] = [] {
        didSet {
            delegate?.manager(manager: self, didSet: vehicles)
        }
    }

    func vehicle(withIdentifier identifier: String?) -> Vehicle? {
        guard let identifier = identifier else {
            return nil
        }
        return vehicles.filter({ $0.id == identifier }).first
    }

    func vehicles(withLineNumber lineNumber: String) -> [Vehicle] {
        return vehicles.filter({ $0.line == lineNumber })
    }

    func vehicles(withLineNumbers lineNumbers: [String]) -> [Vehicle] {
        var list: [Vehicle] = []
        for number in lineNumbers {
            list.append(contentsOf: vehicles(withLineNumber: number))
        }
        return list
    }

    func start() {
        self.timer = Timer.scheduledTimer(timeInterval: 20,
                                          target: self,
                                          selector: #selector(download),
                                          userInfo: nil,
                                          repeats: true)
        download()
    }

    func allLines() -> [String] {
        var lines: [String] = []
        for vehicle in vehicles {
            if lines.contains(vehicle.line) {
                lines.append(vehicle.line)
            }
        }
        return lines
    }

    var markers: [GMSMarker] {
        return self.vehicles.map({ (vehicle) -> GMSMarker in
            let marker = GMSMarker()
            marker.position = vehicle.position
            marker.title = vehicle.line
            marker.snippet = vehicle.punctuality.description
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
            marker.icon = vehicle.icon
            return marker
        })
    }

    @objc private func download() {
        let url = "http://www.zditm.szczecin.pl/json/pojazdy.inc.php"
        Alamofire.request(url).responseArray { (response: DataResponse<[Vehicle]>) in
            if let error = response.error {
                self.delegate?.manager(manager: self, didFailWith: error)
                return
            }
            if let vehiclesArray = response.result.value {
                self.vehicles = vehiclesArray
            }
        }
    }
}
