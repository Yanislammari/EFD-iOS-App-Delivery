//
//  DeliveriesMapViewController.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 13/02/2025.
//

import UIKit
import MapKit
import CoreLocation

class DeliveriesMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var errorLocationView: UIView!
    @IBOutlet weak var errorLocationLabel: UILabel!
    @IBOutlet weak var errorLocationButton: UIButton!
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation?
    var lastRouteUpdateLocation: CLLocationCoordinate2D?
    
    var colis: [Colis] = [] {
        didSet {
            self.reloadMap()
        }
    }
    
    var colisService: ColisService {
        return ColisService.getInstance()
    }
    
    var deliveryManService: DeliveryManService {
        return DeliveryManService.getInstance()
    }
    
    var authService: AuthService {
        return AuthService.getInstance()
    }
    
    var toastHandler: ToastHandler {
        return ToastHandler.getInstance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initErrorLocationView()
        self.initLocations()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colisService.getColisOfLivraison { allColis in
            print(allColis)
            self.colis = allColis
        }
    }
    
    func initErrorLocationView() {
        self.errorLocationView.layer.cornerRadius = 10
        // MULTI LANGUE
        //self.errorLocationLabel.text = String(localized: "GSCONTROLLER_ERROR_LOCATION")
        //self.errorLocationButton.setTitle(String(localized: "GSCONTROLLER_ERROR_LOCATION_SETTINGS"), for: .normal)
        self.errorLocationView.isHidden = true
    }
    
    func initLocations() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else {
            self.handleStatusUpdate(locationManager: self.locationManager)
        }
    }
    
    func handleStatusUpdate(locationManager: CLLocationManager) {
        if locationManager.authorizationStatus == .restricted || locationManager.authorizationStatus == .denied {
            self.errorLocationView.isHidden = false
        }
        else if locationManager.authorizationStatus == .authorizedWhenInUse {
            self.errorLocationView.isHidden = true
        }
    }
    
    func reloadMap() {
        let annotations = self.colis.map { c in
            let point = MKPointAnnotation()
            point.title = c.destination_name
            point.subtitle = c.uuid
            point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(c.lat), longitude: CLLocationDegrees(c.lgt))
            return point
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    
    @IBAction func handleLocationSettings(_ sender: UIButton) {
        let settingUrl = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(settingUrl!)
    }
}

extension DeliveriesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "ColisAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnAnnotation(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            annotationView?.addGestureRecognizer(doubleTapGesture)
        } else {
            annotationView?.annotation = annotation
        }

        if let id = annotation.subtitle, let colis = self.colis.first(where: { $0.uuid == id }) {
            annotationView?.markerTintColor = (colis.status == "done") ? UIColor.green : UIColor.red
        } else {
            annotationView?.markerTintColor = UIColor.red
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation, !(annotation is MKUserLocation) else {
            return
        }
        self.selectedAnnotation = annotation
        if let userLoc = mapView.userLocation.location {
            drawRoute(from: userLoc.coordinate, to: annotation.coordinate)
        }
    }
    
    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        self.mapView.overlays.forEach { overlay in
            if overlay is MKPolyline {
                self.mapView.removeOverlay(overlay)
            }
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                return
            }
            self.mapView.addOverlay(route.polyline)
        }
    }
    
    func initUserLocationStorage() {
        guard let userLocation = self.mapView.userLocation.location else {
            return
        }
        
        let latitude = Float(userLocation.coordinate.latitude)
        let longitude = Float(userLocation.coordinate.longitude)
        
        self.deliveryManService.updateDeliveryManPosition(id: self.deliveryManService.deliveryManConnected!.id, token: self.authService.token!, lat: latitude, lng: longitude) {}
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.initUserLocationStorage()
        if let annotation = self.selectedAnnotation, let userLoc = mapView.userLocation.location {
             drawRoute(from: userLoc.coordinate, to: annotation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        self.initUserLocationStorage()
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
        
    @objc func handleDoubleTapOnAnnotation(_ gesture: UITapGestureRecognizer) {
        guard let annotationView = gesture.view as? MKAnnotationView,
              let annotation = annotationView.annotation,
              let userLocation = self.mapView.userLocation.location else {
            return
        }
        
        let colisLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distance = userLocation.distance(from: colisLocation)
        
        if distance <= 200 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            else {
                self.toastHandler.showToast(message: "Camera not available", in: self)
            }
        }
        else {
            self.toastHandler.showToast(message: "Erreur: Vous n'êtes pas à proximité du colis (distance > 200m)", in: self)
        }
    }
}

extension DeliveriesMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.handleStatusUpdate(locationManager: manager)
    }
}

extension DeliveriesMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.toastHandler.showToast(message: "Erreur lors de la récupération de la photo", in: self)
            return
        }
        
        guard let selectedAnnotation = self.selectedAnnotation,
              let uuid = selectedAnnotation.subtitle else {
            self.toastHandler.showToast(message: "Aucun point sélectionné", in: self)
            return
        }
        
        self.colisService.uploadPhotoColis(id: uuid!, token: self.authService.token!, photoData: imageData) {
            DispatchQueue.main.async {
                self.toastHandler.showToast(message: "Photo envoyée", in: self)
            }
        }
    }
}
