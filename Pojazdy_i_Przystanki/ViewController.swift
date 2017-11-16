//
//  ViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isBuildingsEnabled = false
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: Bundle.main.url(forResource: "MapStyle", withExtension: "json")!)
            mapView.delegate = self
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
            mapView.settings.tiltGestures = false
        }
    }

    var stopsManager: StopsManager?
    var vehiclesManager: VehiclesManager?
    var currentLocation: CLLocation?
    private var stopsClusterManager: GMUClusterManager!
    private var vehicleClusterManager: GMUClusterManager!
    private var selectedMarker: GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()
        stopsManager = StopsManager(withDelegate: self)
        stopsManager?.start()
        vehiclesManager = VehiclesManager(withDelegate: self)
        vehiclesManager?.start()
        setupinfoView()
        animatorSetup()
        centerOnSzczecin(animated: false)
    }

    func centerOnSzczecin(animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: 53.432, longitude: 14.555, zoom: 10)
        self.mapView.camera = camera
    }

    var infoView: VehicleDetailsView?

    func setupinfoView() {
        DispatchQueue.main.async {
            let newinfoView = Bundle.loadViewFromNib(withType: VehicleDetailsView.self)
            newinfoView.routeButtonDelegate = self
            let infoViewHeight = newinfoView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + VehicleDetailsView.bottomMargin
            let frame = self.view.frame
            newinfoView.frame = CGRect(x: frame.minX,
                                         y: frame.maxY + 1,
                                         width: frame.width,
                                         height: infoViewHeight)
            self.view.addSubview(newinfoView)
            newinfoView.panDelegate = self
            self.infoView = newinfoView

        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let vehicle = marker.userData as? Vehicle {
            infoView?.configure(with: vehicle)
            mapView.animate(toLocation: marker.position)
            self.setinfoView(visible: true)
        } else if let stop = marker.userData as? Stop {
            self.setinfoView(visible: false)
        } else {
            return false
        }


        return true
    }

    func setinfoView(visible: Bool) {
        guard let infoView = infoView else { return }
        let showHideAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8, animations: nil)

        if visible && isInfoviewVisible == false {
            showHideAnimator.addAnimations {
                infoView.frame.origin.y = self.view.frame.maxY - infoView.containerView.frame.height
            }
        } else if visible == false && isInfoviewVisible == true {
            showHideAnimator.addAnimations {
                infoView.frame.origin.y = self.view.frame.maxY + 1
            }
        }
        showHideAnimator.startAnimation()
    }

//    @IBAction func filterButtonTapped(_ sender: Any) {
//        guard let manager = vehiclesManager else {
//            return
//        }
//        let linePicker = StoryboardScene.Main.instantiateLinePickerViewController()
//        linePicker.delegate = self
//        linePicker.lines = manager.allLines()
//        show(linePicker, sender: nil)
//    }
//

    var infoViewAnimator: UIViewPropertyAnimator?
    var isInfoviewVisible: Bool {
        guard let infoView = infoView else { return false }
        return self.view.frame.intersects(infoView.frame)
    }

    func animatorSetup() {
//        infoViewAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8, animations: {
//            self.infoView?.frame.origin.y = self.view.frame.maxY + 1
//        })
    }
}

extension ViewController: LinePickerDelegate, DetailViewPanDelegate, DetailViewRouteDelegate {
    func handle(_ panGesture: UIPanGestureRecognizer) {
        guard let infoView = self.infoView else { return }

        switch  panGesture.state {
        case .began:
            if infoViewAnimator?.isRunning ?? false {
                infoViewAnimator?.stopAnimation(false)
            }
            infoViewAnimator?.startAnimation()
        case .changed:
            let translation = panGesture.translation(in: self.view).y
//            guard newOrigin.maxX >= view.frame.maxX else { return }
            infoView.frame.origin.y += translation

        case .ended:
            let velocity = CGVector(dx: 0, dy: panGesture.velocity(in: self.view).y / 200)
            let springParameters = UISpringTimingParameters(mass: 0.1, stiffness: 100, damping: 200, initialVelocity: velocity)
            infoViewAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
            let startingPoint = infoView.frame.maxX

            infoViewAnimator?.addAnimations({
                self.infoView?.frame.origin.y = self.view.frame.maxY + 1
            })

            infoViewAnimator?.startAnimation()
        default:
            break
        }
    }

    func didTapRouteButtonFor(vehicle: Vehicle) {
        <#code#>
    }


    func pickerDidSelect(lines: [String]) {
//        guard let manager = vehiclesManager else {
//            return
//        }
//        if let existingAnnotations = mapView.annotations?.filter ({ $0 is VehicleAnnotation }) {
//            mapView.removeAnnotations(existingAnnotations)
//        }
//        let vehicles: [Vehicle] = manager.vehicles(withLineNumbers: lines)
//        let annotations: [VehicleAnnotation] = vehicles.flatMap { (vehicle) -> VehicleAnnotation? in
//            return VehicleAnnotation(with: vehicle)
//        }
//        mapView.addAnnotations(annotations)
    }


}

extension ViewController: StopsManagerDelegate {
    func manager(manager: StopsManager, didSet stops: [Stop]) {
        setupStopClusters(with: stops)
    }

    func setupStopClusters(with stops: [Stop]) {
        let iconGenerator = ClusterGenerator.stopsIconGenerator
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        stopsClusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                renderer: renderer)
        stopsClusterManager.setDelegate(self, mapDelegate: self)
        renderer.delegate = self
        stopsClusterManager.algorithm.clearItems()
        for stop in stops {
            stopsClusterManager.add(stop)
        }
        stopsClusterManager.cluster()
    }

    func manager(manager: StopsManager, didFailWith error: Error) {

    }
}

extension ViewController: VehiclesManagerDelegate {
    func manager(manager: VehiclesManager, didSet vehicles: [Vehicle]) {
        if mapView.selectedMarker == nil {
            setupVehicleClusters(with: vehicles)
        }
    }

    func setupVehicleClusters(with vehicles: [Vehicle]) {
        if vehicleClusterManager == nil {
            let iconGenerator = ClusterGenerator.vehicleIconGenerator
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                     clusterIconGenerator: iconGenerator)
            vehicleClusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                      renderer: renderer)
            vehicleClusterManager.setDelegate(self, mapDelegate: self)
            renderer.delegate = self
        }

        vehicleClusterManager.clearItems()
        for vehicle in vehicles {
            vehicleClusterManager.add(vehicle)
        }
        vehicleClusterManager.cluster()
    }

    func manager(manager: VehiclesManager, didFailWith error: Error) {

    }
}

extension ViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData is Stop {
            marker.icon = Asset.stop.image
        } else if let vehicle = marker.userData as? Vehicle {
            marker.icon = vehicle.icon
        }
    }
}

extension ViewController: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return true
    }

    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        return false
    }
}
