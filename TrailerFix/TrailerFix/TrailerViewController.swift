//
//  TrailerViewController.swift
//  TrailerFix
//
//  Created by Jair Guedes Ferreira Neto on 14/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit
import AVKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var ivTrailer: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var viTrailer: UIView!
    
    var trailer: Trailer!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        preparePlayer()
    }
    
    func prepareView() {
        lbTitle.text = trailer.title
        lbYear.text = "\(trailer.year)"
        var rating = "Filme ainda não avaliado"
        if trailer.rating > 0 {
            rating = ""
            for _ in 1...trailer.rating {
                rating += "⭐️"
            }
        }
        lbRating.text = rating
        ivTrailer.image = UIImage(named: trailer.poster + "-large")
    }
    
    func preparePlayer() {
        let url = URL(fileURLWithPath: trailer.url)
        player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = true
        playerController.player?.play()
        playerController.view.frame = viTrailer.bounds
        viTrailer.addSubview(playerController.view)
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
