//
//  CalendarDelegate.swift
//  EveryDutch
//
//  Created by 계은성 on 1/24/24.
//

import Foundation


protocol CalendarDelegate: AnyObject {
    func didSelectDate(date: Date)
}
