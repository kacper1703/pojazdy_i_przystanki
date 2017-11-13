//
//  Bundle+LoadFromNib.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

extension Bundle {
    static func loadViewFromNib<T>(withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}
