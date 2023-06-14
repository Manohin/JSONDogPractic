//
//  ViewController.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 14.06.2023.
//

import UIKit



class ViewController: UIViewController {
    
    
    @IBOutlet weak var dogView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDogButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        fetchDog()
    }
    
    private func fetchDog() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "eiowrh")
                return
            }
            print(response)
            let decoder = JSONDecoder()
            do {
                let dog = try decoder.decode(Dog.self, from: data)
                guard let dataImage = URL(string: dog.message) else { return }
                URLSession.shared.dataTask(with: dataImage) { [weak self] data, _, error in
                    guard let data = data else {
                        print(error?.localizedDescription ?? "usdfghsdifghds")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else { return }
                        self?.dogView.image = image
                        self?.activityIndicator.stopAnimating()
                    }
                    
                }.resume()
                
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        
        
    }
}

