//
//  CustomCalendar.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import Foundation
import FSCalendar

final class CustomCalendar: FSCalendar  {
    
    // MARK: - 헤더뷰 레이아웃
    private var customHeaderView: CustomLabel = CustomLabel(
        textColor: .black,
        font: UIFont.boldSystemFont(ofSize: 16),
        textAlignment: .center)
    
    
    
    
    // MARK: - 프로퍼티
    weak var calendarDelegate: CalendarDelegate?
    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupCustomHeaderView()
        self.configureCalendar()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 캘린더 설정
    private func configureCalendar() {
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
        // 헤더 양 옆 날짜(월) 없애기
        self.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 올해 - 1월
        self.appearance.headerTitleColor = UIColor.clear
        
        // 주(월,화,수)와 상단의 간격 넓히기
        self.weekdayHeight = 30
        
        // 찾았다?
//         calendar.appearance.borderRadius = .zero
        
        // 선택된 날짜의 색상
        self.appearance.selectionColor = UIColor.point_Blue
        // 오늘 날짜 생상
        self.appearance.todayColor = UIColor.base_Blue
        // 오늘 날짜 타이틀 생상
        self.appearance.titleTodayColor = UIColor.black
        
        self.select(Date())
        self.updateCalendarHeader()
    }
    
    
    
    // MARK: - 헤더뷰 설정
    private func setupCustomHeaderView() {
        self.calendarHeaderView.addSubview(customHeaderView)
        customHeaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}










// MARK: - 캘린더 델리게이트
extension CustomCalendar: FSCalendarDelegate {
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        let dateInt = Int(date.timeIntervalSince1970)
        
        self.calendarDelegate?.didSelectDate(dateInt: dateInt)
    }
    // MARK: - 캘린더 '월'이 바뀌었을 때
    // FSCalendarDelegate 메소드 구현
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateCalendarHeader()
    }
    
    // MARK: - 캘린더 헤더의 텍스트 설정
    func updateCalendarHeader() {
        let currentPage = self.currentPage
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentPageYear = Calendar.current.component(.year, from: currentPage)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
    
        if currentPageYear == currentYear {
            dateFormatter.dateFormat = "M월"
        } else {
            dateFormatter.dateFormat = "YYYY년 M월"
        }

        let formattedTitle = dateFormatter.string(from: currentPage)
        customHeaderView.text = formattedTitle
    }
}
