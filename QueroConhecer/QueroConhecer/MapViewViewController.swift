//
//  MapViewViewController.swift
//  QueroConhecer
//
//  Created by Jair Guedes Ferreira Neto on 8/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    enum MapMsgType {
        case RouteError
        case AuthWarning
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var places:[Place]!
    var poi: [MKAnnotation] = []
    lazy var locationManager = CLLocationManager()
    var btUserLocation: MKUserTrackingButton!
    var selectedAnnotattion: PlaceAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.isHidden = true
        viInfo.isHidden = true
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        locationManager.delegate = self
        
        if places.count == 1 {
            title = places[0].name
        }else {
            title = "Meus lugares"
        }
        
        for place in places {
            addToMap(place: place)
        }
        
        configureLocationButton()
        showPlaces()
        requestUserLocationAuth()
    }
    
    func configureLocationButton() {
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        btUserLocation.backgroundColor  = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        btUserLocation.layer.cornerRadius = 5
        btUserLocation.layer.borderWidth = 1
        btUserLocation.layer.borderColor = UIColor(named: "main")?.cgColor
    }
    
    func requestUserLocationAuth() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    mapView.addSubview(btUserLocation)
                case .denied:
                    showMessage(type: .AuthWarning)
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    break
            }
        }
    }
    
    func showMessage(type: MapMsgType) {
        let title = type == .AuthWarning ? "Aviso" : "Erro"
        let msg = type == .AuthWarning ? "Para Usar os recursos de localização do App, você precisa permitir o uso na tela de Ajustes" : "Não foi possível encontrar esta rota!"

        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if type == .AuthWarning {
            let confirmationAction = UIAlertAction(title: "Ir para ajustes", style: .default, handler: { (action) in
                if let appSettings = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(confirmationAction)
        }

        present(alert, animated: true, completion: nil)
    }
    
    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    func addToMap(place: Place) {
        let annotation = PlaceAnnotation(coordinates: place.coordinates, type: .place)
        annotation.title = place.name
        annotation.address = place.address
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func showRoute(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            showMessage(type: .AuthWarning)
            return
        }
        
        let request = MKDirectionsRequest()
        request.destination  = MKMapItem(placemark: MKPlacemark(coordinate:selectedAnnotattion!.coordinate))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:locationManager.location!.coordinate))
        let directions = MKDirections(request: request)
        directions.calculate { ( response, error) in
            if error == nil {
                if let response = response {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    
                    let route = response.routes.first!
                    print(route.name)
                    print(route.distance)
                    print(route.expectedTravelTime)
                    
                    for step in route.steps {
                        print("Em \(step.distance) metro(s), \(step.instructions)")
                    }
                    
                    self.mapView.add(route.polyline, level: .aboveRoads)
                    var annotations  = self.mapView.annotations.filter({!($0 is PlaceAnnotation)})
                    annotations.append(self.selectedAnnotattion!)
                    self.mapView.showAnnotations(annotations, animated: true)
                }
            }else {
                self.showMessage(type: .RouteError)
            }
        }
    }
    @IBAction func showSearchBar(_ sender: Any) {
        searchBar.resignFirstResponder()
        searchBar.isHidden = !searchBar.isHidden
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation) {
            return nil
        }
        
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        annotationView?.glyphImage = type == .place ? #imageLiteral(resourceName: "placeGlyph") : #imageLiteral(resourceName: "poiGlyph")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        return annotationView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        loading.startAnimating()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else {
                    self.loading.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.poi)
                self.poi.removeAll()
                for item in response.mapItems {
                    let annotation = PlaceAnnotation(coordinates: item.placemark.coordinate, type: .poi)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.address = Place.getFormattedAddress(with: item.placemark)
                    self.poi.append(annotation)
                }
                self.mapView.addAnnotations(self.poi)
                self.mapView.showAnnotations(self.poi, animated: true)
            }
            self.loading.stopAnimating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.addSubview(btUserLocation)
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            print("Velocidade: \(location.speed)")
//            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
//            mapView.setRegion(region, animated: true)
//        }
    }
    
    func showInfo() {
        lbName.text = selectedAnnotattion?.title
        lbAddress.text = selectedAnnotattion?.address
        viInfo.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let camera = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        selectedAnnotattion = (view.annotation as! PlaceAnnotation)
        showInfo()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        if overlay is MKPolyline {
            renderer.strokeColor = UIColor(named: "main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            
        }
        return renderer
    }

}
