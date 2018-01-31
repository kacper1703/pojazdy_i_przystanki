//
//  Map+Extensions.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 30/01/2018.
//  Copyright © 2018 Kacper Czapp. All rights reserved.
//

import ObjectMapper

extension Map {
    var stringValue: String? {
        return self.currentValue as? String
    }
}
