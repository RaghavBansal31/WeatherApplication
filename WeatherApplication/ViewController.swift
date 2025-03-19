//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Raghav Bansal on 3/19/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
     
    //For search city to stay in the tableview
    var cities:[String] = []
    var  weatherData: [WeatherData] = []
    let viewModel = WeatherViewModel()
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.1)
        
        // Setup location manager
           locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
        
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.placeholder = "Search For city "
        searchBar.barTintColor = UIColor.systemBlue
        searchBar.tintColor = UIColor.white
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = UIColor.clear
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
    }
    
    @objc func callPullToRefresh(send: UIRefreshControl){
        DispatchQueue.main.async{
            let string = "Refreshed Data"
            let attributes: [NSAttributedString.Key:Any] = [
                .foregroundColor:UIColor(red: 0.90, green: 0.30, blue: 0.25, alpha: 1.0),
                .font: UIFont.italicSystemFont(ofSize: 26)
            
            ]
            self.tableView.refreshControl?.tintColor = UIColor(red: 0.90, green: 0.30, blue: 0.25, alpha: 1.0)
            self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: string, attributes:attributes)
            
            // Reset cities and weatherData
            self.cities.removeAll()
            self.weatherData.removeAll()
            self.tableView.reloadData()
            
            // Fetch current weather for current location
            if let currentLocation = self.locationManager.location {
                self.fetchCityName(from: currentLocation)
                
                
            }
           
           
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func fetchCityName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                print("Error fetching city name: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Get city name and pass it to fetch weather data
            if let city = placemark.locality {
                print("Current city: \(city)")
                self.fetchWeatherData(for: city)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard let cityName = searchBar.text else{
            return
        }
        fetchWeatherData(for: cityName)
    }
    
    //Fetch Weather Data
    func fetchWeatherData(for city: String){
        viewModel.fetchWeather(forCity: city) { weather in
            if let weather = weather {
                self.weatherData.append(weather)
                self.cities.append(city)
                self.tableView.reloadData()
            }else{
                print("Error fetch weather Data")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.systemBlue
        cell.layer.cornerRadius = 10
        
        
        
        return cell
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeather = weatherData[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: selectedWeather)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail", let weather = sender as? WeatherData{
             if let detailVC = segue.destination as? WeatherDetailViewController{
                 detailVC.weatherData = weather
                 detailVC.viewModel = self.viewModel
             }
                    
         }
    }


}


