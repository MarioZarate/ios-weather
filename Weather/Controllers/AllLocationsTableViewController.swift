//
//  AllLocationTableTableViewController.swift
//  Weather
//
//  Created by Pedro on 3/9/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

class AllLocationsTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    // MARK: - Vars
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    
    // MARK: - View lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromUserDefaults()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        return cell
    }
    
    // MARK: - UserDefaults
    
    private func loadFromUserDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSegue" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
        
    }
}

extension AllLocationsTableViewController: ChooseCityViewControllerDelegate {
    
    func didAdd(newLocation: WeatherLocation) {
        print("Added new location", newLocation.country)
    }
}
