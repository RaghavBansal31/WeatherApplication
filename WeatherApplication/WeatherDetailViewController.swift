//
//  WeatherDetailViewController.swift
//  WeatherApplication
//
//  Created by Raghav Bansal on 3/19/25.
//

import Foundation
import UIKit

class WeatherDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var weatherData: WeatherData!
    var forecastData: ForecastData?
    var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.1)
        
        collectionView.backgroundColor = UIColor.clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 180)
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateWeatherInfo()
        fetchForecastData()
        
    }
    
    func updateWeatherInfo(){
        
        if let temp = weatherData.main.temp{
            temperatureLabel.text = "Temperature: \(temp)  C"
        }else{
            temperatureLabel.text = "Temperature: N/A"
        }
        
        humidityLabel.text = "Humidity: \(String(describing: weatherData.main.humidity)) %"
        
        if let desc = weatherData.weather.first?.description{
            descriptionLabel.text = "Condition: \(desc)"
        }else{
            descriptionLabel.text = "Condition: N/A"
        }
        
//        descriptionLabel.text = "Condition: \(String(describing: weatherData.weather.first?.description))"
        
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 18)
        humidityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        temperatureLabel.textColor = UIColor.white
        humidityLabel.textColor = UIColor.white
        descriptionLabel.textColor = UIColor.white
        
        
        
        temperatureLabel.font = UIFont.italicSystemFont(ofSize: 18)
        humidityLabel.font = UIFont.italicSystemFont(ofSize: 18)
        descriptionLabel.font = UIFont.italicSystemFont(ofSize: 16)
        
        
    }
    
    func fetchForecastData(){
        guard let city = weatherData.name else {return}
        
        viewModel.fetchForecast(forCity: city) { forecast in
            if let forecast = forecast{
                self.forecastData = forecast
                self.collectionView.reloadData()
            }else{
                print("Error in fetching forecast data")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath)
        
        guard let forecast = forecastData?.list[indexPath.row] else {return cell}
        
        if cell.contentView.subviews.isEmpty{
            let temperatureLabel = createLabel(fontSize: 14, bold: true, textColor: .white)
            
            let timeLabel = createLabel(fontSize: 12, bold: false, textColor: .white)
            
            cell.contentView.addSubview(temperatureLabel)
            cell.contentView.addSubview(timeLabel)
            
            NSLayoutConstraint.activate([
                temperatureLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                temperatureLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor,constant: 30),
                
                timeLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                temperatureLabel.topAnchor.constraint(equalTo: cell.contentView.bottomAnchor,constant: 20),
                
                
            
            ])
            
            temperatureLabel.text = "\(forecast.main?.temp ?? 0) C"
            timeLabel.text = forecast.dt_txt ?? "N/A"
            
           
            
        }
        styleCell(cell)
        
        return cell
    }
    
    
    func createLabel(fontSize: CGFloat, bold:Bool, textColor:UIColor) -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = bold ? UIFont.boldSystemFont(ofSize: fontSize): UIFont.italicSystemFont(ofSize: fontSize)
        label.textColor = textColor
        return label
    }
    
    func styleCell(_ cell: UICollectionViewCell){
        cell.contentView.backgroundColor = UIColor.systemBlue
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 5
        
        
    }
    
    
}
