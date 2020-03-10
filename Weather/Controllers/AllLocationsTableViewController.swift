//
//  AllLocationTableTableViewController.swift
//  Weather
//
//  Created by Pedro on 3/9/20.
//  Copyright © 2020 Mario Zarate Velasquez. All rights reserved.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func didChooseLocation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tempSegment: UISegmentedControl!
    @IBOutlet weak var footerView: UIView!
    
    // MARK: - Vars
    
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    var weatherData: [CityTempData]?
    var delegate: AllLocationsTableViewControllerDelegate?
    var shouldRefresh: Bool = false
    
    // MARK: - View lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        
        loadLocationsFromUserDefaults()
        loadTempFormatFromUserDefaults()
    }
    
    // MARK: - IBActions
    
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainWeatherTableViewCell
        if weatherData != nil {
            cell.generateCell(weatherData: weatherData![indexPath.row])
        }
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLocation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            
            removeLocationFromSavedLocations(location: locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLocations(location: String) {
        if savedLocations != nil {
            for i in 0..<savedLocations!.count {
                let tempLocation = savedLocations![i]
                if tempLocation.city == location {
                    savedLocations!.remove(at: i)
                    saveNewLocationsToUserDefaults()
                    return
                }
            }
        }
    }
    
    private func saveNewLocationsToUserDefaults() {
        shouldRefresh = true
        
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    // MARK: - UserDefaults
    
    private func loadLocationsFromUserDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    
    private func updateTempFormatInUserDefaults(newValue: Int) {
        shouldRefresh = true
        userDefaults.set(newValue, forKey: "TempFormat")
        userDefaults.synchronize()
    }
    
    private func loadTempFormatFromUserDefaults() {
        if let index = userDefaults.value(forKey: "TempFormat") {
            tempSegment.selectedSegmentIndex = index as! Int
        } else {
            tempSegment.selectedSegmentIndex = 0
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
        shouldRefresh = true
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
    }
}
