//
//  ViewController.swift
//  Lab 8 Weather
//
//  Created by Pavan savaliya on 2024-03-29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeAPICall()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblDesctiption: UILabel!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblHuminity: UILabel!
    
    @IBOutlet weak var lblWind: UILabel!
    
    func makeAPICall() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Waterloo,CA&appid=e0ff36b202a7a12d6e0ee8dcb252b9f6") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        self.lblCity.text = jsonData.name
                        self.lblTemp.text = "\(jsonData.main.temp)"
                        self.lblDesctiption.text = jsonData.weather[0].description
                        self.loadWeatherIcon(jsonData.weather[0].icon)
                        self.lblHuminity.text =  "\(jsonData.main.humidity)%"
                        self.lblWind.text =  "\(jsonData.wind.speed) km/h"
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            } else {
                print("Error fetching data:", error ?? "Unknown error")
            }
        }
        task.resume()
    }
    
    func loadWeatherIcon(_ iconCode: String) {
        let iconURLString = "https://openweathermap.org/img/w/\(iconCode).png"
        if let iconURL = URL(string: iconURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: iconURL) {
                    DispatchQueue.main.async {
                        self.imgIcon.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}

