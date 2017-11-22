//
//  ARViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Cz on 21/11/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit
import HDAugmentedReality

class CameraViewController: UIViewController {

    fileprivate var arViewController: ARViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        stopsManager = StopsManager(withDelegate: self)
        stopsManager?.start()

        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.uiOptions.debugLabel = true
        arViewController.uiOptions.debugMap = true
        arViewController.presenter.maxDistance = 200
        arViewController.presenter.distanceOffsetMode = .none
        arViewController.presenter.presenterTransform = ARPresenterStackTransform()
        arViewController.interfaceOrientationMask = .portrait
        arViewController.presenter.maxVisibleAnnotations = 30
        arViewController.trackingManager.headingFilterFactor = 0.5
        arViewController.trackingManager.pitchFilterFactor = 0.1
        arViewController.onDidFailToFindLocation = { [weak self] elapsedSeconds, _ in
            if elapsedSeconds > 30 {
                //show alert
            }
        }
    }

    var stopsManager: StopsManager?

    override func viewDidAppear(_ animated: Bool) {
        self.present(arViewController, animated: false, completion: nil)
    }
}

extension CameraViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        guard let stop = stopsManager?.stopWith(id: viewForAnnotation.identifier) else { fatalError() }
        let annotationView = StopAnnotation(with: stop)
        annotationView.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        annotationView.annotation = viewForAnnotation
        return annotationView
    }
}

extension CameraViewController: StopsManagerDelegate {
    func manager(manager: StopsManager, didSet stops: [Stop]) {
        let places = stops.flatMap({ stop -> ARAnnotation? in
            return ARAnnotation(identifier: String(stop.id),
                                title: stop.name!,
                                location: stop.positionNon2D)
        })
        arViewController.setAnnotations(places)
    }

    func manager(manager: StopsManager, didFailWith error: Error) {

    }

    func manager(manager: StopsManager, didDownloadDepartures: StopDepartures) {

    }


}
