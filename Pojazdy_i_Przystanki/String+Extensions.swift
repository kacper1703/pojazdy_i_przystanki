//
//  String+Extensions.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 27/12/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
