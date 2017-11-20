//
//  DetailViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 19/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Foundation
import DrawerKit

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

    }

    @IBOutlet var partialDrawerSeparator: UIView!

    func configure(with vehicle: Vehicle) {
        lineLabel.text = vehicle.line
        punctualityLabel.text = vehicle.punctuality.description
        previousStopLabel.text = vehicle.previousStop.isEmpty ? "n/a" : vehicle.previousStop
        nextStopLabel.text = vehicle.nextStop.isEmpty ? "n/a" : vehicle.nextStop
        routeLabel.text = String(describing: vehicle.route)
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

    func aconfigure(with stop: Stop) {

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handleImageView.layer.cornerRadius = handleImageView.bounds.height / 2
    }
}

extension DetailViewController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        return partialDrawerSeparator.frame.maxY
    }
}
