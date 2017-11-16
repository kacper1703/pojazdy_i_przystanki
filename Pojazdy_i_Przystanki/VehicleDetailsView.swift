//
//  VehicleDetailsView.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 13/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation

protocol DetailViewPanDelegate: class {
    func handle(_ panGesture: UIPanGestureRecognizer)
}

protocol DetailViewRouteDelegate: class {
    func didTapRouteButtonFor(vehicle: Vehicle)
}

class VehicleDetailsView: UIView {
    @IBOutlet private var lineLabel: UILabel!
    @IBOutlet private var punctualityLabel: UILabel!
    @IBOutlet private var previousStopLabel: UILabel!
    @IBOutlet private var nextStopLabel: UILabel!
    @IBOutlet private var routeLabel: UILabel!
    @IBOutlet private var showRouteButton: UIButton!
    @IBOutlet private var visualEffectView: UIVisualEffectView! {
        didSet {
            visualEffectView.layer.masksToBounds = true
            visualEffectView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private (set) var containerView: UIView!

    @IBAction func routeButtonTapped() {

    }

    static let bottomMargin: CGFloat = 20.0
    var vehicle: Vehicle?

    func configure(with vehicle: Vehicle) {
        self.vehicle = vehicle
        lineLabel.text = vehicle.line
        punctualityLabel.text = vehicle.punctuality.description
        previousStopLabel.text = vehicle.previousStop
        nextStopLabel.text = vehicle.nextStop
        routeLabel.text = String(describing: vehicle.route)
    }

    weak var panDelegate: DetailViewPanDelegate?
    weak var routeButtonDelegate: DetailViewRouteDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        let panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panRecognizer)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        panDelegate?.handle(sender)
//        if sender.state == .began || sender.state == .changed {
//            guard let view = sender.view else { return }
//            let translation = sender.translation(in: self.superview)
//            if view.center.y < visualEffectView.bounds.height {
//                view.center = CGPoint(x: view.center.x,
//                                      y: view.center.y + translation.y)
//            } else {
//                view.center = CGPoint(x: view.center.x,
//                                      y: visualEffectView.bounds.height - 1)
//            }
//
//            sender.setTranslation(CGPoint(x: 0, y: 0), in: self)
//        }
    }



}
