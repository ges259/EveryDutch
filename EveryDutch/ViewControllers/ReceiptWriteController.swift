//
//  ReceiptWriteController.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/01.
//

import UIKit
import FSCalendar

final class ReceiptWriteController: UIViewController {
    
    // MARK: - 레이아웃
    /// 달력
     private lazy var calendar: FSCalendar = {
         let calendar = FSCalendar()
         calendar.delegate = self
         // 배경 색상 설정
         calendar.backgroundColor = UIColor.normal_white
         
         // ----- 주(월/화/수/~~) -----
         // 한글로 표시
         calendar.locale = Locale(identifier: "ko_KR")
         // 폰트 크기 설정
         calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
         // 색상
         calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
         // 헤더(10월) 없애기
         calendar.headerHeight = 0
         // 주(월,화,수)와 상단의 간격 넓히기
         calendar.weekdayHeight = 40
         
         // 찾았다?
         calendar.appearance.borderRadius = .zero
         
         // 선택된 날짜의 색상
         calendar.appearance.selectionColor = UIColor.point_Blue
         // 오늘 날짜 생상
         calendar.appearance.todayColor = UIColor.base_Blue
         // 오늘 날짜 타이틀 생상
         calendar.appearance.titleTodayColor = UIColor.black
         return calendar
     }()
    
    private var timeDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    private var memoDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    private var priceDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    private var payerDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    
    private var timeInfoLbl: PaddingLabel = PaddingLabel(leftInset: 16)
    private var memoInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "메모를 입력해 주세요.")
    private var priceInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "가격을 입력해 주세요.")
    private var payerInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "계산한 사람을 선택해 주세요.")
    
    
    private lazy var timeStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var memoStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var priceStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var payerStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    
    private var memoNumOfCharLbl: UILabel = UILabel.configureLbl(
        text: "0 / 8",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView()
    
    
    private var moneyCountBtn: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 14))
    private var dutchBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)
    
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.moneyCountBtn,
                           self.dutchBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    private var addPersonBtn: UIButton =  UIButton.btnWithTitle(
        title: "✓ 계산할 사람 선택",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 22),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var clearView: UIView = {
        let view = UIView()
            view.isHidden = true
        return view
    }()
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.timeStackView,
                           self.memoStackView,
                           self.priceStackView,
                           self.payerStackView,
                           self.tableView,
                           self.btnStackView,
                           self.addPersonBtn,
                           self.clearView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    

    // UIDatePicker 정의
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        // 시간 선택 모드로 설정
        picker.datePickerMode = .time
        // iOS 14 이상에서 사용할 수 있는 스타일
        picker.preferredDatePickerStyle = .wheels
        // 초기 상태는 숨김으로 설정
        picker.isHidden = true
        return picker
    }()
    
    
    
    // MARK: - 프로퍼티
    private lazy var calendarHeight: CGFloat = (self.view.frame.width - 10) * 3 / 4
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
}

// MARK: - 화면 설정

extension ReceiptWriteController {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        // cornerRadius
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 10
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}




extension ReceiptWriteController: FSCalendarDelegate {
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        
    }
}
