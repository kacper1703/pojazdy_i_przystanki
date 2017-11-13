//
//  VehicleAnnotation.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

protocol AnnotationWithImage {
    var image: UIImage? { get set }
    var reuseIdentifier: String { get }
}

class VehicleAnnotation: NSObject, AnnotationWithImage {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var reuseIdentifier: String {
        return "vehicle\(id)"
    }

    init?(with vehicle: Vehicle) {
        self.id = vehicle.id
        self.coordinate = CLLocationCoordinate2D(latitude:vehicle.position.latitude, longitude: vehicle.position.longitude)
        self.title = vehicle.line
        self.image = vehicle.icon
        self.subtitle = "Z: \(vehicle.previousStop), do: \(vehicle.nextStop)"
    }
}

// Icons made by Freepik from www.flaticon.com.
