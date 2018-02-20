//
//  FinalViewController.swift
//  Fotoroid
//
//  Created by Jair Guedes Ferreira Neto on 15/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var ivPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    @IBAction func restart(_ sender: Any) {
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
