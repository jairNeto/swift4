//
//  GameViewController.swift
//  MyGames
//
//  Created by Jair Guedes Ferreira Neto on 12/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lbGame: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCOver: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbGame.text = game.title
        lbConsole.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançamento: " + dateFormatter.string(from: releaseDate)
        }
        if let image = game.cover as? UIImage {
            ivCOver.image = image
        }else {
            ivCOver.image = #imageLiteral(resourceName: "noCoverFull")
        }
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }

}
