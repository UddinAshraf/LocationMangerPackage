//
//  TiseLocationManager.swift
//  TiseLocationManager
//
//  Created by Ashraf Uddin on 9/8/21.
//


import Foundation
import CoreLocation
import UIKit
import MapKit

enum LocationErrors: Error {
    case denied
    case restricted
    case notDetermined
    case notFetched
    case invalidLocation
    case reverseGeocodingFailed
    case unknown
}

class Locator: NSObject {
    
    static let shared = Locator()
    
    typealias LocationCallback = ((_ location: CLLocation?,_ error: Error?) -> Void)
    private var locationCompletion: LocationCallback?
    private var locationManager: CLLocationManager?
    var locationAccuracy = kCLLocationAccuracyBest
    
    typealias reverseGeoLocationCallBack = ((_ placemark: CLPlacemark?,_ error: Error?) -> Void)
    private var geoLocationCompletion: reverseGeoLocationCallBack?
    
    private var lastLocation: CLLocation?
    private override init() {}
    
    deinit {
        resetLocationManager()
    }
    
    private func setupLocationManager() {
        
        //Setting of location manager
        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = locationAccuracy
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
    }
    
    private func resetLocationManager() {
        locationManager?.delegate = nil
        locationManager = nil
        lastLocation = nil
    }
    
    private func didComplete(location: CLLocation?, error: Error?) {
        locationManager?.stopUpdatingLocation()
        locationCompletion?(location, error)
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    private func didComplete(placemark: CLPlacemark?, error: Error?) {
        locationManager?.stopUpdatingLocation()
        geoLocationCompletion?(placemark, error)
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    private func sendLocation() {
        guard let _ = lastLocation else {
            didComplete(location: nil, error: LocationErrors.notFetched)
            lastLocation = nil
            return
        }
        self.didComplete(location: lastLocation, error: nil)
        lastLocation = nil
    }
    
    
    //MAARK: public methods
    func isLocationServiceEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func getCurrentLocation(completionHandler: @escaping LocationCallback) {
        
        //Resetting last location
        lastLocation = nil
        
        self.locationCompletion = completionHandler
        setupLocationManager()
    }
    
    func getPlacemark(with location: CLLocation, completionHandler: @escaping reverseGeoLocationCallBack) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                self.didComplete(placemark: nil, error: error)
                return
            }
            if let placemark = placemarks?[safe: 0] {
                self.didComplete(placemark: placemark, error: nil)
            } else {
                if(!CLGeocoder().isGeocoding){
                    CLGeocoder().cancelGeocode()
                }
                self.didComplete(placemark: nil, error: nil)
            }
        }
    }
}

//MARK: CLLocationManagerDelegate
extension Locator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        if let location = locations.last {
            let locationAge = -(location.timestamp.timeIntervalSinceNow)
            guard locationAge < 5.0 else {
                return
            }
            if location.horizontalAccuracy < 0 {
                self.locationManager?.stopUpdatingLocation()
                self.locationManager?.startUpdatingLocation()
                return
            }
            sendLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.didComplete(location: nil, error: error as NSError?)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager?.startUpdatingLocation()
        case .denied:
            didComplete(location: nil, error: LocationErrors.denied)
        case .restricted:
            didComplete(location: nil, error: LocationErrors.restricted)
            
        case .notDetermined:
            self.locationManager?.requestLocation()
            
        @unknown default:
            didComplete(location: nil, error: LocationErrors.unknown)
        }
    }
}

