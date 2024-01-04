//
//  ReceiptWriteController.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/01.
//

import UIKit
import SnapKit
import FSCalendar

final class ReceiptWriteVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
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
//         calendar.headerHeight = 0
         // 헤더 양 옆 날짜(월) 없애기
         calendar.appearance.headerMinimumDissolvedAlpha = 0.0
         
         // MARK: - Fix
         // 올해 - 1월
         // 작년 or 내년 - 2023년 12월
         calendar.appearance.headerDateFormat = "YYYY년 M월"
         calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
         calendar.appearance.headerTitleColor = UIColor(named: "FFFFFF")?.withAlphaComponent(0.9)
         calendar.appearance.headerTitleAlignment = .center
         
         
         // 주(월,화,수)와 상단의 간격 넓히기
         calendar.weekdayHeight = 35
         
         // 찾았다?
//         calendar.appearance.borderRadius = .zero
         
         
         // 선택된 날짜의 색상
         calendar.appearance.selectionColor = UIColor.point_Blue
         // 오늘 날짜 생상
         calendar.appearance.todayColor = UIColor.base_Blue
         // 오늘 날짜 타이틀 생상
         calendar.appearance.titleTodayColor = UIColor.black
         return calendar
     }()
    
    private lazy var timeDetailLbl: PaddingLabel = PaddingLabel(
        leftInset: 35,
        backgroundColor: UIColor.medium_Blue)
    private lazy var memoDetailLbl: PaddingLabel = PaddingLabel(
        leftInset: 35,
        backgroundColor: UIColor.medium_Blue)
    private lazy var priceDetailLbl: PaddingLabel = PaddingLabel(
        leftInset: 35,
        backgroundColor: UIColor.medium_Blue)
    private lazy var payerDetailLbl: PaddingLabel = PaddingLabel(
        leftInset: 35,
        backgroundColor: UIColor.medium_Blue)
    
    private var timeInfoLbl: PaddingLabel = PaddingLabel(
        leftInset: 25,
        backgroundColor: UIColor.normal_white)
    private var memoInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "메모를 입력해 주세요.",
        insetX: 25)
    private var priceInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "가격을 입력해 주세요.",
        insetX: 25)
    private var payerInfoTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholderText: "계산한 사람을 선택해 주세요.",
        insetX: 25)
    
    

    
    
    private var memoNumOfCharLbl: UILabel = UILabel.configureLbl(
        text: "0 / 8",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView(customTableEnum: .isReceipt)
    
    
//    private var moneyCountBtn: UILabel = UILabel.configureLbl(
//        font: UIFont.systemFont(ofSize: 13),
//        backgroundColor: UIColor.normal_white)
    
    private var moneyCountBtn: PaddingLabel = PaddingLabel(
        alignment: .center,
        leftInset: 0,
        rightInset: 0,
        backgroundColor: UIColor.normal_white)
    
    private var dutchBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 13),
        backgroundColor: UIColor.gray)
    
    
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
    
    
    
    
    
    // MARK: - 스택뷰
    private lazy var timeStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var memoStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.memoDetailLbl,
                           self.memoInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var priceStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.priceDetailLbl,
                           self.priceInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var payerStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.payerDetailLbl,
                           self.payerInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var infoStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.timeStackView,
                           self.memoStackView,
                           self.priceStackView,
                           self.payerStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.infoStackView,
                           self.tableView,
                           self.btnStackView,
                           self.addPersonBtn,
                           self.clearView],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    

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
    
    private var coordinator: ReceiptWriteCoordinating?
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: ReceiptWriteCoordinating) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension ReceiptWriteVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        self.totalStackView.setCustomSpacing(0, after: self.tableView)
        
        
        // cornerRadius
        self.timeDetailLbl.layer.maskedCorners = [
            .layerMinXMinYCorner]
        self.timeInfoLbl.layer.maskedCorners = [
            .layerMaxXMinYCorner]
        self.payerDetailLbl.layer.maskedCorners = [
            .layerMinXMaxYCorner]
        self.payerInfoTF.layer.maskedCorners = [
            .layerMaxXMaxYCorner]
        
        
        [self.calendar,
         self.timeDetailLbl,
         self.timeInfoLbl,
         self.payerDetailLbl,
         self.payerInfoTF,
         self.addPersonBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        
        
        self.btnStackView.clipsToBounds = true
        
        self.btnStackView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        
        self.btnStackView.layer.cornerRadius = 10
        
        
        self.bottomBtn.clipsToBounds = true
        self.bottomBtn.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.bottomBtn.layer.cornerRadius = 35
        
        
        
        // MARK: - Fix
        self.timeDetailLbl.text = "시간"
        self.memoDetailLbl.text = "메모"
        self.priceDetailLbl.text = "가격"
        self.payerDetailLbl.text = "계산"
        
        self.timeInfoLbl.text = "00:23"
        self.memoInfoTF.text = "맥도날드"
        self.priceInfoTF.text = "50,000원"
        self.payerInfoTF.text = "쁨"
        
        self.dutchBtn.setTitle("1명에서 1 / n 하기", for: .normal)
        self.moneyCountBtn.text = "남은 금액 : 25,000원"
        self.bottomBtn.setTitle("완료", for: .normal)
        self.calendar.select(Date())
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.bottomBtn)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.totalStackView)
        self.memoStackView.addSubview(self.memoNumOfCharLbl)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 스택뷰
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight)
        }
        // 바텀뷰
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
        
        self.calendar.snp.makeConstraints { make in
            make.height.equalTo(self.calendarHeight)
        }
        self.timeStackView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        [self.timeDetailLbl,
         self.memoDetailLbl,
         self.priceDetailLbl,
         self.payerDetailLbl].forEach { lbl in
            lbl.snp.makeConstraints { make in
                make.width.equalTo(90)
            }
        }
        
        self.memoNumOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        self.btnStackView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        self.addPersonBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        
        self.addPersonBtn.addTarget(self, action: #selector(self.addPersonBtnTapped), for: .touchUpInside)
        
        
    }
    @objc private func addPersonBtnTapped() {
        self.coordinator?.peopleSelectionPanScreen()
    }
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}




extension ReceiptWriteVC: FSCalendarDelegate {
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        
    }
}