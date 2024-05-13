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
    
    // MARK: - 캘린더
    /// 달력
    private lazy var calendar: CustomCalendar = {
        let calendar = CustomCalendar()
        calendar.calendarDelegate = self
        return calendar
    }()
    
    // MARK: - 테이블뷰
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.register(
            ReceiptWriteUsersCell.self,
            forCellReuseIdentifier: Identifier.receiptWriteUsersCell)
        view.register(
            ReceiptWriteDataCell.self,
            forCellReuseIdentifier: Identifier.receiptWriteDataCell)
        
        // 테이블뷰 설정
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .clear
        view.sectionHeaderTopPadding = 7
        return view
    }()
    // MARK: - 테이블뷰 푸터뷰
    private lazy var tableFooterView: ReceiptWriteTableFooterView = {
        let view = ReceiptWriteTableFooterView()
        view.delegate = self
        return view
    }()
    
    // MARK: - 유저 추가 버튼
    private var addPersonBtn: UIButton = UIButton.btnWithTitle(
        title: "✓ 계산할 사람 선택",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.deep_Blue)
    
    // MARK: - 토탈 스택뷰
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.calendar,
                           self.tableView,
                           self.addPersonBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    // MARK: - 완료 버튼
    private lazy var bottomBtn: BottomButton = BottomButton(
        title: "완료")
    
    // MARK: - 타임 피커
    private lazy var timePicker: CustomTimePicker = {
        let picker = CustomTimePicker()
            picker.customTimePickerDelegate = self
        picker.setupTimePicker()
        return picker
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var coordinator: ReceiptWriteCoordProtocol
    private var viewModel: ReceiptWriteVMProtocol
    
    private lazy var calendarHeight: CGFloat = (self.view.frame.width - 10) * 3 / 4
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()          // 기본적인 UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 및 제스처 설정
        self.configureClosure()     // 클로저 설정
        self.configureNotification() // 노티피케이션 설정
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
        
        [self.calendar,
         self.addPersonBtn,
         self.tableView,
         self.timePicker].forEach { view in
            view.setRoundedCorners(.all, withCornerRadius: 10)
        }
        self.totalStackView.setCustomSpacing(0, after: self.calendar)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.totalStackView)
        self.view.addSubview(self.bottomBtn)
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
        // 사람 추가 버튼
        self.addPersonBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        // 데이트 피커 설정
        self.timePicker.snp.makeConstraints { make in
            // 데이트 피커를 상위 뷰의 중앙에 위치시킵니다.
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.tableView.snp.top)
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
        // 'self.view' 화면에 제스처 설정
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.endEditing))
        // 피커 뷰가 제스처 이벤트를 가로채지 못하게 설정
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 노티피케이션 설정
    private func configureNotification() {
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
}










// MARK: - 클로저 설정

extension ReceiptWriteVC {
    
    // MARK: - [공통]
    private func configureClosure() {
        self.calculatePriceClosure()
        self.debouncingClosure()
        self.dutchBtnClosure()
        self.errorClosure()
        self.successApiClosure()
    }
    
    // MARK: - 금액 계산
    private func calculatePriceClosure() {
        // 누적 금액 설정 클로저
        self.viewModel.calculatePriceClosure = { [weak self] total in
            self?.tableFooterView.setMoneyCountLabel(totalPrice: total)
        }
    }
    
    // MARK: - 디바운싱
    private func debouncingClosure() {
        // 키보드 디바운싱의 클로저
        self.viewModel.debouncingClosure = { [weak self] in
            self?.endEditing()
        }
    }
    
    // MARK: - 더치 버튼
    private func dutchBtnClosure() {
        // 더치 버튼을 누르면, 실행되는 클로저
            // 테이블뷰를 리로드,
            // 더치 모드(isDutchMode) 해제
        self.viewModel.dutchBtnClosure = { [weak self] in
            // self 옵셔널 바인딩
            guard let self = self else { return }
            // 애니메이션 및 레이아웃 변경을 위한 트랜잭션 시작
            CATransaction.begin()
            // CATransaction을 사용하여 reloadData가 완료될 때 수행될 작업을 정의
            CATransaction.setCompletionBlock {
                // reloadData가 완료된 후에 호출될 코드
                self.viewModel.isDutchedMode = false
            }
            
            let sectionIndex = IndexSet(integer: 1) // 섹션 인덱스 1을 나타냄
            // 테이블뷰의 섹션2만 리로드함.
            self.tableView.reloadSections(sectionIndex, with: .none)
            
            // reloadData() 후에 layoutIfNeeded()를 호출하여 레이아웃 업데이트를 즉시 실행
            self.tableView.layoutIfNeeded()
            CATransaction.commit()
        }
    }
    private func errorClosure() {
        self.viewModel.errorClosure = { errorType in
            switch errorType {
            case .validationError(let errorString):
                self.coordinator.checkReceiptPanScreen(errorString)
                break
            default: 
                
                break
            }
        }
    }
    
    private func successApiClosure() {
        self.viewModel.successMakeReceiptClosure = { [weak self] in
            self?.coordinator.didFinish()
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
            // 키보드 높이
            let keyboardHeight = keyboardSize.height
            
            // 뷰모델의 기본 키보드 높이와 현재 디바이스의 키보드 높이 다르다면,
            if self.viewModel.keyboardHeight != keyboardHeight {
                // 셀의 하단이 키보드 위로 올라오도록 스크롤뷰의 오프셋을 설정할 때 사용
                self.viewModel.keyboardHeight = keyboardHeight
            }
        }
    }
    
    // MARK: - 키보드가 내려갈 때
    @objc func keyboardWillHide() {
        // '테이블뷰 셀의 텍스트필드'를 수정하고 있다면,
        if self.viewModel.isUserDataTableEditing {
            // -> 디바운싱 작업 실행
            // -> 0.05초 이후 실행
            self.viewModel.setDebouncing()
        }
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
    private func payerInfoLblTapped() {
        // 모든 키보드 내리기
        self.endEditing()
        // 화면 전환
        self.coordinator.peopleSelectionPanScreen(
            users: self.viewModel.payer,
            peopleSelectionEnum: .singleSelection)
    }
    
    // MARK: - 영수증 확인 버튼 액션
    @objc private func bottomBtnTapped() {
        // 모든 키보드 내리기
        self.endEditing()
        self.viewModel.validationData()
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
        // 확인하는 이유 -> 유저 셀에서 다른 유저 셀을 클릭하면, 키보드가 내려갔다가 올라옴.
            // 그 현상을 방지하기 위해 편집 상태 확인
        if !self.viewModel.isUserDataTableEditing {
            // 스크롤뷰의 contentInset이 변경된 경우, 기본값으로 재설정
            self.resetScrollViewInsets()
            // 타임피커가 표시된 경우, 숨김
            self.hideTimePicker(true)
            // 활성화된 텍스트 입력 필드가 있을 경우, 키보드를 내림
            self.dismissKeyboard()
        }
    }
    
    // MARK: - 스클로뷰 contentInset 초기화
    /// 스크롤뷰의 contentInset과 scrollIndicatorInsets를 초기화합니다.
    private func resetScrollViewInsets() {
        // 자연스러운 감소를 위해, UIView.animate()사용
        UIView.animate(withDuration: 0.5) {
            // 스크롤뷰의 contentInset을 초기화.
            self.scrollView.contentInset = .zero
        }
    }
    
    // MARK: - 타임피커 숨기기
    /// 타임피커를 숨김
    private func hideTimePicker(_ bool: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.timePicker.isHidden = bool
            self.timePicker.alpha = bool ? 0 : 1
        }
    }

    // MARK: - 키보드 내리기
    /// 텍스트 입력 필드의 키보드를 내림
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
    
    

    
    
    




// MARK: - [payer] 1명 선택

extension ReceiptWriteVC {
    
    func changePayerLblData(addedUsers: RoomUserDataDict) {
        self.savePayer(addedUsers)
        self.updatePayerCell()
    }
    
    // MARK: - payer 저장
    private func savePayer(_ addedUsers: RoomUserDataDict) {
        self.viewModel.isPayerSelected(selectedUser: addedUsers)
    }
}
    
    
    






    
// MARK: - [paymentDetail] 여러명 선택

extension ReceiptWriteVC {
    
    // MARK: - 여러명 선택
    func changeTableViewData(
        addedUsers: RoomUserDataDict,
        removedUsers: RoomUserDataDict)
    {
        // 테이블 뷰 한 번에 업데이트
        self.tableView.performBatchUpdates({
            // 셀을 제거
            self.tableViewDeleteRows(removedUsers: removedUsers)
            // 셀을 생성
            self.tableViewInsertRows(addedUsers: addedUsers)
            // 테이블뷰의 푸터뷰를 업데이트
            self.updateTableFooterView()
        })
    }
    
    // MARK: - 테이블뷰 푸터뷰 업데이트
    private func updateTableFooterView() {
        let isHidden = self.viewModel.getNoDataViewIsHidden
        let btnColor = self.viewModel.dutchBtnBackgroundColor
        // 푸터뷰 업데이트
        self.tableFooterView.updateView(
            nodataViewIsHidden: isHidden,
            ductchBtnColor: btnColor)
        
        // 테이블 뷰 푸터 뷰의 크기를 동적으로 조정
        let footerHeight = self.viewModel.getFooterViewHeight(section: 1)
        self.tableView.tableFooterView?.frame.size.height = footerHeight
        // 푸터 뷰 재설정으로 레이아웃 업데이트
        self.tableView.tableFooterView = self.tableView.tableFooterView
    }
    
    // MARK: - 셀 생성
    private func tableViewInsertRows(addedUsers: RoomUserDataDict) {
        // 생성할 유저가 있다면,
        if !addedUsers.isEmpty {
            // 주의 --- 순서를 바꾸면 안 됨.
            // 뷰모델에서 셀의 뷰모델을 생성
            self.viewModel.createUsersCellVM(addedUsers: addedUsers)
            // 추가될 셀의 IndexPath를 계산합니다.
            let indexPaths = self.viewModel.indexPathsForAddedUsers(addedUsers)
            // 테이블뷰에 특정 셀을 생성
            self.tableView.insertRows(at: indexPaths, with: .none)
        }
    }
    
    // MARK: - 셀 삭제
    private func tableViewDeleteRows(removedUsers: RoomUserDataDict) {
        // 삭제할 유저가 있다면,
        if !removedUsers.isEmpty {
            // 주의 --- 순서를 바꾸면 안 됨.
            // 제거될 셀의 IndexPath를 계산
            let indexPaths = self.viewModel.indexPathsForRemovedUsers(removedUsers)
            // 비어있지 않다면,
            // 비어있다면 -> 오류
            if !indexPaths.isEmpty {
                // 뷰모델에서 셀의 뷰모델을 삭제
                self.viewModel.deleteData(removedUsers: removedUsers)
                // 테이블뷰의 특정 셀을 제거
                self.tableView.deleteRows(at: indexPaths, with: .none)
            }
        }
    }
}
        



    
    
    
    


// MARK: - 셀 업데이트
extension ReceiptWriteVC {
    private func updateReceiptWirteDataCell(
        type: ReceiptCellEnum,
        withUpdateAction action: ((ReceiptWriteDataCell) -> Void))
    {
        // 인덱스패스 가져오기
        let indexPath = self.viewModel.findReceiptEnumIndex(type)
        // 나중에 리팩토링
        if let cell = self.tableView.cellForRow(at: indexPath) as? ReceiptWriteDataCell {
            // 셀의 레이블에 새로운 텍스트를 설정합니다.
            action(cell)
        }
    }
    /// 날짜 셀
    private func updateDateCell(_ date: Date) {
        // 셀 업데이트
        self.updateReceiptWirteDataCell(type: .date) { cell in
            cell.setDateString(date: date)
        }
    }
    /// payer 셀
    private func updatePayerCell() {
        // payer 정보 가져오기
        let payer = self.viewModel.getSelectedUsers
        // 셀 업데이트
        self.updateReceiptWirteDataCell(type: .payer) { cell in
            cell.setLabelText(text: payer)
        }
    }
    /// time 셀
    private func updateTimeCell(timeString: String) {
        // 셀 업데이트
        self.updateReceiptWirteDataCell(type: .time) { cell in
            cell.setLabelText(text: timeString)
        }
    }
}










// MARK: - [테이블뷰] 델리게이트

extension ReceiptWriteVC: UITableViewDelegate {
    
    // MARK: - 셀의 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 45
    }
    
    // MARK: - 헤더뷰 설정
    /// 헤더 뷰를 구성합니다.
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int)
    -> UIView? {
        let title = self.viewModel.getHeaderTitle(section: section)
        return TableHeaderView(
            title: title,
            tableHeaderEnum: .receiptWriteVC)
    }

    // MARK: - 헤더 높이
    /// 헤더의 높이를 설정합니다.
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
    -> CGFloat {
        return 70
    }
    
    // MARK: - 푸터뷰 설정
    func tableView(_ tableView: UITableView, 
                   viewForFooterInSection section: Int)
    -> UIView? {
        return section == 0
        ? nil
        : self.tableFooterView
    }
    
    // MARK: - 푸터뷰 높이
    func tableView(_ tableView: UITableView, 
                   heightForFooterInSection section: Int)
    -> CGFloat {
        return self.viewModel.getFooterViewHeight(section: section)
    }
    
    // MARK: - 눌렸을 때 스크롤
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        self.scrollToTableViewCellBottom(indexPath: indexPath)
    }
}





// MARK: - [테이블뷰] 데이터소스
extension ReceiptWriteVC: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getSectionCount
    }
    
    /// 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumOfCell(section: section)
    }
    
    /// [셀 구성]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 타입 가져오기
        let type = self.viewModel.setSectionIndex(section: indexPath.section)
        // 분기처리
        switch type {
        case .receiptData:
            return self.setReceiptWriteDataCell(indexPath)
            
        case .userData:
            return self.setReceiptWriteUsersCell(indexPath)
            
        default:
            return tableView.dequeueReusableCell(
                withIdentifier: Identifier.defaultCell,
                for: indexPath)
        }
    }
    
    /// [데이터 셀] 구성
    private func setReceiptWriteDataCell(_ indexPath: IndexPath) -> ReceiptWriteDataCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptWriteDataCell,
            for: indexPath) as! ReceiptWriteDataCell
        // 델리게이트 설정
        cell.delegate = self
        
        
        let cellVM = self.viewModel.getDataCellViewModel(indexPath: indexPath)
            cell.configureCell(viewModel: cellVM)
        // 첫 번째 셀 및 마지막 셀의 모서리 설정
        self.configureDataCellCorner(cell, row: indexPath.row)
        return cell
    }
    /// [데이터 셀] 첫 번째 셀 및 마지막 셀의 모서리 설정
    private func configureDataCellCorner(_ cell: ReceiptWriteDataCell, row: Int) {
        if row == 0 {
            cell.configureFirstCell()
        } else if self.viewModel.isLastCell(row: row) {
            cell.configureLastCell()
        }
    }
    
    /// [유저 셀] 구성
    private func setReceiptWriteUsersCell(_ indexPath: IndexPath) -> ReceiptWriteUsersCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptWriteUsersCell,
            for: indexPath) as! ReceiptWriteUsersCell
        // 델리게이트 설정
        cell.delegate = self
        self.configureUserCellVM(cell, indexPath: indexPath)
        self.configureUserCellDutchMode(cell)
        return cell
    }
    /// [유저 셀]의 뷰모델을 초기화
    private func configureUserCellVM(_ cell: ReceiptWriteUsersCell,
                                     indexPath: IndexPath) {
        // 셀 뷰모델 만들기
        let cellVM = self.viewModel.getUserCellViewModel(indexPath: indexPath)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellVM)
    }
    /// [유저 셀] 더치 모드
    private func configureUserCellDutchMode(_ cell: ReceiptWriteUsersCell) {
        if self.viewModel.isDutchedMode {
            cell.configureDutchBtn(price: self.viewModel.dutchedPrice)
        }
    }
}










// MARK: - [스크롤뷰] 델리게이트

extension ReceiptWriteVC: UIScrollViewDelegate {
    
    // MARK: - 스크롤 시작 시
    // 스크롤이 시작될 때 호출되는 메서드
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 인터페이스 초기화 및 키보드 숨김 처리
        self.endEditing()
    }
    
    // 선택한 셀로 스크롤하는 메서드
    private func scrollToTableViewCellBottom(indexPath: IndexPath) {
        // 테이블뷰가 현재 편집 중이 아닐 경우에만 스크롤을 수행
        guard !self.viewModel.isUserDataTableEditing else { return }
        // 스크롤 액션 동안 불필요한 업데이트를 방지하기 위해 디바운싱을 중지
        self.viewModel.stopDebouncing()
        // 스크롤뷰의 새로운 오프셋을 계산하여 업데이트
        self.updateScrollViewContentOffset(for: indexPath)
    }
    
    /// 스크롤뷰의 콘텐츠 오프셋을 계산하고 업데이트하는 메서드
    private func updateScrollViewContentOffset(for indexPath: IndexPath) {
        // 스크롤뷰 내에서 셀의 위치를 계산
        let cellFrame = self.calculateCellFrameInScrollView(for: indexPath)
        // 계산된 셀의 위치에 기반하여 스크롤뷰의 새로운 오프셋을 계산
        let offset = self.calculateScrollViewOffset(for: cellFrame)
        // 계산된 새로운 오프셋으로 스크롤뷰를 이동
        self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }
    
    /// 스크롤뷰 내에서 선택한 셀의 프레임을 계산하는 메서드
    private func calculateCellFrameInScrollView(for indexPath: IndexPath) -> CGRect {
        // 테이블뷰에서 선택한 셀의 위치를 가져옴
        let rectOfCellInTableView = self.tableView.rectForRow(at: indexPath)
        // 선택한 셀의 위치(rect)를 테이블뷰의 좌표계에서 스크롤뷰의 좌표계로 변환
        return self.tableView.convert(rectOfCellInTableView, to: self.scrollView)
    }
    
    /// 스크롤뷰의 새로운 오프셋을 계산하는 메서드
    private func calculateScrollViewOffset(for cellFrame: CGRect) -> CGFloat {
        // 셀의 가장 아래 부분의 y 좌표를 계산
        let cellBottomY = cellFrame.origin.y + cellFrame.height
        // 스크롤뷰에서 키보드가 차지하는 영역을 제외한 가시 영역의 가장 아래 y 좌표를 계산
        let visibleAreaBottomY = self.scrollView.bounds.height - self.viewModel.keyboardHeight
        // 셀의 아래 부분이 키보드 위로 올라오도록 필요한 y축 오프셋을 계산
        let offsetY = max(cellBottomY - visibleAreaBottomY, 0)
        // 새로 계산된 오프셋이 현재 스크롤뷰의 오프셋보다 큰 경우에만 오프셋을 업데이트
        // 이는 셀이 이미 키보드 위에 있을 경우 불필요한 스크롤을 방지
        return max(self.scrollView.contentOffset.y, offsetY)
    }
}










// MARK: - [데이터 셀] 델리게이트

extension ReceiptWriteVC: ReceiptWriteDataCellDelegate {
    
    // MARK: - 메모 셀
    func finishMemoTF(memo: String) {
        self.viewModel.saveMemo(context: memo)
    }
    // MARK: - 가격 셀
    func finishPriceTF(price: Int) {
        // 뷰모델에 price값 저장
        self.viewModel.savePriceText(price: price)
        // 누적금액 레이블에 (지불금액 - 누적금액) 설정
        self.tableFooterView.setMoneyCountLabel(totalPrice: self.viewModel.moneyCountLblText)
    }
    
    func cellIsTapped(_ cell: ReceiptWriteDataCell, type: ReceiptCellEnum?) {
        guard let type = type else { return }
        switch type {
        case .date:     self.dateLblTapped()
        case .time:     self.timeLblTapped()
        case .memo:     self.memoTFTapped()
        case .price:    self.priceTFTapped()
        case .payer:    self.payerLblTapped()
        case .payment_Method: break
        }
    }
    /// 날짜 셀
    private func dateLblTapped() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    /// 시간 셀
    private func timeLblTapped() {
        /// 타임 레이블을 누르면 '타임 피커'가 보이도록 설정
        self.dismissKeyboard()
        self.hideTimePicker(false)
    }
    /// payer 셀
    private func payerLblTapped() {
        self.payerInfoLblTapped()
    }
    /// 가격 셀
    private func priceTFTapped() {
        self.scrollToTableViewCellBottom(indexPath: self.viewModel.findReceiptEnumIndex(.price))
    }
    /// 메모 셀
    private func memoTFTapped() {
        self.scrollToTableViewCellBottom(indexPath: self.viewModel.findReceiptEnumIndex(.memo))
    }
}










// MARK: - [유저 셀] 델리게이트

extension ReceiptWriteVC: ReceiptWriteTableDelegate {
    /// [X버튼] 유저 삭제
    func rightBtnTapped(user: RoomUserDataDict?) {
        guard let user = user else { return }
        // 인터페이스 초기화 및 키보드 숨김 처리
        self.view.endEditing(true)
        
        self.changeTableViewData(addedUsers: [:],
                                 removedUsers: user)
    }
    
    /// [텍스트필드] 금액 재설정 -> 클로저를 통해 변경
    func setprice(userID: String, price: Int?) {
        self.viewModel.calculatePrice(userID: userID, price: price)
    }
}










// MARK: - 타임피커 델리게이트
extension ReceiptWriteVC: CustomTimePickerDelegate {
    func setTime(timeString: String) {
        // 시간 저장
        self.viewModel.saveTime(time: timeString)
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        self.updateTimeCell(timeString: timeString)
    }
}





// MARK: - 캘린더 델리게이트
extension ReceiptWriteVC: CalendarDelegate {
    func didSelectDate(date: Date) {
        // 날짜 저장
        self.viewModel.saveCalenderDate(date: date)
        // 셀 업데이트
        self.updateDateCell(date)
    }
}





// MARK: - 푸터뷰 델리게이트
extension ReceiptWriteVC: ReceiptWriteTableFooterViewDelegate {
    func dutchBtnTapped() {
        self.viewModel.dutchBtnTapped()
    }
}
