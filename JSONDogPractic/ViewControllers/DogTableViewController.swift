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
        tableView.rowHeight = 300
        navigationItem.leftBarButtonItem = editButtonItem
        setupRefreshControl()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dogImages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dog", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.image = dogImages[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    private func getDogs(to quantity: Int) {
        for _ in 1...quantity {
            networkManager.fetch(Data.self, from: url) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.dogImages.append(image)
                    }
                    print(self?.dogImages.count ?? 0)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        dogImages.removeAll()
        getDogs(to: 10)
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
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Загружаем собакенов...")
        
        let refreshAction = UIAction { [weak self] _ in
            self?.dogImages.removeAll()
            self?.getDogs(to: 10)
            self?.tableView.reloadData()
            if self?.refreshControl != nil {
                self?.refreshControl?.endRefreshing()
            }
        }
        refreshControl?.addAction(refreshAction, for: .valueChanged)
    }
}
