//
//  ViewController.swift
//  WeatherApp
//
//  Created by Игорь Пенкин on 20.09.2020.
//  Copyright © 2020 Igor-A-Penkin. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }


}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=0e94558738fc93d43a41b6ade4740467&units=metric"
//        let urlString = "https://api.weatherstack.com/current?access_key=e54006b903cea32daf0a4401e920f6df&query=Moscow"
        let url = URL(string: urlString)!
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let _ = json["message"] {
                    errorHasOccured = true
                }
                if let name = json["name"] {
                    locationName = name as! String
                }
                if let main = json["main"] {
                    temperature = main["temp"] as! Double
                }

                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "City not found"
                        self?.temperatureLabel.isHidden = true
                    } else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(temperature!.rounded()) C'"
                        self?.temperatureLabel.isHidden = false
                    }
                }

            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }
        task.resume()
        
        
//        struct Image: Codable {
//            let imageURL: String
//            let uploaderName: String
//        }
//        struct Entry: Codable {
//            let images: [String: Image]
//        }
//        if let url = URL(string: "https://www.json-generator.com/api/json/get/cfpeTpOFrC?indent=2") {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    let jsonDecoder = JSONDecoder()
//                    do {
//                        let parsedJSON = try jsonDecoder.decode(Entry.self, from: data)
//                        for image in parsedJSON.images {
//                            print(image.value.imageURL)
//                            print(image.value.uploaderName)
//                        }
//                    } catch {
//                        print(error)
//                    }
//               }
//           }.resume()
//        }
    }
}
