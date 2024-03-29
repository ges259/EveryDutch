//
//  Date+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit

extension Date {
    static func IntegerToString(_ timeInteger: Int) -> [String] {
        
        var dateArray: [String] = []
        
        // Int 타입의 타임스탬프를 Date 객체로 변환합니다.
        let date = Date(timeIntervalSince1970: TimeInterval(timeInteger))
        
        // 날짜를 포맷하기 위한 DateFormatter를 생성합니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy - MM - dd"
        let dateStr = dateFormatter.string(from: date)
        
        // 시간을 포맷하기 위한 DateFormatter를 생성합니다.
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH : mm"
        let timeStr = timeFormatter.string(from: date)
        
        dateArray.append(dateStr)
        dateArray.append(timeStr)
        
        return dateArray
    }
    
    static func returnYearString(date: Date = Date()) -> String {
        // Int값으로 바꾸기
//        let timeInteger = Int(date.timeIntervalSince1970)
        
        // Int 타입의 타임스탬프를 Date 객체로 변환합니다.
//        let date = Date(timeIntervalSince1970: TimeInterval(timeInteger))
        
        // 날짜를 포맷하기 위한 DateFormatter를 생성합니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy - MM - dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    static func returnCurrenTime() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H : mm"
        let timeStr = timeFormatter.string(from: date)
        return timeStr
    }
    
    
    func returnErrorLogType() -> String {
        // 현재 시간을 String타입으로 가져오기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        // 한국 시간대 지정
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: Date())
    }
    
}
