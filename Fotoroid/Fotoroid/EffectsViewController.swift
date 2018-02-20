//
//  EffectsViewController.swift
//  Fotoroid
//
//  Created by Jair Guedes Ferreira Neto on 15/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class EffectsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viLoading: UIView!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    var image: UIImage!
    lazy var filterManager: FilterManager = {
        let filterImage = FilterManager(image: image)
        return filterImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivPhoto.image = image

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ivPhoto.image = filterManager.apllyFilter(filterType: filterType(rawValue: 5)!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
