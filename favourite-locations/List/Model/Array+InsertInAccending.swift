//
//  Array + InsertIndex.swift
//  favourite-locations
//
//  Created by Ирек Хабибуллин on 10.01.2023.
//

import Foundation

extension Array where Element == Location {
    
    func insertIndexInAccending(_ elem: Location) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi) / 2
            if self[mid].name.lowercased() < elem.name.lowercased() {
                lo = mid + 1
            } else if elem.name.lowercased() < self[mid].name.lowercased() {
                hi = mid - 1
            } else {
                return mid
            }
        }
        return lo
    }
    
    mutating func insertInAccending(_ elem: Location) {
        self.insert(elem, at: insertIndexInAccending(elem))
    }
}
