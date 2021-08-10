//
//  CLPlaceMark+Extension.swift
//  TiseLocationManager
//
//  Created by Ashraf Uddin on 10/8/21.
//

import CoreLocation
extension CLPlacemark {
    var humanReadable: String {
        guard let location = location else {
            return ""
        }
        
        switch location.horizontalAccuracy {
        case kCLLocationAccuracyHundredMeters:
            return [thoroughfare, subThoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
        
        default:
            return [subLocality, locality]
                .compactMap { $0 }
                .joined(separator: ", ")
        }
    }
}
