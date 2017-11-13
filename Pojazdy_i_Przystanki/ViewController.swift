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

class ViewController: UIViewController, GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        stopsManager = StopsManager(withDelegate: self)
        stopsManager?.start()
        vehiclesManager = VehiclesManager(withDelegate: self)
        vehiclesManager?.start()
        centerOnSzczecin(animated: false)
    }

    func centerOnSzczecin(animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: 53.432, longitude: 14.555, zoom: 10)
        self.mapView.camera = camera
    }

    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData is Stop {
            marker.icon = Asset.stop.image
        } else if let vehicle = marker.userData as? Vehicle {
            marker.icon = vehicle.icon
        }
    }

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

    var infoWindow: VehicleDetailsView?

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let vehicle = marker.userData as? Vehicle else { return false }
        if infoWindow == nil {
            let newInfoWindow = Bundle.loadViewFromNib(withType: VehicleDetailsView.self)
            let infoWindowHeight = newInfoWindow.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            newInfoWindow.frame = CGRect(x: view.frame.minX,
                                         y: view.frame.maxY,
                                         width: view.frame.width,
                                         height: infoWindowHeight)
            self.view.addSubview(newInfoWindow)
            infoWindow = newInfoWindow
            infoWindow?.configure(with: vehicle)
            setInfoWindow(hidden: false)
        } else {
            infoWindow?.configure(with: vehicle)
        }
        
        return true
    }

    func setInfoWindow(hidden: Bool) {
        if hidden {
            
            UIView.animate(withDuration: 1.0) {
                self.infoWindow?.frame.origin.y += self.infoWindow?.frame.height ?? 0
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.infoWindow?.frame.origin.y -= self.infoWindow?.frame.height ?? 0
            }
        }
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


}

extension ViewController: LinePickerDelegate {
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
