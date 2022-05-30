//
//  Calendar+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/6/21.
//

import Foundation
public extension Calendar {
    func numberOfDaysInYear(for date: Date) -> Int {
        return range(of: .day, in: .year, for: date)!.count
    }
}
