//
//  WQDate+Compare.swift
//  Pods
//
//  Created by hejinyin on 2018/1/26.
//

import Foundation

public let oneMinuteSeconds: TimeInterval = 60
public let oneHourSeconds: TimeInterval = 60 * oneMinuteSeconds
public let oneDaySeconds: TimeInterval = 24 * oneHourSeconds
public let oneWeekSeconds: TimeInterval = 7 * oneDaySeconds

public extension Date {
    
    func year(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.year, from: self)
    }
    
    func month(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.month, from: self)
    }
    
    func day(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.day, from: self)
    }
    
    func hour(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.hour, from: self)
    }
    
    func minute(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.minute, from: self)
    }
    
    func second(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.second, from: self)
    }
    
    func weekday(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.weekday, from: self)
    }
    
    func weekOfYear(_ calendar: Calendar = .current) -> Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    func timeZone(_ calendar: Calendar = .current) -> TimeZone {
        return calendar.dateComponents([.timeZone], from: self).timeZone!
    }
}
// MARK: - Calculate
public extension Date {
    
    // https://www.hangge.com/blog/cache/detail_1223.html
    /// calculate date 根据一年的第几周推算出这周的起始日期
    ///
    /// - Parameters:
    ///   - week: ordinality of week in year
    ///   - weekDay: day of the week (1~7 从周日开始)
    ///   - year: in year
    ///   - calendar: caculate calendar
    /// - Returns: the first day in week (Sun)
    init?(week: Int, in year: Int, with calendar: Calendar = .current) {
        let  dateComponments = DateComponents(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        guard let start = calendar.date(from: dateComponments) else {
            return nil
        }
        let component = calendar.component(.weekday, from: start)
        let interval = (week - 1) * 7 - (component - 1)
        guard let date = calendar.date(byAdding: .day, value: interval, to: start) else {
            return nil
        }
        self = date
    }

    /// distance unit counts between two date
    ///
    /// - Parameters:
    ///   - endDate: another date
    ///   - unit: calculation calendar  unit
    ///   - calendar: calendar
    /// - Returns: distance
    func distance(_ endDate: Date,
                  at unit: Calendar.Component = .day,
                  with calendar: Calendar = .current) -> Int {
        var startComp = calendar.dateComponents(Date.commentFlags, from: self)
        var endComp = calendar.dateComponents(Date.commentFlags, from: endDate)
        var clearCmps: [Calendar.Component] = []
        switch unit {
        case .era:
            clearCmps = [.year, .month, .day, .hour, .minute, .second, .nanosecond]
        case .year:
            clearCmps = [.month, .day, .hour, .minute, .second, .nanosecond]
        case .month:
            clearCmps = [.day, .hour, .minute, .second, .nanosecond]
        case .day:
            clearCmps = [.hour, .minute, .second, .nanosecond]
        case .hour:
            clearCmps = [.minute, .second, .nanosecond]
        case .minute:
            clearCmps = [.second, .nanosecond]
        case .second:
            clearCmps = [.nanosecond]
        default:
            clearCmps = []
        }
        for cmp in clearCmps {
            startComp.setValue(0, for: cmp)
            endComp.setValue(0, for: cmp)
        }
        let deltComponments = calendar.dateComponents([unit], from: startComp, to: endComp)
        guard let value = deltComponments.value(for: unit) else {
            return 0
        }
        return value
    }
    typealias DateUnitRange = (begin: Date, length: TimeInterval)

    /// Calculate begin date and interval in date unit of self
    ///
    /// - Parameters:
    ///   - unit: date unit
    ///   - calendar: default current
    /// - Returns: Tuple contains begin date and interval
    func range(_ unit: Calendar.Component,
               with calendar: Calendar = .current) -> DateUnitRange {
        var startDate: Date = self
        var interval: TimeInterval = 0
        var success = false
        if #available(iOS 10.0, *) {
            if let dateInterval = calendar.dateInterval(of: unit, for: self) {
                startDate = dateInterval.start
                interval = dateInterval.duration
                success = true
            }
        } else {
            success = calendar.dateInterval(of: unit, start: &startDate, interval: &interval, for: self)
        }
        if !success {
           return _range(unit, with: calendar)
        } else {
            return (begin: startDate, length: interval)
        }
    }
    private func _range(_ unit: Calendar.Component,
                        with calendar: Calendar = .current) -> DateUnitRange {
        var startDate: Date = self
        var interval: TimeInterval = 0
        var components = calendar.dateComponents(Date.commentFlags, from: self)
        var endComponents = components
        // swiftlint:disable fallthrough
        switch unit {
        case .year:
            components.month = 1; endComponents.month = 12
            fallthrough
        case .month:
            let days = calendar.range(of: .day, in: .month, for: self)!.count
            components.day = 1; endComponents.day = days
            fallthrough
        case .day, .weekday:
            components.hour = 0; endComponents.hour = 23
            fallthrough
        case .hour:
            components.minute = 0; endComponents.minute = 59
            fallthrough
        case .minute:
            components.second = 0; endComponents.second = 59
            fallthrough
        default:
            break
        }
        startDate = calendar.date(from: components)!
        var endDate = calendar.date(from: endComponents)!
        if unit == .weekday {
            let weekDay = components.weekday!
            startDate -= TimeInterval(weekDay) * oneDaySeconds
            endDate += TimeInterval(7 - weekDay) * oneDaySeconds
        }
        interval = endDate.timeIntervalSince(startDate)
        return (begin: startDate, length: interval)
    }
    
    /// min seconds in date unit
    /// 计算一周的开始以及结束时间点用weekOfYear
    ///
    /// - Returns: min date in unit
    func start(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        return range(unit, with: calendar).begin
    }
    
    /// max seconds in date unit
    /// 计算一周的开始以及结束时间点用weekOfYear
    ///
    /// - Returns: max date in unit
    func end(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        let dateUnit = range(unit, with: calendar)
        return dateUnit.begin + TimeInterval(dateUnit.length - 1)
    }
    
    /// 前一个日期
    func previous(_ unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        let beforeDate = start(unit, in: calendar)
        let interval = beforeDate.addingTimeInterval(-1).range(unit, with: calendar).length
        return beforeDate - interval
    }
    func next(date unit: Calendar.Component, in calendar: Calendar = .current) -> Date {
        return end(unit, in: calendar) + 1
    }

    /// smaller unit counts in larger unit
    ///
    /// - Parameters:
    ///   - unit: smaller unit
    func counts(_ unit: Calendar.Component, in larger: Calendar.Component = .nanosecond, with calendar: Calendar = .current) -> Int {
        var bigUnit: Calendar.Component
        if larger == .nanosecond {
            switch unit {
            case .second:
                bigUnit = .minute
            case .minute:
                bigUnit = .hour
            case .hour:
                bigUnit = .day
            case .day, .weekOfMonth:
                bigUnit = .month
            case .month, .weekOfYear:
                bigUnit = .year
            default:
                fatalError("此类型的单位计算不支持")
            }
        } else {
            bigUnit = larger
        }

        guard let counts = calendar.range(of: unit, in: bigUnit, for: self) else {
            return 0
        }
        return counts.upperBound - counts.lowerBound
    }
    
    /// Calculate the date in unit(每个日历单元都可相加相减会自动向大一个位的日历单元进1或减1)
    ///
    /// - Parameters:
    ///   - counts: calculate count , may be negative
    ///   - unit: unit of measurement
    ///   - calendar:default current
    /// - Returns: calculated date
    func dateByAdding(_ counts: Int, unit: Calendar.Component, with calendar: Calendar = .current) -> Date {
        var components = DateComponents()
        components.setValue(counts, for: unit)
        return calendar.date(byAdding: components, to: self)!
    }
}

// MARK: - Compare
public extension Date {
    
    func isToday(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    func isYesterday(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    
    func isTomorrow(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    func isWeekend(with calendar: Calendar = .current) -> Bool {
        return calendar.isDateInWeekend(self)
    }
    
    func isWorkday(with calendar: Calendar = .current) -> Bool {
        return !isWeekend(with: calendar)
    }
    
    func isThisWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    func isNextWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date() + oneWeekSeconds, toGranularity: .weekOfYear)
    }
    
    func isLastWeek(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date() - oneWeekSeconds, toGranularity: .weekOfYear)
    }
    
    func isThisMonth(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    func isNextMonth(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(1, unit: .month, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    
    func isLastMonth(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(-1, unit: .month, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    
    func isThisYear(with calendar: Calendar = .current) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    func isNextYear(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(1, unit: .year, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    
    func isLastYear(with calendar: Calendar = .current) -> Bool {
        let nextDate = Date().dateByAdding(-1, unit: .year, with: calendar)
        return calendar.isDate(self, equalTo: nextDate, toGranularity: .month)
    }
    
    private static let commentFlags: Set<Calendar.Component> = [
        .second,
        .minute,
        .hour,
        .day,
        .month,
        .year,
        .weekOfYear,
        .weekday,
        .timeZone]
}

// MARK: - --equal
public extension Date {
    func isSame(_ otherDate: Date, unit: Calendar.Component = .day, calendar: Calendar = Calendar.current) -> Bool {
        let cmps = calendar.dateComponents(in: calendar.timeZone, from: self)
        let otherCmps = calendar.dateComponents(in: calendar.timeZone, from: otherDate)
        // 当前比较的单元相同才往下走
        guard cmps.value(for: unit) == otherCmps.value(for: unit) else { return false }
        let units = self.compareUnits(for: unit)
        for cmp in units {
            if cmps.value(for: cmp) != otherCmps.value(for: cmp) {
                return false
            }
        }
        return true
    }
    private func compareUnits(for unit: Calendar.Component) -> [Calendar.Component] {
        var units: [Calendar.Component]
        switch unit {
        case .nanosecond:
            units = [.year, .month, .day, .hour, .minute, .second]
        case .second:
            units = [.year, .month, .day, .hour, .minute]
        case .minute:
            units = [.year, .month, .day, .hour]
        case .hour:
            units = [.year, .month, .day]
        case .day:
            units = [.year, .month]
        case .month:
            units = [.year]
        case .year, .era, .timeZone:
            units = []
        case .weekday: // 1~7,1表示周日 若要比较就比较是否在同一天
            units = []
        case .weekdayOrdinal: // 一个月中的第几周 以7天为单位，范围为1-5 （1-7号为第1个7天，8-14号为第2个7天...） 通常与weekday合用
             units = [.year, .month]
        case .quarter: // 刻钟单位。范围为1-4 （1刻钟等于15分钟）
            units = [.year, .month, .day, .hour]
        case .weekOfMonth: // 月包含的周数。最多为6个周
             units = []
        case .weekOfYear: // 年包含的周数。最多为53个周
             units = []
        case .yearForWeekOfYear: // let comps = DateComponents(weekday: 6, weekOfYear: 1, yearForWeekOfYear: 2016)
           units = []
        default:
            units = []
        }
        return units
    }
}
//https://www.hackingwithswift.com/example-code/language/how-to-use-available-to-deprecate-old-apis
