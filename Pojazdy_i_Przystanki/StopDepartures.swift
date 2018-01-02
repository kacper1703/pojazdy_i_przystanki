//
//  StopDepartures.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 27/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

typealias DepartureInfo = (line: String, heading: String, time: String)

class StopDepartures: NSObject {
    private (set) var departures: [DepartureInfo]?
    private (set) var error: String?

    init(with string: String) {
        let cleanedText = string.replacingOccurrences(of: "&nbsp;", with: " ")
        guard let body = cleanedText.slice(from: "<tbody>", to: "</tbody>") else { return }
        let departuresStringArray = body.components(separatedBy: "<tr>")
        self.error = departuresStringArray.first?.slice(from: "gmvblad\">", to: "</td>")
        let departuresArray = departuresStringArray.flatMap { (element) -> (String, String, String)? in
            guard let line = element.slice(from: "\"gmvlinia\">", to: "</td>"),
                let heading = element.slice(from: "\"gmvkierunek\">", to: "</td>"),
                let time = element.slice(from: "\"gmvgodzina\">", to: "</td>") else { return nil }
            return (line, heading, time)
        }
        self.departures = departuresArray
    }
}
