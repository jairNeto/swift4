//
//  FilterManager.swift
//  Fotoroid
//
//  Created by Jair Guedes Ferreira Neto on 17/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import Foundation
import UIKit

enum filterType: Int {
    case comic
    case sepia
    case halftone
    case crystallize
    case vignette
    case noir
}
class FilterManager {
    
    let originalImage: UIImage!
    let context = CIContext(options: nil)
    let filterNames: [String] = [
    "CIComicEffect",
    "CISepiaTone",
    "CICMYHalftone",
    "CICrystallize",
    "CIVignette",
    "CIPhotoEffectNoir"
    ]
    
    init(image: UIImage) {
        originalImage = image
    }
    
    func apllyFilter(filterType: filterType) -> UIImage {
        let coreImage = CIImage(image: originalImage)!
        let filter = CIFilter(name: filterNames[filterType.hashValue])!
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        switch filterType {
            case .comic:
                break
            case .sepia:
                filter.setValue(1.0, forKey: kCIInputIntensityKey)
            case .halftone:
                filter.setValue(25, forKey: kCIInputWidthKey)
            case .crystallize:
                filter.setValue(25, forKey: kCIInputRadiusKey)
            case .vignette:
                filter.setValue(3.0, forKey: kCIInputIntensityKey)
                filter.setValue(30, forKey: kCIInputRadiusKey)
            case .noir:
                break
        }
        
        let filteredImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent)!
        return UIImage(cgImage: cgImage)
        
    }
}
