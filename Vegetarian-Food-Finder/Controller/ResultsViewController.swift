//
//  ResultsViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/17/22.
//

import CoreLocation
import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegaet: ResultsViewControllerDelegaet?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.mapViewSearchBarCell)
        return table
    }()

    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    public func update(with places: [Place]) {
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mapViewSearchBarCell, for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let place = places[indexPath.row]
        GooglePlacesApi.shared.getLocation(for: place) { [weak self] result in
            switch result {
            case let .success(coordinate):
                DispatchQueue.main.sync {
                    self?.delegaet?.didTapPlace(with: coordinate)
                }
            case .failure:
                self?.showOkActionAlert(withTitle: "Faild to get restaurant Location", andMessage: "Try again later")
            }
        }
    }
}
