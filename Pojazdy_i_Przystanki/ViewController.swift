//
//  ViewController.swift
//  Pojazdy_i_Przystanki
//
//  Created by Kacper Czapp on 12/06/2017.
//  Copyright © 2017 Kacper Czapp. All rights reserved.
//

import Alamofire
import DrawerKit
import GoogleMaps
import UIKit

class ViewController: UIViewController, GMSMapViewDelegate, DrawerCoordinating {
    @IBOutlet fileprivate var mapView: GMSMapView! {
        didSet {
            mapView.isBuildingsEnabled = false
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: Bundle.main.url(forResource: "MapStyle", withExtension: "json")!)
            mapView.delegate = self
            mapView.settings.compassButton = true
            mapView.settings.myLocationButton = true
            mapView.settings.tiltGestures = false
        }
    }

    @IBOutlet fileprivate var vehiclesSwitch: UISwitch!
    @IBOutlet fileprivate var stopsSwitch: UISwitch!

    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender == vehiclesSwitch {
            if vehiclesSwitch.isOn {
                vehiclesManager?.start()
            } else {
                vehiclesManager?.pause()
                vehicleClusterManager.clearItems()
            }
        } else if sender == stopsSwitch {
            if stopsSwitch.isOn {
                stopsManager?.start()
            } else {
                stopsClusterManager.algorithm.clearItems()
                stopsClusterManager.clearItems()
            }
        }
    }


    var stopsManager: StopsManager?
    var vehiclesManager: VehiclesManager?
    var currentLocation: CLLocation?
    private var stopsClusterManager: GMUClusterManager!
    private var vehicleClusterManager: GMUClusterManager!
    private var selectedMarker: GMSMarker? { didSet {
        print("new value: \(String(describing: selectedMarker?.userData))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stopsManager = StopsManager(withDelegate: self)
        vehiclesManager = VehiclesManager(withDelegate: self)
        centerOnSzczecin(animated: false)
    }

    func centerOnSzczecin(animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: 53.432, longitude: 14.555, zoom: 10)
        self.mapView.camera = camera
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.selectedMarker = marker
        self.selectedMarker?.userData = marker.userData

        if let vehicle = marker.userData as? Vehicle {
            mapView.animate(toLocation: marker.position)
            self.setinfoView(visible: true, with: vehicle)
        } else if let stop = marker.userData as? Stop {
            stopsManager?.stopDepartures(for: stop.stopNumber)
//            self.setinfoView(visible: false)
        } else {
            return false
        }

        return true
    }

    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        stopsManager?.start()
        vehiclesManager?.start()
    }

    func setinfoView(visible: Bool, with vehicle: Vehicle? = nil) {
        if visible {
            if let detail = self.presentedViewController as? DetailViewController, let vehicle = vehicle {
                detail.configure(with: vehicle)
            } else {
                showDrawer(with: vehicle)
            }
        } else {
            if self.presentedViewController is DetailViewController {
                dismiss(animated: true, completion: {
                    self.selectedMarker = nil
                })
            }
        }
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        guard let manager = vehiclesManager else { return }
        let linePicker = StoryboardScene.Main.linePickerViewController.instantiate()
        linePicker.delegate = self
        linePicker.lines = manager.allLines()
        show(linePicker, sender: nil)
    }

    var drawerDisplayController: DrawerDisplayController?

    func showDrawer(with vehicle: Vehicle?) {
        let detailViewController: DetailViewController = StoryboardScene.Main.detailViewController.instantiate()
        _ = detailViewController.view
        if let vehicle = vehicle {
            detailViewController.configure(with: vehicle)
        }
        var config = DrawerConfiguration()
        config.fullExpansionBehaviour = .dosNotCoverStatusBar
        config.isDismissableByOutsideDrawerTaps = true
        config.maximumCornerRadius = 50
        config.containerViewDimMode = .with(color: UIColor.black.withAlphaComponent(0.5))
        config.hasHandleView = false
        drawerDisplayController = DrawerDisplayController(presentingViewController: self,
                                                          presentedViewController: detailViewController,
                                                          configuration: config,
                                                          inDebugMode: false)
        present(detailViewController, animated: true)
    }
}

extension ViewController: LinePickerDelegate {
    func pickerDidSelect(lines: [String]) {

    }
}

extension ViewController: StopsManagerDelegate {
    func manager(manager: StopsManager, didDownloadDepartures: StopDepartures) {

    }

    func manager(manager: StopsManager, didSet stops: [Stop]) {
        setupStopClusters(with: stops)
    }

    func setupStopClusters(with stops: [Stop]) {
        if stopsClusterManager == nil {
            let iconGenerator = ClusterGenerator.stopsIconGenerator
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                     clusterIconGenerator: iconGenerator)
            renderer.delegate = self
            renderer.animatesClusters = false
            stopsClusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                                    renderer: renderer)
            stopsClusterManager.setDelegate(self, mapDelegate: self)
        }
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
            renderer.animatesClusters = false
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
        updateCameraIfNeeded()
    }

    func manager(manager: VehiclesManager, didFailWith error: Error) {

    }

    func updateCameraIfNeeded() {
        guard let selectedMarker = self.selectedMarker else { return }

        if let vehicle = selectedMarker.userData as? Vehicle {
//            let newCamera = GMSCameraPosition.camera(withTarget: vehicle.position,
//                                                     zoom: mapView.camera.zoom)
//            let update = GMSCameraUpdate.setCamera(newCamera)
//            mapView.animate(with: update)
            mapView.animate(toLocation: vehicle.position)
            if let detailVC = self.presentedViewController as? DetailViewController {
                detailVC.configure(with: vehicle)
            }
        }
//        else let stop = selectedMarker.userData as? Stop {
//            mapView.animate(toLocation: stop.position)
//        }
    }
}

extension ViewController: GMUClusterRendererDelegate, DrawerAnimationParticipant {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData is Stop {
            marker.icon = Asset.stop.image
        } else if let vehicle = marker.userData as? Vehicle {
            marker.icon = vehicle.icon
        }
    }

    var drawerAnimationActions: DrawerAnimationActions {
        return DrawerAnimationActions(prepare: nil, animateAlong: nil, cleanup: { info in
            if info.endDrawerState == .collapsed {
                self.selectedMarker = nil
            }
        })
    }
}

extension ViewController: GMUClusterManagerDelegate {
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.animate(with: update)
        return true
    }

    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        return false
    }
}
