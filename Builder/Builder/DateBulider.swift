//
//  DateBulider.swift
//  Builder
//
//  Created by deng on 2017/6/25.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import Cocoa

class DateBulider: DateBuliderProtocole {
    
    private var component: NSDateComponents?
    
    init() {
        component = NSDateComponents()
        // default
        component?.calendar = Calendar(identifier: .gregorian)
    }
    
    func date() -> Date {
        return (component?.date)!
    }
    
    func showDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd hh:mm:ss"
        print(formatter.string(from: (component?.date)!))
    }
    
    func setCalender(identifier: Calendar.Identifier)  -> DateBulider {
        component?.calendar = Calendar(identifier: identifier)
        return self
    }
    
    func setSecond(_ second: Int) -> DateBulider {
        component?.second = second
        return self
    }
    
    func setMinute(_ minute: Int) -> DateBulider {
        component?.minute = minute
        return self
    }
    
    func setHour(_ hour: Int) -> DateBulider {
        component?.hour = hour
        return self
    }
    
    func setDay(_ day: Int) -> DateBulider {
        component?.day = day
        return self
    }
    
    func setMonth(_ month: Int) -> DateBulider {
        component?.month = month
        return self
    }
    
    func setYear(_ year: Int) -> DateBulider {
        component?.year = year
        return self
    }
}
