//
//  LocationManager.swift
//  TiseLocationManager
//
//  Created by Ashraf Uddin on 10/8/21.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private var placemark: CLPlacemark?
    private var cachedPlacemark: CLPlacemark? {
        get {
            if let data = UserDefaults.standard.data(forKey: "com.tiseit.previous-placemark") {
                do {
                    if let placemark = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CLPlacemark {
                        return placemark
                    }
                } catch {
                    return nil
                }
                
            }
            
            return nil
        }
        set {
            if let newPlacemark = newValue {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: newPlacemark, requiringSecureCoding: false)
                    UserDefaults.standard.set(data, forKey: "com.tiseit.previous-placemark")
                } catch {
                    UserDefaults.standard.set(nil, forKey: "com.tiseit.previous-placemark")
                }
                
            } else {
                UserDefaults.standard.set(nil, forKey: "com.tiseit.previous-placemark")
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    
    //MARK: Location management
    func refresh(showRequestOnFailure: Bool = true, from viewController: UIViewController? = nil) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                LocationManager.getCurrentLocation { placemark, error in
                    if let placemark = placemark, error == nil {
                        self.setLocation(placemark)
                    } else if error != nil || placemark == nil {
                        // If we failed getting a location automatically and not inBackground, present the request VC so the user can choose manually.
                        guard showRequestOnFailure else {
                            return
                        }
                        
                        self.presentLocationRequestViewController(from: viewController)
                        
                    }
                }
                
            case .notDetermined, .denied, .restricted:
                guard showRequestOnFailure else {
                    return
                }
                
            //self.presentLocationRequestViewController(from: viewController)
            @unknown default:
                break
            }
        }
    }
    
    func presentLocationRequestViewController(from viewController: UIViewController?) {
        //Handle it later with completion handler
        //        let requestVc = LocationRequestViewController.instantiate(isOptional: false, oldLocation: location(), completion: { placemark in
        //            if let placemark = placemark {
        //                self.setLocation(placemark)
        //            }
        //        })
        //
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        //            let root = UIApplication.shared.keyWindow?.rootViewController
        //            requestVc.modalPresentationStyle = .fullScreen
        //            root?.present(requestVc, animated: true, completion: nil)
        //        }
        
    }
    
    // Attempts to get current location and decode it to a placemark. Caller needs to handle permission status.
    static func getCurrentLocation(_ completion: @escaping (CLPlacemark?, Error?) -> Void) {
        let locator = Locator.shared
        locator.getCurrentLocation { (location, error) in
            guard let location = location, error == nil else {
                completion(nil, error)
                return
            }
            
            locator.getPlacemark(with: location) { (placemark, error) in
                if let placemark = placemark {
                    completion(placemark, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func setLocation(_ newPlacemark: CLPlacemark) {
        let oldPlacemark = placemark?.copy() as? CLPlacemark
        
        // Store it to the server
        //Handle it later using callback
        //API.request(.updateLocation(newPlacemark))
        
        // If we have someone waiting for an location, notify them
        locationCallback?(newPlacemark)
        locationCallback = nil
        
        // Finally, set them and store them
        placemark = newPlacemark
        cachedPlacemark = newPlacemark
        
        // Notify people we have moved far enough to refresh
        if let oldLocation = oldPlacemark?.location, let newLocation = placemark?.location, oldLocation.distance(from: newLocation) > 1000 {
            //Handle it later
            //NotificationCenter.default.post(name: .locationUpdate, object: newPlacemark)
        }
        if oldPlacemark == nil {
            //Handle it later
            //NotificationCenter.default.post(name: .locationUpdate, object: newPlacemark)
        }
    }
    
    func clearCachedLocation() {
        placemark = nil
        cachedPlacemark = nil
    }
    
    var locationCallback: ((CLPlacemark) -> Void)?
    @discardableResult func location(_ callback: ((CLPlacemark) -> Void)? = nil) -> CLPlacemark? {
        if let location = placemark ?? cachedPlacemark {
            callback?(location)
        } else {
            locationCallback = callback
        }
        
        return placemark ?? cachedPlacemark
    }
    
    // MARK: Static getters
    @objc static var countryCode: String? {
        return LocationManager.shared.location()?.isoCountryCode
    }
    
    static var coordinate: CLLocationCoordinate2D? {
        return LocationManager.shared.location()?.location?.coordinate
    }
    
    @objc static var current: CLPlacemark? {
        return LocationManager.shared.location()
    }
   
    @objc static var callingCode: String? {
        guard let countryCode = countryCode, let callingCode = Locale.isoCallingCodes[countryCode] else { return nil }
        return String(callingCode)
    }
    
}
