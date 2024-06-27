//
//  LocationManager.swift
//  GeoLocationE2
//
//  Created by Kadeem Cherman on 2024-06-26.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        // Start updating location only if authorized
           }
           
           private func checkLocationAuthorization() {
               switch manager.authorizationStatus {
               case .notDetermined:
                   manager.requestWhenInUseAuthorization()
               case .restricted, .denied:
                   print("Location access was restricted or denied.")
               case .authorizedWhenInUse, .authorizedAlways:
                   manager.startUpdatingLocation()
               @unknown default:
                   print("Unknown authorization status.")
               }
           }
       }

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.checkLocationAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            guard let location = locations.last else { return }
         self.userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            switch (error as NSError).code {
            case CLError.locationUnknown.rawValue:
                print("Location unknown.")
            case CLError.denied.rawValue:
                print("Access to location services denied.")
            case CLError.network.rawValue:
                print("Network error occurred.")
            default:
                print("Failed to find user's location: \(error.localizedDescription)")
            }
        }
    }
}
