//
//  DateBuliderProtocole.swift
//  Builder
//
//  Created by deng on 2017/6/25.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

import Cocoa

protocol DateBuliderProtocole: class {
    
    func date() -> Date
    
    func showDate()
    
    func setCalender(identifier: Calendar.Identifier)  -> DateBulider
    
    func setSecond(_ second: Int) -> DateBulider
    
    func setMinute(_ minute: Int) -> DateBulider
    
    func setHour(_ hour: Int) -> DateBulider
    
    func setDay(_ day: Int) -> DateBulider
    
    func setMonth(_ month: Int) -> DateBulider
    
    func setYear(_ year: Int) -> DateBulider

}
