//
//  FullPictureViewController.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 08.08.2023.
//

import UIKit

final class FullPictureViewController: UIViewController {

    @IBOutlet var dogPictureImageView: UIImageView! 
    
    var dogImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogPictureImageView.image = dogImage
    }
}
