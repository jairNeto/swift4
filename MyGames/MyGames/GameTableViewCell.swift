//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Jair Guedes Ferreira Neto on 12/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var ivGameCover: UIImageView!
    @IBOutlet weak var lbGame: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with game: Game) {
        lbGame.text = game.title ?? ""
        lbConsole.text = game.console?.name ?? ""
        
        if let image = game.cover as? UIImage {
            ivGameCover.image = image
        }else {
            ivGameCover.image = #imageLiteral(resourceName: "noCover")
        }
    }

}
