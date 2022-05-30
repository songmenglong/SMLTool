//
//  Date+Convenience .swift
//  Pods
//
//  Created by WQ on 2019/8/15.
//

import Foundation

public extension Date {
    
    func nextDay(with calendar: Calendar = .current) -> Date {
       return self.nextUnit(.day, with: calendar)
    }
    
    func nextWeek(with calendar: Calendar = .current) -> Date {
       return self.nextUnit(.weekOfYear, with: calendar)
    }
    
    func nextMonth(with calendar: Calendar = .current) -> Date {
       return self.nextUnit(.month, with: calendar)
    }
    
    func nextYear(with calendar: Calendar = .current) -> Date {
       return self.nextUnit(.year, with: calendar)
    }
    
    func previousDay(with calendar: Calendar = .current) -> Date {
        return self.previousUnit(.day, with: calendar)
    }
    
    func previousWeek(with calendar: Calendar = .current) -> Date {
        return self.previousUnit(.weekOfYear, with: calendar)
    }
    
    func previousMonth(with calendar: Calendar = .current) -> Date {
        return self.previousUnit(.month, with: calendar)
    }
    
    func previousYear(with calendar: Calendar = .current) -> Date {
        return self.previousUnit(.year, with: calendar)
    }
    
    private func nextUnit(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        return self.dateByAdding(1, unit: unit, with: calendar)
    }
    
    private func previousUnit(_ unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        return self.dateByAdding(-1, unit: unit, with: calendar)
    }
}
