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
    
    
    private var memoNumOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 8",
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
    
    /// 키보드 사용할 때 totalStackView에 추가하여 사용하는 뷰
    private lazy var clearView: UIView = {
        let view = UIView()
            view.isHidden = true
        return view
    }()
    
    
    
    
    
    
    // MARK: - 토탈 스택뷰
    private lazy var topTotalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.calendar,
                           self.whiteView,
                           self.selectedUsersTableView,
                           self.addPersonBtn,
                           self.clearView],
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
    private lazy var calendarHeight: CGFloat = (self.view.frame.width - 10) * 3 / 4
    
    private var coordinator: ReceiptWriteCoordProtocol
    private var viewModel: ReceiptWriteVMProtocol
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
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
        
        let timeGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.timeInfoLblTapped))
        self.timeInfoLbl.isUserInteractionEnabled = true
        self.timeInfoLbl.addGestureRecognizer(timeGesture)
        
        let payerGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.payerInfoLblTapped))
        self.payerInfoLbl.isUserInteractionEnabled = true
        self.payerInfoLbl.addGestureRecognizer(payerGesture)
        
        // 배경 탭 감지를 위한 제스처 인식기를 추가합니다.
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissPicker))
        // 피커 뷰가 제스처 이벤트를 가로채지 못하게 합니다.
        tapGesture.cancelsTouchesInView = false
        // 뷰에 제스처 인식기를 추가합니다.
        self.view.addGestureRecognizer(tapGesture)
    }
}
    
    
    
    
    
    
    



// MARK: - 버튼 액션 ( 화면 이동 )

extension ReceiptWriteVC {
    
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    @objc private func addPersonBtnTapped() {
        self.coordinator.peopleSelectionPanScreen(
            users: self.viewModel.selectedUsers,
            peopleSelectionEnum: .multipleSelection)
    }
    @objc private func payerInfoLblTapped() {
        self.coordinator.peopleSelectionPanScreen(
            users: self.viewModel.selectedUsers,
            peopleSelectionEnum: .singleSelection)
    }
    @objc private func bottomBtnTapped() {
        self.coordinator.checkReceiptPanScreen()
    }
    
    
    
    
    
    // MARK: - 데이트 피커 액션
    /// 타임 피커가 보일 때, 뷰를 탭하면 타임 피커를 숨김
    @objc func dismissPicker(_ gestureRecognizer: UITapGestureRecognizer) {
        if !self.timePicker.isHidden {
            self.timePicker.isHidden = true
        }
    }
    /// 타임 레이블을 누르면 '타임 피커'가 보이도록 설정
    @objc private func timeInfoLblTapped() {
        self.timePicker.isHidden = false
    }
}
    
    

    
    
    
    
    
    
    
// MARK: - PeopleSelection_데이터 설정

extension ReceiptWriteVC {
    
    // MARK: - 인원 다수 선택
    func changeTableViewData(_ users: RoomUserDataDictionary) {
        self.viewModel.makeCellVM(selectedUsers: users)
        self.selectedUsersTableView.reloadData()
        self.selectedUsersTableView.isHidden = false
        // 삭제 후 0명이 된다면 -> 테이블뷰 안 보이도록 설정
        self.tableIsHidden()
    }
    
    // MARK: - 계산한 사람 선택
    func changePayerLblData(_ user: RoomUserDataDictionary) {
        self.payerInfoLbl.text = self.viewModel.isPayerSelected(user: user)
        
        
        
        self.addPersonBtn.isHidden = false
        
        // MARK: - Fix
        // priceInfoTF의 값이 바뀌면 -> 자동으로 moneyCountLbl의 값이 바뀌도록
        // + 셀에 가격 자동 차감
    }
    
    func tableIsHidden() {
        self.selectedUsersTableView.isHidden
        = self.viewModel.numOfUsers == 0
        ? true
        : false
    }
}

// MARK: - 테이블뷰 셀 버튼 델리게이트

extension ReceiptWriteVC: ReceiptWriteTableDelegate {
    
    // MARK: - 유저 삭제
    func rightBtnTapped(_ cell: UITableViewCell,
                        userID: String?) {
        // 테이블뷰에 표시될 selectedUsers에서 해당 유저 삭제
            // + 셀의 뷰모델 삭제
        self.viewModel.deleteCellVM(userID: userID)
        // 몇 번째 셀인지 확인
        guard let indexPath = selectedUsersTableView.indexPath(for: cell) else { return }
        // 셀 삭제
        self.selectedUsersTableView.deleteRows(at: [indexPath],
                                  with: .bottom)
        // 삭제 후 0명이 된다면 -> 테이블뷰 안 보이도록 설정
        self.tableIsHidden()
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
        cell.delegate = self
        return cell
    }
}










// MARK: - 스크롤뷰 델리게이트
extension ReceiptWriteVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !self.timePicker.isHidden  {
            self.timePicker.isHidden = true
        }
        self.view.endEditing(true)
    }
}










// MARK: - 타임피커 데이터소스
extension ReceiptWriteVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 시간과 분을 위한 두 개의 컴포넌트
    }

    func pickerView(_ pickerView: UIPickerView, 
                    numberOfRowsInComponent component: Int)
    -> Int {
        if component == 0 {
            return 24 // 시간은 0부터 23까지
        } else {
            return 60 // 분은 0부터 59까지
        }
    }
}

// MARK: - 타임피커 델리게이트
extension ReceiptWriteVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, 
                    titleForRow row: Int, 
                    forComponent component: Int)
    -> String? {
        return String(format: "%02d", row) // 두 자리 숫자 형식으로 반환
    }

    func pickerView(_ pickerView: UIPickerView, 
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        // 사용자가 선택한 시간과 분을 처리
        let selectedHour = pickerView.selectedRow(inComponent: 0)
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        let hour = String(format: "%02d", selectedHour)
        let minute = String(format: "%02d", selectedMinute)
        
        self.timeInfoLbl.text = "\(hour) : \(minute)"
        
    }
    func pickerView(_ pickerView: UIPickerView, 
                    viewForRow row: Int, 
                    forComponent component: Int,
                    reusing view: UIView?) 
    -> UIView {
        // 재사용 가능한 뷰가 있으면 사용하고, 없으면 새로운 라벨을 생성
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18) // 폰트 크기를 24로 설정
        label.text = String(format: "%02d", row)
        
        return label
    }
}










// MARK: - 텍스트필드 델리게이트
extension ReceiptWriteVC: UITextFieldDelegate {
    // 텍스트 필드의 입력을 관리하는 함수
    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) 
    -> Bool {
        // 현재 텍스트 가져오기
        let currentText = textField.text ?? ""
        // NSRange를 Swiftdml Range로 변환
        guard let stringRange = Range(range, in: currentText) else { return false }
        // 사용자가 입력하거나 삭제한 문자열을 현재 텍스트에 반영하여 업데이트된 텍스트를 생성
        let updatedText = currentText.replacingCharacters(
            in: stringRange,
            with: string)
        
        // 현재 글자 수를 확인하고 8자리를 초과하는지 확인
        if updatedText.count > 8 {
            // 초과한다면 입력 불가
            return false
        }
        
        
        // 가격 텍스트필드에 0이 적힌다면
        if textField == self.priceInfoTF &&
            updatedText == "0" {
            self.priceInfoTF.text = "1"
        }
        // 8자리 이하라면 변경 허용
        return true
    }
    
    // 텍스트 필드 수정이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {

        
        // 텍스트 필드의 현재 텍스트를 변수에 저장
        let savedText = textField.text ?? ""
        
        // 메모 텍스트필드일 때
        if textField == self.memoInfoTF {
            self.viewModel.memo = savedText
            
        // 가격 텍스트필드 일때
        } else {
            // Int 값 설정
            let priceInt = Int(savedText)
            self.viewModel.price = priceInt
            
            // String 값 설정
            let priceString: String? 
            = savedText == ""
            ? nil
            // formatNumberString() -> 10,000처럼 바꾸기
            : self.formatNumberString(savedText)
            
            // 가격 텍스트필드에 적힌 값을 설정
                // 적혀있지 않다면 -> 플레이스홀더가 보이도록 nil값 설정
            self.priceInfoTF.text = priceString
            // 현재 남은 가격을 설정
                // 텍스트필드에 아무 것도 적혀있지 않다면 -> 0원으로 설정
            self.moneyCountLbl.text = priceString ?? "0원"
        }
    }
    

    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.priceInfoTF, 
            let numberString = textField.text?.replacingOccurrences(of: "원", with: "").replacingOccurrences(of: ",", with: "") {
            textField.text = numberString
        }
    }
    
    
    
    
    
    
    
    
    private func formatNumberString(_ string: String) -> String {
        let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
        // 3번째 자리수마다 ',' 붙이기
        let number = numberFormatter.number(from: string.replacingOccurrences(of: ",", with: "")) ?? 0
        // 뒤에 '원' 붙이기
        let returnString = "\(numberFormatter.string(from: number) ?? "")원"
        return returnString
    }
}
