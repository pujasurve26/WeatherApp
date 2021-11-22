//
//  WebService.swift
//  WeatherApp
//
//  Created by Puja Kalpesh Surve on 22/11/21.
//

import Foundation

struct WebService {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=83f3a277d9317c1f5593e9fd5d953ce3&units=metric"
   
    func callAPI(city: String, completion: @escaping (_ response: WeatherData?, _ error: String?)-> Void) {
        let strUrl = weatherURL + "&q=" + city
        print("Endpoint: ", strUrl)
        let url = URL(string: strUrl.trimmingCharacters(in: .whitespaces))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            if data != nil {
                do {
                    let jsonData = try JSONDecoder().decode(WeatherData.self, from: data!)
                    DispatchQueue.main.async {
                        completion(jsonData, nil)
                    }
                }
                catch let e {
                    print("Failed to decode: ", e.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil, e.localizedDescription)
                    }
                }
            } else {
                print("FAILURE:", error?.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error?.localizedDescription)
                }
            }
        } .resume()
        
        
    }
    
}
