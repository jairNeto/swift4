//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Jair Guedes Ferreira Neto on 8/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit
import MapKit


protocol PlaceFinderDelegate: class{
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController {
    
    enum PlaceFinderMsgType {
        case error(String)
        case confirmation(String)
    }

    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var acLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoad: UIView!
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
    }

    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder()
        let city  = tfCity.text!
        load(show: true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            self.load(show: false)
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                }
            }else {
                self.showMessage(type: .error("Erro desconhecido!"))
            }
        }
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                self.load(show: false)
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                    }
                }else {
                    self.showMessage(type: .error("Erro desconhecido!"))
                }
            })
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinadte = placemark.location?.coordinate else{
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let addrees = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitude: coordinadte.latitude, longitude: coordinadte.longitude, address: addrees)
        
        let region = MKCoordinateRegionMakeWithDistance(coordinadte, 3500, 3500)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    func showMessage(type: PlaceFinderMsgType) {
        let title: String, message: String
        var hasConfirmation = false
        
        switch type {
        case .confirmation(let name):
            title = "Local encontrado!"
            message = "Deseja adicionar local \(name)"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Erro!"
            message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmationAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.delegate?.addPlace(self.place)
               self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(confirmationAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func load(show: Bool) {
        viLoad.isHidden = !show
        if show {
            acLoading.startAnimating()
        }else {
            acLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
