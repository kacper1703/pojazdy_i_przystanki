//
//  VehicleDetailsView.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

class VehicleDetailsView: UIView {
    @IBOutlet private var lineLabel: UILabel!
    @IBOutlet private var punctualityLabel: UILabel!
    @IBOutlet private var previousStopLabel: UILabel!
    @IBOutlet private var nextStopLabel: UILabel!
    @IBOutlet private var routeLabel: UILabel!
    @IBOutlet private var showRouteButton: UIButton!
    @IBOutlet private var visualEffectView: UIVisualEffectView!

    func configure(with vehicle: Vehicle) {
        lineLabel.text = vehicle.line
        punctualityLabel.text = vehicle.punctuality.description
        previousStopLabel.text = vehicle.previousStop
        nextStopLabel.text = vehicle.nextStop
        routeLabel.text = String(describing: vehicle.route)
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard let view = sender.view else { return }
            let translation = sender.translation(in: self.superview)
            if view.center.y < visualEffectView.bounds.height {
                view.center = CGPoint(x: view.center.x,
                                      y: view.center.y + translation.y)
            } else {
                view.center = CGPoint(x: view.center.x,
                                      y: visualEffectView.bounds.height - 1)
            }

            sender.setTranslation(CGPoint(x: 0, y: 0), in: self)
        }
    }

}
