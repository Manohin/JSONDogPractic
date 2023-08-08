//
//  MainViewController.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 14.06.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var dogView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func showDogButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        fetchDog()
    }
    
    func fetchDog() {
        activityIndicator.startAnimating()
        
        networkManager.fetchData(from: url) { [weak self] result in
            switch result {
                
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async { [weak self] in
                    self?.dogView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

