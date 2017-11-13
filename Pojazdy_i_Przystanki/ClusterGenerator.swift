//
//  ClusterGenerator.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 12/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

final class ClusterGenerator {
    // swiftlint:disable line_length
    static var stopsIconGenerator: GMUDefaultClusterIconGenerator {
        return GMUDefaultClusterIconGenerator(buckets: [15, 20, 50, 100, 500],
                                              backgroundColors: [#colorLiteral(red: 0.6470588235, green: 0.7607843137, blue: 1, alpha: 1), #colorLiteral(red: 0.5215686275, green: 0.6705882353, blue: 1, alpha: 1), #colorLiteral(red: 0.2, green: 0.4549019608, blue: 1, alpha: 1), #colorLiteral(red: 0.2, green: 0.4549019608, blue: 1, alpha: 1), #colorLiteral(red: 0.03921568627, green: 0.3450980392, blue: 1, alpha: 1)])
    }

    static var vehicleIconGenerator: GMUDefaultClusterIconGenerator {
        return GMUDefaultClusterIconGenerator(buckets: [15, 20, 50, 100, 500],
                                              backgroundColors: [#colorLiteral(red: 0.4392156863, green: 0.7803921569, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 0.3098039216, green: 0.7294117647, blue: 0.3098039216, alpha: 1), #colorLiteral(red: 0.2470588235, green: 0.6352941176, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.2, green: 0.5176470588, blue: 0.2, alpha: 1), #colorLiteral(red: 0.1568627451, green: 0.4039215686, blue: 0.1568627451, alpha: 1)])
    }
    // swiftlint:enable line_length
}

//http://colllor.com
