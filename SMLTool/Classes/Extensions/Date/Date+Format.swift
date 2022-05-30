//
//  WQDate+Format.swift
//  
//
//  Created by hejinyin on 2018/1/21.
//  swiftlint:disable identifier_name

import Foundation

/// A:表示`-` B表示 `:` C表示` ` 1表示`/` k表示4个y
public enum DateFormatEnum: String {
    /// yyyy
    case k
    /// yyyy年
    case k年

    /// yyyy-MM
    case kAMM
    /// yyyy/MM
    case k1MM
    /// yyyy年MM月
    case k年MM月

    /// yyyy-MM-dd
    case kAMMAdd
    /// yyyy/MM/dd
    case k1MM1dd
    /// yyyy年MM月dd日
    case k年MM月dd日

    /// yyyyMMddHHmm
    case kMMddHHmm
    /// yyyy-MM-dd HH:mm
    case kAMMAddCHHBmm
    /// yyyy/MM/dd HH:mm
    case k1MM1ddCHHBmm
    /// yyyy年MM月dd日HH时mm分
    case k年MM月dd日HH时mm分

    /// yyyyMMddHHmmss
    case kMMddHHmmss
    /// yyyy-MM-dd HH:mm:ss
    case kAMMAddCHHBmmBss
    /// yyyy/MM/dd HH:mm:ss
    case k1MM1ddCHHBmmBss
    /// yyyy年MM月dd日HH时mm分ss秒
    case k年MM月dd日HH时mm分ss秒
    /// M
    case M
    /// M月
    case M月

    /// MM
    case MM
    /// MM
    case MM月

    /// MM-dd
    case MMAdd
    /// MM/dd
    case MM1dd
    /// MM月dd日
    case MM月dd日

    /// MM-dd HH:ss
    case MMAddCHHBss
    /// MM/dd HH:ss
    case MM1ddCHHBss
    /// MM月dd日HH时mm分
    case MM月dd日HH时mm分

    /// MM-dd HH:mm:ss
    case MMAddCHHBmmBss
    /// MM/dd HH:mm:ss
    case MM1ddCHHBmmBss
    /// MM月dd日HH时mm分ss秒
    case MM月dd日HH时mm分ss秒

    /// d
    case d
    /// d日
    case d日

    /// dd
    case dd
    /// dd日
    case dd日

    case HH
    case HH时

    /// HH:mm
    case HHBmm
    /// HH时mm分
    case HH时mm分

    /// HH:mm:ss
    case HHBmmBss
    /// HH时mm分ss秒
    case HH时mm分ss秒

    case E

    public var formatString: String {
            var format = rawValue
            do {
                let regularExpression = try NSRegularExpression(pattern: "[ABCk1]{1}", options: [])
                let matchRange = NSRange(location: 0, length: rawValue.count)
                let results = regularExpression.matches(in: rawValue, options: [], range: matchRange)
                format = results.reversed().reduce(rawValue, { fmtStr, result -> String in
                    let start = fmtStr.index(fmtStr.startIndex, offsetBy: result.range.location)
                    let end = fmtStr.index(start, offsetBy: result.range.length)
                    let range = start ..< end

                    let match = fmtStr[range]
                    var replaceStr: String
                    switch match {
                    case "A":
                        replaceStr = "-"
                    case "B":
                        replaceStr = ":"
                    case "C":
                        replaceStr = " "
                    case "k":
                        replaceStr = "yyyy"
                    case "1":
                        replaceStr = "/"
                    default:
                        replaceStr = String(match)
                    }
                    let resultStr = fmtStr.replacingOccurrences(of: match, with: replaceStr, options: [], range: range)
                    return resultStr
                })
            } catch {
                debugPrint(error)
            }
            return format
    }
}

public extension Date { // MARK: 日期格式化
    /// convert date to string
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: date string
    func toString(_ format: DateFormatEnum, in calendar: Calendar = .current) -> String {
        return toString(format.formatString, in: calendar)
    }

    func toString(_ format: String, in calendar: Calendar = .current) -> String {
        let fortmatter = DateFormatter()
        fortmatter.dateFormat = format
        fortmatter.calendar = calendar
        return fortmatter.string(from: self)
    }
}
public extension String { // MARK: 字符串转日期

    /// convert date format string to date
    ///
    /// - Parameter dateFormat: enum dateFormatString
    /// - Returns: if error return now date
    func toDate(format dateFormat: DateFormatEnum, in calendar: Calendar = .current) -> Date? {
       return toDate(dateFormat.formatString, in: calendar)
    }
    func toDate(_ format: String, in calendar: Calendar = .current) -> Date? {
        let fortmatter = DateFormatter()
        fortmatter.dateFormat = format
        fortmatter.calendar = calendar
        return fortmatter.date(from: self)
    }
}

public extension Double {

    /// 中间符号连接形式
    @available(*, unavailable)
    func toDuration(connect hour_minute: String, minute_second: String? = nil) -> String {
        let compments = Int(self).toDurationCompments
        var fmtString: String = String(compments[0] * 24 + compments[1])
        fmtString += hour_minute
        if minute_second != nil {
           fmtString += String(compments[2])
           fmtString += minute_second! + String(compments[3])
        } else {
           fmtString += String(compments[2] + Int(Double(compments[3]) / 60.0 ))
        }
        return fmtString
    }
    //https://nshipster.com/formatter/#dateintervalformatter
    /**
     * unitsStyle
     - brief: 2wks 6days 20hr 0min 0sec
     - positional: 2w 6d 20:00:00
     - abbreviated: 2w 6d 20h 0m 0s
     - short: 2 wks, 6 days, 20 hr, 0 min, 0 sec
     - full: 2 weeks, 6 days, 20 hours, 0 minutes, 0 seconds
     - spellOut: two weeks, six days, twenty hours, zero minutes, zero seconds
     */
    func duration(_ units: NSCalendar.Unit = [.minute, .second]) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self)!
    }

    ///
    /// 数字自定义转成时长格式
    ///
    /// - Parameter format: dd天HH小时mm分钟sss秒
    /// - Returns: 格式化之后的时长
    func toDuration(_ format: String, timeZone: TimeZone = .current) -> String {
       return self.toDate(timeZone).toString(format)
    }

    /// 配合 MeasurementFormatter 转换为想要的格式
    @available(iOS 10.0, *)
    func seconds(to unit: UnitDuration) -> Measurement<UnitDuration> {
        return Measurement(value: self, unit: UnitDuration.seconds).converted(to: unit)
    }
    /// 将时间秒数转成UTC时间
    func toDate(_ timeZone: TimeZone = .current) -> Date {
        let date = Date(timeIntervalSince1970: self)
        let interval = TimeInterval(timeZone.secondsFromGMT(for: date))
        return date.addingTimeInterval(-interval)
    }
}

public extension Int {
    /// 将时间秒数转成UTC时间
    func toDate(_ timeZone: TimeZone = .current) -> Date {
        return TimeInterval(self).toDate(timeZone)
    }
    /// 将UTC的时间秒数
    var toUTCDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

private extension Int {
    var toDurationCompments: [Int] {
        var value = self
        let day = value / 86_400
        value -= day * 86_400
        let hour = value / 3600
        value -= hour * 3600
        let minute = value / 60
        value -= minute * 60
        let seconds = value
        return [day, hour, minute, seconds]
    }
}
