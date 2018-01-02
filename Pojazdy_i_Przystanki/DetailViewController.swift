//
//  DetailViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 19/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import DrawerKit

fileprivate enum DrawerMode {
    case vehicle(with: Vehicle), stop(with: Stop)
}

class DetailViewController: UIViewController {
    @IBOutlet private var lineLabel: UILabel!
    @IBOutlet private var punctualityLabel: UILabel!
    @IBOutlet private var previousStopLabel: UILabel!
    @IBOutlet private var nextStopLabel: UILabel!
    @IBOutlet private var routeLabel: UILabel!
    @IBOutlet private var showRouteButton: UIButton!
    @IBOutlet private var handleImageView: UIImageView! {
        didSet { handleImageView.backgroundColor = .lightGray }
    }

    @IBOutlet private var visualEffectView: UIVisualEffectView!

    @IBAction func routeButtonTapped() {
        if case DrawerMode.vehicle(with: let vehicle) = self.mode! {
            
        }
    }

    @IBOutlet var partialDrawerSeparator: UIView!

    private var mode: DrawerMode?

    func configure(with vehicle: Vehicle) {
        self.mode = .vehicle(with: vehicle)
        lineLabel.text = vehicle.line
        punctualityLabel.text = vehicle.punctuality.description
        previousStopLabel.text = vehicle.previousStop.isEmpty ? "n/a" : vehicle.previousStop
        nextStopLabel.text = vehicle.nextStop.isEmpty ? "n/a" : vehicle.nextStop
        routeLabel.text = String(describing: vehicle.route)
    }

    func configure(with stop: Stop, departures: StopDepartures) {
        self.mode = .stop(with: stop)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handleImageView.layer.cornerRadius = handleImageView.bounds.height / 2
    }
}

extension DetailViewController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let mode = mode else { return self.view.frame.height }
        switch mode {
        case .stop:
            return partialDrawerSeparator.frame.maxY
        case .vehicle:
            return partialDrawerSeparator.frame.maxY
        }
    }
}
