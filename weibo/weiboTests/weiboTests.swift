//
//  weiboTests.swift
//  weiboTests
//
//  Created by monkey on 2019/2/17.
//  Copyright © 2019 itcast. All rights reserved.
//

import XCTest

class weiboTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() {
        let seconds:CFTimeInterval = 360
        let time = String(format: "%d", Int(seconds / 60)) + "分钟前"
        print(time)
        // 刚刚
        let str = "Sun Feb 17 20:04:21 +0800 2019"
        print(createTime(str: str))
    }
    
    func testExample2() {
        // xx分钟前
        let str = "Sun Feb 17 19:55:21 +0800 2019"
        print(createTime(str: str))
    }
    
    func testExample3() {
        // xx小时前
        let str = "Sun Feb 17 18:00:21 +0800 2019"
        print(createTime(str: str))
    }
    
    func testExample4() {
        // 昨天
        let str = "Sun Feb 16 20:00:21 +0800 2019"
        print(createTime(str: str))
    }
    
    func testExample5() {
        // 一年内
        let str = "Sun Feb 05 20:00:21 +0800 2019"
        print(createTime(str: str))
    }
    
    func testExample6() {
        // 一年外
        let str = "Sun Feb 17 20:00:21 +0800 2016"
        print(createTime(str: str))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func createTime(str:String) -> String
    {
        guard let createDate = Date.stringToDate(dateString: str, format:  "EEE MMM dd HH:mm:ss zzz yyyy") else {
                return ""
        }
        
        let currentCalendar = Calendar.current
        if currentCalendar.isDateInToday(createDate) {
            // 今天
            let seconds = createDate.timeIntervalSinceNow * -1
            if seconds < 60 {
                return "刚刚"
            } else if seconds < 3600 {
                
                return String(format: "%d", Int(seconds / 60)) + "分钟前"
            } else {
                return String(format: "%d", Int(seconds / 3600)) + "小时前"
            }
        } else if currentCalendar.isDateInYesterday(createDate) {
            // 昨天
            return "昨天" + createDate.formatString(format: "HH:mm")
        } else {
            // 一年内或是超出一年
            let year = (currentCalendar.dateComponents(Set(arrayLiteral: Calendar.Component.year), from: createDate, to: Date()).year ?? 0)
            let format = year < 1 ? "MM-dd HH:mm" : "yyyy-MM-dd HH:mm"
            return createDate.formatString(format: format)
        }
    }

}
