//
//  LocationManager.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/02/04.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    let manager = CLLocationManager()
    private let notificationCenter = NotificationCenter.default

    private override init() {}

    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationManagerAuthorization()
        } else {
            setupNotificationCenter(object: ["error": true])
        }
    }

    func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationManagerAuthorization() {
        switch authorizationStatus() {
        case .notDetermined:
            print("Auth: notDetermined")
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Auth: authorizedWhenInUse")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Auth: denied")
            setupNotificationCenter(object: ["error": true])
        default:
            setupNotificationCenter(object: ["error": true])
        }
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus

        if #available(iOS 14.0, *) {
            status = CLLocationManager().authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        return status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let object: [String: Any] = [
                "error": false,
                "location": location
            ]
            DispatchQueue.main.async {
                self.setupNotificationCenter(object: object)
            }
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationService()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }

    func setupNotificationCenter(object: Any? = nil) {
        notificationCenter.post(name: .sharedLocation, object: object)
    }
}
