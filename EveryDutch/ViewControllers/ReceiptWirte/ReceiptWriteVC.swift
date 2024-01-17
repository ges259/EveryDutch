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
    
    // MARK: - 캘린더
    /// 달력
     private lazy var calendar: CustomCalendar = CustomCalendar()
    
  
    // MARK: - Detail - 레이아웃
    private var whiteView: UIView = UIView.configureView(
        color: UIColor.medium_Blue)
    
    private lazy var timeDetailLbl: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .time)
    private lazy var memoDetailLbl: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .memo)
    private lazy var priceDetailLbl: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .price)
    private lazy var payerDetailLbl: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .payer)
    
    
    
    
    
    // MARK: - Info - 레이아웃
    private var timeInfoLbl: CustomLabel = CustomLabel(
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
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
    
    
    private var memoNumOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 8",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    // MARK: - 테이블뷰
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            ReceiptWriteTableViewCell.self,
            forCellReuseIdentifier: Identifier.receiptWriteTableViewCell)
        return view
    }()
    
    
    
    // MARK: - 테이블 하단 스택뷰
    private var moneyCountLbl: CustomLabel = CustomLabel(
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var dutchBtn: UIButton = UIButton.btnWithTitle(
        title: "1 / n",
        font: UIFont.systemFont(ofSize: 13),
        backgroundColor: UIColor.normal_white)
    
    
    private lazy var tableFooterStv: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.moneyCountLbl,
                           self.dutchBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    private var addPersonBtn: UIButton =  UIButton.btnWithTitle(
        title: "✓ 계산할 사람 선택",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var bottomBtn: BottomButton = BottomButton(
        title: "완료")
    
    /// 키보드 사용할 때 totalStackView에 추가하여 사용하는 뷰
    private lazy var clearView: UIView = {
        let view = UIView()
            view.isHidden = true
        return view
    }()
    
    
    
    
    
    // MARK: - 스택뷰
    private lazy var timeStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.timeDetailLbl,
                           self.timeInfoLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var memoStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.memoDetailLbl,
                           self.memoInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var priceStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.priceDetailLbl,
                           self.priceInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var payerStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.payerDetailLbl,
                           self.payerInfoTF],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    private lazy var infoStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.timeStackView,
                           self.memoStackView,
                           self.priceStackView,
                           self.payerStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    private lazy var totalStackView: UIStackView = {
        let stv = UIStackView.configureStv(
            arrangedSubviews: [self.calendar,
                               self.whiteView,
                               self.tableFooterStv,
                               self.tableView,
                               self.addPersonBtn,
                               self.clearView],
            axis: .vertical,
            spacing: 7,
            alignment: .fill,
            distribution: .fill)
        
        stv.setCustomSpacing(0, after: self.tableFooterStv)
        return stv
    }()
    
    // MARK: - 데이트 피커
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
    
    private var coordinator: ReceiptWriteCoordProtocol
    private var viewModel: ReceiptWriteVMProtocol
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureViewWithViewModel()
    }
    init(viewModel: ReceiptWriteVMProtocol,
         coordinator: ReceiptWriteCoordProtocol) {
        self.viewModel = viewModel
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
        
        self.tableFooterStv.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        
        self.tableView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        
        [self.calendar,
         self.whiteView,
         self.addPersonBtn,
         self.tableFooterStv,
         self.tableView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.bottomBtn)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.totalStackView)
        self.memoStackView.addSubview(self.memoNumOfCharLbl)
        self.whiteView.addSubview(self.infoStackView)
        
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
        // 토탈 스택뷰
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
        /// 캘린더 설정
        self.calendar.snp.makeConstraints { make in
            make.height.equalTo(self.calendarHeight)
        }
        /// 시간 스택뷰 (.fillEqually)
        self.timeStackView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // 글자 수 세는 레이블
        self.memoNumOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        // 테이블 밑 스택뷰
        self.tableFooterStv.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // 사람 추가 버튼
        self.addPersonBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // 시간, 메모, 금액, 계산 등 스택뷰
        self.infoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        // 버튼 액션
        self.addPersonBtn.addTarget(
            self,
            action: #selector(self.addPersonBtnTapped),
            for: .touchUpInside)
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
    }
    
    // MARK: - 뷰모델을 통한 설정
    private func configureViewWithViewModel() {
        // MARK: - Fix
        self.moneyCountLbl.text = "남은 금액 : 25,000원"
        
        self.dutchBtn.backgroundColor = self.viewModel.dutchBtnColor
    }
}
    
    
    
    
    
    
    



// MARK: - 버튼 액션 ( 화면 이동 )

extension ReceiptWriteVC {
    
    
    @objc private func bottomBtnTapped() {
        self.coordinator.checkReceiptPanScreen()
    }
    @objc private func addPersonBtnTapped() {
        self.coordinator.peopleSelectionPanScreen()
    }
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptWriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
}
// MARK: - 테이블뷰 데이터소스
extension ReceiptWriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.numOfUsers
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptWriteTableViewCell,
            for: indexPath) as! ReceiptWriteTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}
