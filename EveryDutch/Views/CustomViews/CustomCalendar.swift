//
//  CustomCalendar.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation
import FSCalendar

final class CustomCalendar: FSCalendar  {
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.delegate = self
        // 배경 색상 설정
        self.backgroundColor = UIColor.normal_white
        
        // ----- 주(월/화/수/~~) -----
        // 한글로 표시
        self.locale = Locale(identifier: "ko_KR")
        // 폰트 크기 설정
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
        // 색상
        self.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
        // 헤더(10월) 없애기
//         calendar.headerHeight = 0
        // 헤더 양 옆 날짜(월) 없애기
        self.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // MARK: - Fix
        // 올해 - 1월
        // 작년 or 내년 - 2023년 12월
        self.appearance.headerDateFormat = "YYYY년 M월"
        self.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        self.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
        self.appearance.headerTitleAlignment = .center
        
        
        // 주(월,화,수)와 상단의 간격 넓히기
        self.weekdayHeight = 35
        
        // 찾았다?
//         calendar.appearance.borderRadius = .zero
        
        // 선택된 날짜의 색상
        self.appearance.selectionColor = UIColor.point_Blue
        // 오늘 날짜 생상
        self.appearance.todayColor = UIColor.base_Blue
        // 오늘 날짜 타이틀 생상
        self.appearance.titleTodayColor = UIColor.black
        
        self.select(Date())
    }
    
    
    
    
}
extension CustomCalendar: FSCalendarDelegate {
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        
    }
}
