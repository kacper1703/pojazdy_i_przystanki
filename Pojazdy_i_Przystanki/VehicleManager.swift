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
import SwiftyJSON
import MapKit

protocol VehiclesManagerDelegate: class {
    func manager(manager: VehiclesManager, didSet vehicles: [Vehicle])
    func manager(manager: VehiclesManager, didFailWith error: Error)
    func manager(manager: VehiclesManager, didDownload routesCollection: RoutesCollection)
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
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 20,
                                              target: self,
                                              selector: #selector(download),
                                              userInfo: nil,
                                              repeats: true)
            download()
        }
    }

    func allLines() -> [String] {
        var lines: [String] = vehicles.map({ $0.line })
        return lines.removingDuplicates.sorted()
    }

    func pause() {
        self.timer?.invalidate()
        self.timer = nil
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
        Alamofire.request(url).validate().responseArray { (response: DataResponse<[Vehicle]>) in
            if let error = response.error {
                self.delegate?.manager(manager: self, didFailWith: error)
                return
            }
            if let vehiclesArray = response.result.value {
                self.vehicles = vehiclesArray
            }
        }
    }

    func getRouteFor(gmvid: String) {
        let url = "http://www.zditm.szczecin.pl/json/trasy.inc.php?gmvid=\(gmvid)"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let geoJson = GeoJSON(json: json), let routes = RoutesCollection(with: geoJson) {
                    self.delegate?.manager(manager: self, didDownload: routes)
                }
            case .failure(let error):
                self.delegate?.manager(manager: self, didFailWith: error)
            }
        }
    }
}

extension Array where Element:Equatable {
    var removingDuplicates: [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
