//
//  ViewController.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 14.06.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var dogView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var image: UIImage? {
        get {
            return UIImage()
        }
        set {
            activityIndicator.stopAnimating()
            dogView.image = newValue
            dogView.sizeToFit()
        }
    }
    
    fileprivate let url = "https://dog.ceo/api/breeds/image/random"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func showDogButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        fetchDog()
    }
    
    fileprivate func fetchDog() {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "No Error Description")
                return
            }
            print(response)
            
            let decoder = JSONDecoder()
            do {
                let dog = try decoder.decode(Dog.self, from: data)
                guard let imageURL = URL(string: dog.message) else { return }
                URLSession.shared.dataTask(with: imageURL) { [unowned self] data, _, error in
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }.resume()
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

