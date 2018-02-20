//
//  ViewController.swift
//  Fotoroid
//
//  Created by Jair Guedes Ferreira Neto on 15/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EffectsViewController
        vc.image = sender as! UIImage
    }

    @IBAction func selectSource(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a sua foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.selectType(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: { (action) in
            self.selectType(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: { (action) in
            self.selectType(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction  = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectType(sourceType: UIImagePickerControllerSourceType) {
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = sourceType
        imagepicker.delegate = self
        present(imagepicker, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let originalWidth  = image.size.width
            let aspectRatio = originalWidth / image.size.height
            let smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
            }else {
                smallSize = CGSize(width: 1000*aspectRatio, height: 1000 )
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "effectSegue", sender: smallImage)    
            })
        }
        
    }
}

