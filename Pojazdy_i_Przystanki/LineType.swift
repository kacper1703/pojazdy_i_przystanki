//
//  LineType.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import ObjectMapper

enum LineType: String {
    case busNormal = "adz"
    case busExpedited = "adp"
    case tramNormal = "tdz"
    case busNight = "????"
    case temporary = "ada"

    init?(with value: Any?) {
        if let value = value as? String {
            self.init(rawValue: value)
        } else {
            return nil
        }
    }
}
