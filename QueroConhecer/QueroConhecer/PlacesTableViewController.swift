//
//  PlacesTableViewController.swift
//  QueroConhecer
//
//  Created by Jair Guedes Ferreira Neto on 8/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places: [Place] = []
    let ud = UserDefaults.standard
    var ldNoPlaces: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ldNoPlaces = UILabel()
        ldNoPlaces.text = "Cadastre os locais que você deseja conhecer \nclicando no botão + acima"
        ldNoPlaces.textAlignment = .center
        ldNoPlaces.numberOfLines = 0
        
        loadPlaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "mapSegue" {
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
        }else {
            let vc = segue.destination as! MapViewViewController
            switch sender {
            case let place as Place:
                vc.places = [place]
            default:
                vc.places = places
            }
        }
    }
    
    func loadPlaces() {
        if let placesDatas = ud.data(forKey: "places") {
            do {
                places = try JSONDecoder().decode([Place].self, from: placesDatas)
                tableView.reloadData()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func savePlaces() {
        let json = try? JSONEncoder().encode(places)
        ud.set(json, forKey: "places")
    }
    
    @objc func showAll() {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            let btShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll
            tableView.backgroundView = nil
        }else {
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = ldNoPlaces
        }
        
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        cell.textLabel?.text = place.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "mapSegue", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        }
    }

}

extension PlacesTableViewController: PlaceFinderDelegate {
    func addPlace(_ place: Place) {
        if !places.contains(place) {
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
    
    
}
