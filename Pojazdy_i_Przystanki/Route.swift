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

typealias DepartureInfo = (line: String, heading: String, time: String)

class StopDepartures: NSObject {
    private (set) var departures: [DepartureInfo]?
    private (set) var error: String?

    init(with string: String) {
        let cleanedText = string.replacingOccurrences(of: "&nbsp;", with: " ")
        guard let body = cleanedText.slice(from: "<tbody>", to: "</tbody>") else { return }
        let departuresStringArray = body.components(separatedBy: "<tr>")
        let departuresArray = departuresStringArray.flatMap { (element) -> (String, String, String)? in
            guard let line = element.slice(from: "\"gmvlinia\">", to: "</td>"),
                let heading = element.slice(from: "\"gmvkierunek\">", to: "</td>"),
                let time = element.slice(from: "\"gmvgodzina\">", to: "</td>") else { return nil }
            return (line, heading, time)
        }
        self.error = departuresStringArray.first?.slice(from: "gmvblad\">", to: "</td>")
        self.departures = departuresArray
    }

    required init?(map: Map) {
        return nil
    }

    func mapping(map: Map) {

//        coordinates <- map["coordinates"]
    }
}

//class Routes: NSObject, Mappable {
//    private (set) var coordinates: [CLLocationCoordinate2D]
//
//    required init?(map: Map) {
//        <#code#>
//    }
//
//    func mapping(map: Map) {
//        coordinates <- map["coordinates"]
//    }
//}

extension String {

    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

