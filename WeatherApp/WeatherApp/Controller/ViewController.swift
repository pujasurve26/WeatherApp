//
//  ViewController.swift
//  WeatherApp
//
//  Created by Puja Kalpesh Surve on 22/11/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var txtEnterCity: UITextField!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblShowWeatherLabel: UILabel!
    @IBOutlet weak var lblCityNameLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent()
    }
    
    func setContent() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
        
        txtEnterCity.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func getWeather(city: String) {
        
        let objWebservice = WebService()
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .white
        activity.center = view.center
        view.addSubview(activity)
        
        activity.startAnimating()
        objWebservice.callAPI(city: city) { response, error in
            activity.stopAnimating()
            if response != nil {
                self.lblShowWeatherLabel.text = String(response?.main?.temp ?? 0.0) + "° C"
                self.lblCityNameLabel.text = response?.name
            }
            else {
                let alert = UIAlertController(title: "Weather App", message: "Please enter valid city name and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func btnSearchTapped(_ sender: Any) {
        if txtEnterCity.text!.isEmpty {
            let alert = UIAlertController(title: "Weather App", message: "Please enter city.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let city = txtEnterCity.text ?? ""
            getWeather(city: city)
            txtEnterCity.endEditing(true)
            txtEnterCity.text = ""
        }
    }
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingHeading()
        let location = locations.last! as CLLocation
        CLGeocoder().reverseGeocodeLocation(location) { arrPlaces, error in
            if let arr = arrPlaces {
                self.getWeather(city: arr[0].locality ?? "")
            }
            else {
                print("Error: ", error?.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingHeading()
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        
        if range.location == 0 {
            txtEnterCity.text = string.capitalizeFirstLetter()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let city = txtEnterCity.text ?? ""
        getWeather(city: city)
        txtEnterCity.text = ""
        txtEnterCity.endEditing(true)
        return true
    }
}

extension String {
      func capitalizeFirstLetter() -> String {
           return self.prefix(1).capitalized + dropFirst()
      }
 }
