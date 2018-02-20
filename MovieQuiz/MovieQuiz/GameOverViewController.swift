//
//  GameOverViewController.swift
//  MovieQuiz
//
//  Created by Jair Guedes Ferreira Neto on 13/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var lbScore: UILabel!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbScore.text = "\(score)"
        // Do any additional setup after loading the view.
    }

    @IBAction func playAgain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
