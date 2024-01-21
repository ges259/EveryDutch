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
    
// MARK: - 스크롤뷰
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
            scrollView.delegate = self
            scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    
// MARK: - 상단 레이아웃
    
    
    
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
        text: Date.returnCurrenTime(),
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    private lazy var memoInfoTF: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: .normal_white,
            placeholderText: "메모를 입력해 주세요.",
            insetX: 25)
        tf.delegate = self
        return tf
    }()
    private lazy var priceInfoTF: InsetTextField = {
        let tf = InsetTextField(
            placeholderText: "가격을 입력해 주세요.",
            keyboardType: .numberPad,
            keyboardReturnType: .done,
            insertX: 25)
        tf.delegate = self
        return tf
    }()
    private var payerInfoLbl: CustomLabel = CustomLabel(
        text: "계산한 사람을 선택해 주세요.",
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    
    
    private lazy var memoNumOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / \(self.viewModel.TF_MAX_COUNT)",
        font: UIFont.systemFont(ofSize: 13))
    
    // MARK: - 상단 스택뷰
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
                           self.payerInfoLbl],
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
    

    
    
    
    
    
    
    
// MARK: - 테이블뷰 레이아웃
    private var moneyCountLbl: CustomLabel = CustomLabel(
        text: "0원",
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var dutchBtn: UIButton = UIButton.btnWithTitle(
        title: "1 / n",
        font: UIFont.systemFont(ofSize: 13),
        backgroundColor: UIColor.deep_Blue)
    private lazy var tableHeaderStv: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.moneyCountLbl,
                           self.dutchBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    // MARK: - 테이블뷰
    private lazy var selectedUsersTableView: CustomTableView = {
        let view = CustomTableView()
        // 테이블뷰 설정
        view.delegate = self
        view.dataSource = self
        view.register(
            ReceiptWriteTableViewCell.self,
            forCellReuseIdentifier: Identifier.receiptWriteTableViewCell)
        // 헤더뷰 설정

        view.tableHeaderView = self.tableHeaderStv
        self.tableHeaderStv.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.bounds.width,
                                           height: 45)
        
        view.isHidden = true
        return view
    }()
    
    
    
    
    
    
// MARK: - 하단 레이아웃
    private var addPersonBtn: UIButton = {
        let btn = UIButton.btnWithTitle(
            title: "✓ 계산할 사람 선택",
            font: UIFont.systemFont(ofSize: 14),
            backgroundColor: UIColor.deep_Blue)
        btn.isHidden = true
        return btn
    }()
    
    
    
    
    // MARK: - 토탈 스택뷰
    private lazy var topTotalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.calendar,
                           self.whiteView,
                           self.selectedUsersTableView,
                           self.addPersonBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
// MARK: - 완료 버튼
    private lazy var bottomBtn: BottomButton = BottomButton(
        title: "완료")
    
    
    
    
    

// MARK: - 타임 피커
    // UIPickerView 인스턴스 생성
    private lazy var timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.isHidden = true
        return picker
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var coordinator: ReceiptWriteCoordProtocol
    private var viewModel: ReceiptWriteVMProtocol
    
    private lazy var calendarHeight: CGFloat = (self.view.frame.width - 10) * 3 / 4
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureGesture()
        self.configureClosure()
        self.configureNotificatioon()
    }
    init(viewModel: ReceiptWriteVMProtocol,
         coordinator: ReceiptWriteCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        
        [self.calendar,
         self.whiteView,
         self.addPersonBtn,
         self.selectedUsersTableView,
         self.timePicker].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.bottomBtn)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.topTotalStackView)
        self.memoStackView.addSubview(self.memoNumOfCharLbl)
        self.whiteView.addSubview(self.infoStackView)
        // 데이트 피커를 뷰의 서브뷰로 추가
        self.scrollView.addSubview(timePicker)
        
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
        // 탑 토탈 스택뷰
        self.topTotalStackView.snp.makeConstraints { make in
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
        // 데이트 피커 설정
        self.timePicker.snp.makeConstraints { make in
            // 데이트 피커를 상위 뷰의 중앙에 위치시킵니다.
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.timeStackView.snp.bottom)
            // 데이트 피커의 너비와 높이를 100으로 설정합니다.
            make.height.width.equalTo(150)
        }
    }

    // MARK: - 액션 설정
    private func configureAction() {
        // 뒤로가기 버튼
        let backButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        // 사람 추가 버튼
        self.addPersonBtn.addTarget(
            self,
            action: #selector(self.addPersonBtnTapped),
            for: .touchUpInside)
        // 바텀 버튼
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
        // 메모 텍스트필드
        self.memoInfoTF.addTarget(
            self, 
            action: #selector(self.memoInfoTFDidChanged),
            for: .editingChanged)
        // 가격 텍스트필드
        self.priceInfoTF.addTarget(
            self,
            action: #selector(self.priceInfoTFDidChanged),
            for: .editingChanged)
        // 1 / N 버튼
        self.dutchBtn.addTarget(
            self, 
            action: #selector(self.dutchBtnTapped),
            for: .touchUpInside)
    }
    
    // MARK: - 제스처 설정
    private func configureGesture() {
        // '시간' 레이블 제스처 설정
        let timeGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.timeInfoLblTapped))
        self.timeInfoLbl.isUserInteractionEnabled = true
        self.timeInfoLbl.addGestureRecognizer(timeGesture)
        // '계산한 사람' 레이블 제스처 생성
        let payerGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.payerInfoLblTapped))
        self.payerInfoLbl.isUserInteractionEnabled = true
        self.payerInfoLbl.addGestureRecognizer(payerGesture)
        
        // 'self.view' 화면에 제스처 설정
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.endEditing))
        // 피커 뷰가 제스처 이벤트를 가로채지 못하게 설정
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 노티피케이션 설정
    private func configureNotificatioon() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        // 누적 금액 설정 클로저
        self.viewModel.calculatePriceClosure = { [weak self] total in
            self?.moneyCountLbl.text = total
        }
        // 키보드 디바운싱의 클로저
        self.viewModel.debouncingClosure = {
            self.endEditing()
        }
    }
}
    
    
    
    
    
    
    



// MARK: - 키보드 노티피케이션 액션

extension ReceiptWriteVC {
    
    // MARK: - 키보드가 올라올 때
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // 키보드의 높이 구하기
        if let keyboardSize = (notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            // 뷰모델의 기본 키보드 높이와 현재 디바이스의 키보드 높이 다르다면,
                // -> clearView의 높이 업데이트
            if self.viewModel.keyboardHeight != keyboardHeight {
                self.viewModel.keyboardHeight = keyboardHeight
            }
        }
    }
    
    // MARK: - 키보드가 내려갈 때
    @objc func keyboardWillHide(notification: NSNotification) {
        self.viewModel.setDebouncing(stop: false)
    }
}










// MARK: - 버튼 액션 ( 화면 이동 )

extension ReceiptWriteVC {
    
    // MARK: - 이전 화면 버튼 액션
    @objc private func backButtonTapped() {
        NotificationCenter.default.removeObserver(self)
        self.coordinator.didFinish()
    }
    
    // MARK: - 사람 추가 버튼 액션
    @objc private func addPersonBtnTapped() {
        // 모든 키보드 내리기
        self.endEditing()
        // 화면 전환
        self.coordinator.peopleSelectionPanScreen(
            users: self.viewModel.selectedUsers,
            peopleSelectionEnum: .multipleSelection)
    }
    
    // MARK: - payer 액션
    @objc private func payerInfoLblTapped() {
        // 모든 키보드 내리기
        self.endEditing()
        // 화면 전환
        self.coordinator.peopleSelectionPanScreen(
            users: self.viewModel.selectedUsers,
            peopleSelectionEnum: .singleSelection)
    }
    
    // MARK: - 바텀 버튼 액션
    @objc private func bottomBtnTapped() {
        // 모든 키보드 내리기
        self.endEditing()
        // 화면 전환
        self.coordinator.checkReceiptPanScreen()
    }
}
    
    
    
    
    
    
    
    

// MARK: - 1 / N 버튼 액션
extension ReceiptWriteVC {
    @objc private func dutchBtnTapped() {
        
    }
}










// MARK: - 데이트 피커 액션

extension ReceiptWriteVC {
    
    // MARK: - 타임 피커 레이블
    /// 타임 레이블을 누르면 '타임 피커'가 보이도록 설정
    @objc private func timeInfoLblTapped() {
        self.dismissKeyboard()
        self.timePicker.isHidden = false
    }
}










// MARK: - 화면 설정 초기화

extension ReceiptWriteVC {
    
    // MARK: - 강제 편집 종료
    /// 인터페이스 초기화 및 키보드 숨김 처리
    /// - 스크롤뷰의 contentInset이 변경된 경우, 기본값으로 재설정
    /// - 타임피커가 표시된 경우, 숨김
    /// - 활성화된 텍스트 입력 필드가 있을 경우, 키보드를 내림
    @objc private func endEditing() {
        // 뷰 모델의 테이블뷰 편집 상태를 확인
        if !self.viewModel.isTableViewEditing {
            // 스크롤뷰의 contentInset이 변경된 경우, 기본값으로 재설정
            self.resetScrollViewInsets()
            // 타임피커가 표시된 경우, 숨김
            self.hideTimePicker()
            // 활성화된 텍스트 입력 필드가 있을 경우, 키보드를 내림
            self.dismissKeyboard()
        }
    }
    
    // MARK: - 스클로뷰 contentInset 초기화
    /// 스크롤뷰의 contentInset과 scrollIndicatorInsets를 초기화합니다.
    private func resetScrollViewInsets() {
        // 자연스러운 감소를 위해, UIView.animate()사용
        UIView.animate(withDuration: 0.3) {
            // 스크롤뷰의 contentInset을 초기화.
            self.scrollView.contentInset = .zero
        }
    }
    
    // MARK: - 타임피커 숨기기
    /// 타임피커를 숨김
    private func hideTimePicker() {
        self.timePicker.isHidden = true
    }

    // MARK: - 키보드 내리기
    /// 텍스트 입력 필드의 키보드를 내림
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
    
    

    
    
    
    
    
    
    
// MARK: - 유저 선택 시_데이터 설정

extension ReceiptWriteVC {
    
    // MARK: - 인원 다수 선택
    func changeTableViewData(_ users: RoomUserDataDictionary) {
        self.viewModel.makeCellVM(selectedUsers: users)
        self.selectedUsersTableView.reloadData()
        // 삭제 후 0명이 된다면 -> 테이블뷰 안 보이도록 설정
        self.selectedUsersTableView.isHidden = self.viewModel.tableIsHidden
    }
    
    // MARK: - 계산한 사람 선택
    func changePayerLblData(_ user: RoomUserDataDictionary) {
        self.payerInfoLbl.text = self.viewModel.isPayerSelected(user: user)
        self.addPersonBtn.isHidden = false
    }
}










// MARK: - 테이블뷰 셀 델리게이트

extension ReceiptWriteVC: ReceiptWriteTableDelegate {
    
    // MARK: - 유저 삭제
    func rightBtnTapped(_ cell: UITableViewCell,
                        userID: String?) {
        // 테이블뷰에 표시될 selectedUsers에서 해당 유저 삭제
            // + 셀의 뷰모델 삭제
        self.viewModel.deleteCellVM(userID: userID)
        // 몇 번째 셀인지 확인
        guard let indexPath = self.selectedUsersTableView.indexPath(for: cell) else { return }
        // 셀 삭제
        self.selectedUsersTableView.deleteRows(at: [indexPath],
                                               with: .left)
        // 삭제 후 0명이 된다면 -> 테이블뷰 안 보이도록 설정
        self.selectedUsersTableView.isHidden = self.viewModel.tableIsHidden
    }
    
    // MARK: - 금액 설정
    func setprice(userID: String, price: Int?) {
        self.viewModel.calculatePrice(userID: userID,
                                      price: price)
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptWriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.scrollToTableViewCellBottom(indexPath: indexPath)
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
        cell.delegate = self
        return cell
    }
}










// MARK: - 스크롤뷰 델리게이트

extension ReceiptWriteVC: UIScrollViewDelegate {
    
    // MARK: - 스크롤 시작 시
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing()
    }
    
    // MARK: - 셀 클릭 시 스크롤
    /// 선택한 셀의 위치로 스크롤하는 별도의 메서드
    /// - Parameter indexPath: 선택한 셀의 'IndexPath'
    private func scrollToTableViewCellBottom(indexPath: IndexPath) {
        // 테이블뷰 셀을
            // 수정하고 있지 않다면 -> 선택한 셀의 위치로 자동 스크롤.
            // 수정하고 있다면 -> 아무 행동도 하지 않음
        if !self.viewModel.isTableViewEditing {
            // 스크롤 동작 중에는 디바운싱을 중지
            self.viewModel.setDebouncing(stop: true)
            
            // 스크롤뷰의 콘텐츠 오프셋을 업데이트하는 메서드를 호출
            self.updateScrollViewContentOffset(for: indexPath)
        }
    }
    
    // MARK: - [계산] 셀의 오프셋
    /// 스크롤뷰의 콘텐츠 오프셋을 계산하고 업데이트합니다.
    /// - Parameters:
    ///   - indexPath: 선택한 셀의 'IndexPath'
    private func updateScrollViewContentOffset(for indexPath: IndexPath) {
        // 스크롤뷰 내에서 셀의 프레임을 계산.
        let cellFrame = self.calculateCellFrameInScrollView(for: indexPath)
        // 계산된 프레임을 기반으로 스크롤뷰의 오프셋을 계산.
        let offset = self.calculateScrollViewOffset(for: cellFrame)
        
        // 계산된 오프셋으로 스크롤뷰의 위치를 조정.
        self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }
    
    // MARK: - [계산] 셀의 프레임
    /// 스크롤뷰 내에서 선택한 셀의 프레임을 계산합니다.
    /// - Parameters:
    ///   - indexPath: 선택한 셀의 인덱스 패스입니다.
    /// - Returns: 스크롤뷰 좌표계에서 셀의 프레임을 반환합니다.
    private func calculateCellFrameInScrollView(for indexPath: IndexPath) -> CGRect {
        // 선택한 셀의 프레임을 테이블뷰의 좌표계로부터 가져옵니다.
        let rectOfCellInTableView = self.selectedUsersTableView.rectForRow(at: indexPath)
        // 가져온 프레임을 스크롤뷰의 좌표계로 변환합니다.
        return self.selectedUsersTableView.convert(
            rectOfCellInTableView,
            to: self.scrollView)
    }

    // MARK: - [계산] 스크롤뷰의 오프셋
    /// 계산된 셀의 프레임을 바탕으로 스크롤뷰의 오프셋을 계산합니다.
    /// 셀의 하단이 키보드 위로 올라오도록 오프셋을 설정합니다.
    /// - Parameter cellFrame: 스크롤뷰 내에서 셀의 프레임입니다.
    /// - Returns: 새로운 스크롤뷰의 오프셋을 반환합니다.
    private func calculateScrollViewOffset(for cellFrame: CGRect) -> CGFloat {
        // 스크롤할 y축 오프셋 구하기
        // = 셀의 하단 y위치
        // + 셀의 높이
        // + 키보드의 높이
        // - 스크롤뷰의 높이
        // - 여백(38)
        let offset = cellFrame.origin.y
        + cellFrame.size.height
        + self.viewModel.keyboardHeight
        - self.scrollView.frame.height
        - 38
        
        // 스크롤 시 셀이 키보드에 가려지지 않도록,
            // 하단에 키보드 높이만큼의 여백을 추가
        self.scrollView.contentInset.bottom = self.viewModel.keyboardHeight
        return offset
    }
}










// MARK: - 타임피커 데이터소스

extension ReceiptWriteVC: UIPickerViewDataSource {
    
    // MARK: - 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 시간과 분을 위한 두 개의 컴포넌트
    }
    // MARK: - 최소 및 최대 숫자
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int)
    -> Int {
        return component == 0
        ? 24 // 시간은 0부터 23까지
        : 60 // 분은 0부터 59까지
    }
}

// MARK: - 타임피커 델리게이트

extension ReceiptWriteVC: UIPickerViewDelegate {
    
    // MARK: - 형식
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int, 
                    forComponent component: Int)
    -> String? {
        return self.viewModel.timePickerFormat(row) // 두 자리 숫자 형식으로 반환
    }
    
    // MARK: - 선택 시 액션
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        // 사용자가 선택한 시간과 분을 처리
        let selectedHour = pickerView.selectedRow(inComponent: 0)
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        // 선택한 시간을 timeInfoLbl에 넣기
        self.timeInfoLbl.text = self.viewModel.timePickerString(
            hour: selectedHour,
            minute: selectedMinute)
    }
    
    // MARK: - 폰트
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int, 
                    forComponent component: Int,
                    reusing view: UIView?) 
    -> UIView {
        // 재사용 가능한 뷰가 있으면 사용하고,
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        // 없으면 새로운 라벨을 생성
        } else {
            label = UILabel()
        }

        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18) // 폰트 크기를 24로 설정
        label.text = self.viewModel.timePickerFormat(row)
        
        return label
    }
}










// MARK: - 텍스트필드 델리게이트

extension ReceiptWriteVC: UITextFieldDelegate {
    
    // MARK: - 텍스트필드 수정 시작 시
    /// priceInfoTF의 수정을 시작할 때 ',' 및 '원'을 제거하는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 가격 텍스트필드일 때, 빈칸이 아니라면
        guard textField == self.priceInfoTF,
              self.priceInfoTF.text != "" else { return }
        
        // priceInfoTF에 있는 '~원' 형식을 제거
        self.priceInfoTF.text = self.viewModel.removeWonFormat(
            priceText: self.priceInfoTF.text)
    }
    
    // MARK: - 수정이 끝났을 때
    /// 텍스트 필드 수정이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드의 현재 텍스트를 변수에 저장
        let savedText = textField.text ?? ""
        
        // 메모 텍스트필드일 때
        if textField == self.memoInfoTF {
            self.viewModel.memo = savedText
            
        // 가격 텍스트필드 일때
        } else {
            // 뷰모델에 price값 저장
            // 가격 레이블에 바뀐 가격을 ',' 및 '원'을 붙여 표시
            // 누적금액 레이블에 (지불금액 - 누적금액) 설정
            self.finishPriceTF(text: savedText)
        }
    }
    
    // MARK: - [저장] 가격 텍스트필드
    /// 가격 텍스트필드의 수정이 끝났을 때 호출되는 메서드
    private func finishPriceTF(text: String?) {
        // 뷰모델에 price값 저장
        self.viewModel.savePriceText(text: text)
        
        // 가격 레이블에 바뀐 가격을 ',' 및 '원'을 붙여 표시
        self.priceInfoTF.text = self.viewModel.priceInfoTFText
        // 누적금액 레이블에 (지불금액 - 누적금액) 설정
        self.moneyCountLbl.text = self.viewModel.moneyCountLblText
    }
    
    
    // MARK: - [액션] 가격 텍스트필드
    @objc private func priceInfoTFDidChanged() {
        guard let currentText = self.priceInfoTF.text else { return }
        
        // 포매팅된 문자열로 텍스트 필드 업데이트
        self.priceInfoTF.text = self.viewModel.formatPriceForEditing(currentText)
    }
    
    // MARK: - [액션] 메모 텍스트필드
    @objc private func memoInfoTFDidChanged() {
        guard let text = self.memoInfoTF.text else { return }
        
        // 최대 글자 수(12글자)를 넘어가면 더이상 작성이 안 되도록 설정
        if text.count > self.viewModel.TF_MAX_COUNT {
            self.memoInfoTF.deleteBackward()
        }
        // 레이블 업데이트
        self.memoNumOfCharLbl.text = self.viewModel.updateMemoCount(
            count: text.count)
    }
}
