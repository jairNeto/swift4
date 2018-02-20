//
//  ViewController.swift
//  TrailerFix
//
//  Created by Jair Guedes Ferreira Neto on 14/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trailers: [Trailer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrailers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TrailerViewController
        vc.trailer = sender as! Trailer
    }
    
    func loadTrailers() {
        guard let url = Bundle.main.url(forResource: "trailers", withExtension: "json") else {return}
        do {
            let trailersData = try Data(contentsOf: url)
            trailers = try JSONDecoder().decode([Trailer].self, from: trailersData)
            tableView.reloadData()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func showTrailer(index: Int) {
        let trailer = trailers[index]
        performSegue(withIdentifier: "trailerSegue", sender: trailer)
    }


    @IBAction func watchRandomTrailers(_ sender: UIButton) {
        let randomINdex = Int(arc4random_uniform(UInt32(trailers.count)))
        showTrailer(index: randomINdex)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let trailer = trailers[indexPath.row]
        
        cell.textLabel?.text = trailer.title
        cell.detailTextLabel?.text = "\(trailer.year)"
        cell.imageView?.image = UIImage(named: trailer.poster)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        showTrailer(index: index)
        
        
        
    }
}

