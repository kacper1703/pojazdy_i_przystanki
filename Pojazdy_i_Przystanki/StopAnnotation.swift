//
//  StopAnnotation.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

class StopAnnotation: NSObject, AnnotationWithImage {
    var id: Int
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var reuseIdentifier: String {
        return "stop\(id)"
    }

    init?(with stop: Stop) {
        self.id = stop.id
        self.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        self.title = stop.name
        self.image = Asset.stop.image
            self.subtitle = "\(stop.setNumber)\(stop.poleNumber)"
    }
}
