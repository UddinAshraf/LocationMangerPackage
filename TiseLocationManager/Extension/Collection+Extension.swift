//
//  Collection+Extension.swift
//  TiseLocationManager
//
//  Created by Ashraf Uddin on 9/8/21.
//

import Foundation

// MARK: Safe subscripting
extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
