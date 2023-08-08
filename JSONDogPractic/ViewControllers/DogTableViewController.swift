//
//  DogTableViewController.swift
//  JSONDogPractic
//
//  Created by Alexey Manokhin on 08.08.2023.
//

import UIKit

final class DogTableViewController: UITableViewController {
    
    let networkManager = NetworkManager.shared
    let url = "https://dog.ceo/api/breeds/image/random"
    var dogImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDogs()
        tableView.rowHeight = 300
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dogImages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dog", for: indexPath)
        var content = cell.defaultContentConfiguration()
        addSpinner(view: cell)
        content.image = dogImages[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    private func getDogs() {
        for _ in 1...100 {
            networkManager.fetch(Data.self, from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self?.dogImages.append(image)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    print(self?.dogImages.count ?? 0)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let fullVC = segue.destination as? FullPictureViewController else { return }
        guard let indexPathRow = tableView.indexPathForSelectedRow?.row else { return }
        fullVC.dogImage = dogImages[indexPathRow]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        (dogImages[sourceIndexPath.row],
         dogImages[destinationIndexPath.row]) = (dogImages[destinationIndexPath.row],
                                                 dogImages[sourceIndexPath.row])
    }
    
    private func addSpinner(view: UIView) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
    }
}
