//
//  PunctualityLabel.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 16/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit

class PunctualityLabel: UILabel {

    var punctuality: Int? {
        didSet {
            guard let punctuality = punctuality else {
                self.text = "-"
                self.textColor = .black
                return
            }
            let textColor: UIColor

            switch punctuality {
            case 0:
                textColor = UIColor.green
            case let x where x > 0:
                textColor = UIColor.blue
            case let x where x < 0:
                textColor = UIColor.red
            default:
                return
            }

            self.text = String(punctuality)
            self.textColor = textColor
        }
    }
}
