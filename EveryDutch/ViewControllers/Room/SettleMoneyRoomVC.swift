//
//  SettleMoneyRoomVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import SnapKit

final class SettleMoneyRoomVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 네비게이션바를 가리는 뷰
    private var navView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    // 유저 테이블뷰가 존재하는 커스텀뷰
    private var topView: SettleMoneyTopView = SettleMoneyTopView()
    
    /// 정산내역 테이블뷰
    private lazy var receiptTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        view.backgroundColor = .clear
        view.bounces = true
        view.transform = CGAffineTransform(rotationAngle: .pi)
        return view
    }()
    /// 탑뷰의 높이 조절할 때 필요한 프로퍼티
    private var topViewHeight: NSLayoutConstraint!
    
    /// 하단 '영수증 작성' 버튼
    private lazy var bottomBtn: BottomButton = BottomButton(title: "영수증 작성")
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// SettleMoneyRoomCoordProtocol
    private var coordinator: SettleMoneyRoomCoordProtocol
    /// SettleMoneyRoomProtocol
    private var viewModel: SettleMoneyRoomProtocol
    
    
    
    /// 테이블뷰의 셀의 높이
    private lazy var cellHeight: CGFloat = self.receiptTableView.frame.width / 7 * 2

    
    
    
    

    /// 현재 화면이 Visible인지를 판단하는 변수
    /// viewWillAppear와 viewWillDisappear에서 적용
    private var isViewVisible = false
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNotification()
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SettleMoneyRoomProtocol,
         coordinator: SettleMoneyRoomCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isViewVisible = true
        self.processPendingUpdates()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewVisible = false
    }
    deinit { NotificationCenter.default.removeObserver(self) }
}










// MARK: - 화면 설정
extension SettleMoneyRoomVC {
    /// UI 설정
    private func configureUI() {
        // 배경화면 설정
        self.view.backgroundColor = UIColor.base_Blue
        // 네비게이션 타이틀 설정
        self.navigationItem.title = self.viewModel.navTitle
        // 탑뷰에 그림자 추가
        self.topView.addShadow(shadowType: .bottom)
        // 탑뷰 모서리 설정
        self.topView.setRoundedCorners(.bottom, withCornerRadius: 30)
        // 영수증 테이블뷰 모서리 설정
        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 10)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.receiptTableView,
         self.topView,
         self.bottomBtn,
         self.navView].forEach { view in
            self.view.addSubview(view)
        }
        // 네비게이션 가리기 위한 뷰
        self.navView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        // 탑뷰 (내리면 움직이는)
        self.topView.snp.makeConstraints { make in
            make.top.equalTo(self.navView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.topViewHeight = self.topView.bottomAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor,
            constant: self.viewModel.minHeight)
        self.topViewHeight.isActive = true
        
        // 영수증 테이블뷰 (영수증)
        self.receiptTableView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.top).offset(self.viewModel.minHeight + 5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.bottomBtn.snp.top).offset(-5)
        }
        // 메인 화면 바텀 버튼
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
    }
    
    /// 액션 및 제스쳐 설정
    private func configureAction() {
        // ********** 액션 **********
        // 왼쪽 네비게이션 바 - 액션
        let leftBtn = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        // 오른쪽 네비게이션 바 - 액션
        let rightBtn = UIBarButtonItem(
            image: .gear_Fill_Img,
            style: .done,
            target: self,
            action: #selector(self.settingBtnTapped))
        self.navigationItem.rightBarButtonItem = rightBtn
        // 바텀 버튼 액션
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
        // 탑뷰 - 팬 재스쳐
        let topViewPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.topView.addGestureRecognizer(topViewPanGesture)
        // 네비게이션바 - 팬 재스쳐ㄴ
        let navPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.navigationController?.navigationBar.addGestureRecognizer(navPanGesture)
    }
    
    /// 노티피케이션 설정
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: .userDataChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: .financialDataUpdated,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: .receiptDataChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.numberOfUsersChanges),
            name: .numberOfUsersChanges,
            object: nil)
    }
}
    
    
    
    
    





// MARK: - 버튼 액션 함수
extension SettleMoneyRoomVC {
    /// 바텀 버튼
    @objc private func bottomBtnTapped() {
        self.coordinator.receiptWriteScreen()
    }
    
    /// 설정 버튼
    @objc private func settingBtnTapped() {
        self.coordinator.RoomSettingScreen()
    }
    
    /// 뒤로가기 버튼
    @objc private func backBtnTapped() {
        self.coordinator.didFinish()
    }
}










// MARK: - viewWillAppear 업데이트
extension SettleMoneyRoomVC {
    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
    @objc private func handleDataChanged(notification: Notification) {
        guard let dataInfo = notification.userInfo as? [String: [IndexPath]] else { return }
        let rawValue = notification.name.rawValue
        
        switch rawValue {
        case Notification.Name.userDataChanged.rawValue,
            Notification.Name.financialDataUpdated.rawValue:
            self.viewModel.userDataChanged(dataInfo)
            
        case Notification.Name.receiptDataChanged.rawValue:
            self.viewModel.receiptDataChanged(dataInfo)
            
        default:
            break
        }
        if self.isViewVisible { self.processPendingUpdates() }
    }
    
    /// 모든 대기 중인 변경 사항을 적용
    private func processPendingUpdates() {
        // 유저 테이블 업데이트
        self.updateUsersTableView()
        // 영수증 테이블 업데이트
        self.updateReceiptsTableView()
        // 탑뷰의 높이를 업데이트
        self.updateTopViewHeight()
    }
    
    /// 유저 테이블뷰 리로드
    private func updateUsersTableView() {
        let userIndexPaths = self.viewModel.getPendingUserDataIndexPaths()
        guard !userIndexPaths.isEmpty else { return }
        // 유저 테이블뷰 리로드
        self.topView.userDataReload(at: userIndexPaths)
        // 변경 사항 초기화
        self.viewModel.resetPendingUserDataIndexPaths()
    }
    
    /// 영수증 테이블뷰 리로드
    private func updateReceiptsTableView() {
        let receiptIndexPaths = self.viewModel.getPendingReceiptIndexPaths()
        // 비어있다면, 아무 행동도 하지 않음
        guard !receiptIndexPaths.isEmpty else { return }
        // 영수증 테이블뷰 리로드
        receiptIndexPaths.forEach { (key: String, value: [IndexPath]) in
            self.reloadReceiptTableView(key: key, indexPaths: value)
        }
        // 변경 사항 초기화
        self.viewModel.resetPendingReceiptIndexPaths()
    }
    /// 영수증 테이블뷰 리로드 디테일
    @MainActor
    private func reloadReceiptTableView(key: String, indexPaths: [IndexPath]) {
        switch key {
        case NotificationInfoString.updated.notificationName:
            self.receiptTableView.reloadRows(at: indexPaths, with: .automatic)
            break
        case NotificationInfoString.initialLoad.notificationName:
            self.receiptTableView.reloadData()
            self.reloadData {
                self.scrollToBottom()
            }
            break
        case NotificationInfoString.added.notificationName:
            self.receiptTableView.insertRows(at: indexPaths, with: .automatic)
//            self.scrollToBottom()
            break
        case NotificationInfoString.removed.notificationName:
            // MARK: - Fix
//            self.receiptTableView.deleteRows(at: indexPaths, with: .automatic)
            self.receiptTableView.reloadData()
            break
        default:
            print("\(self) ----- \(#function) ----- Error")
            break
        }
    }
    private func reloadData(completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.receiptTableView.reloadData()
        CATransaction.commit()
    }
    /// 탑뷰의 높이를 업데이트 하기 전, 검사
    private func updateTopViewHeight() {
        // 탑뷰의 업데이트 플레그가 true라면,
        // 현재 화면이 보인다면,
        // 탑뷰가 열려있다면,
        if self.viewModel.topViewHeightPlag,
           self.isViewVisible,
            self.viewModel.isTopViewOpen
        {
            // 탑뷰의 높이 업데이트
            self.openTopView()
            self.viewModel.topViewHeightPlag = false
        }
    }
}
    
    

    
    

    
    


// MARK: - 탑뷰 크기 조절
extension SettleMoneyRoomVC {
    /// 유저의 수가 변경되었을 때, 탑뷰의 높이를 업데이트 하는 메서드
    /// 노티피케이션을 통해 전달 받음
    @objc private func numberOfUsersChanges() {
        // 탑뷰 플래그를 true로 변경
        self.viewModel.topViewHeightPlag = true
        // 탑뷰의 높이를 업데이트
        self.updateTopViewHeight()
    }
    
    /// 탑뷰를 스크롤 했을 때, 메서드
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.
        
        switch sender.state {
        case .began:
            // 제스처가 시작될 때 초기 높이를 저장
            self.beganTopViewScroll()
            break
            
        case .changed:
            self.changedTopViewScroll(translation: translation,
                                      velocity: velocity)
            break
            
        case .ended, .cancelled:
            // 최종 높이 조절
            self.endedTopViewScroll()
        default: break
        }
    }
    
    /// 탑뷰 제스쳐 시작 시
    private func beganTopViewScroll() {
        // 제스처가 시작될 때 초기 높이를 저장
        self.viewModel.initialHeight = self.topViewHeight.constant
    }
    
    /// 탑뷰 제스쳐 바뀌는 도중
    private func changedTopViewScroll(translation: CGPoint,
                                      velocity: CGPoint) {
        self.viewModel.currentTranslation = translation
        self.viewModel.currentVelocity = velocity
        
        // 새 높이를 계산합니다.
        let newHeight = self.viewModel.getMaxAndMinHeight
        // 제약 조건을 업데이트하지만 layoutIfNeeded는 호출 X
        self.topViewHeight.constant = newHeight
    }
    
    /// 탑뷰 최대 / 최소 크기 설정
    private func endedTopViewScroll() {
        // 탑뷰가 닫혀 있고, 
        // 스와이프 방향이 아래로,
        // 스와이프 속도가 기준치 이하일 때,
        if !self.viewModel.isTopViewOpen
            && self.viewModel.currentTranslation.y > 0
            && self.viewModel.currentVelocity.y < 15000
        {
            // 최대 높이로 설정하고 탑뷰를 열기
            self.openTopView()
            // 스와이프 방향이 위로일 때
        } else if self.viewModel.currentTranslation.y < 0 {
            // 최소 높이로 설정하고 탑뷰를 닫기
            self.closeTopView()
        }
    }
    
    /// 탑뷰 열기 메서드
    @MainActor
    private func openTopView() {
        // 뷰모델 상태 true(open)으로 업데이트
        self.viewModel.isTopViewOpen = true
        // 상단 뷰의 높이를 최대 높이로 설정
        self.topViewHeight.constant = self.viewModel.maxHeight
        // 뷰의 레이아웃을 애니메이션과 함께 업데이트
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 탑뷰 닫기 메서드
    @MainActor
    private func closeTopView() {
        // 뷰모델 상태 false(close)으로 업데이트
        self.viewModel.isTopViewOpen = false
        // 상단 뷰의 높이를 최소 높이로 설정
        self.topViewHeight.constant = self.viewModel.minHeight
        // 뷰의 레이아웃을 애니메이션과 함께 업데이트
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}










// MARK: - 테이블뷰 델리게이트
extension SettleMoneyRoomVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath.row)
        // '영수증 화면'으로 화면 이동
        self.coordinator.ReceiptScreen(receipt: receipt)
    }
    func tableView(_ tableView: UITableView, 
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        // 마지막 셀
        //
        if indexPath.row == self.viewModel.numberOfReceipt - 1 {
            self.loadMoreData()
        }
    }
    private func loadMoreData() {
        self.viewModel.loadMoreReceiptData()
    }
}

// MARK: - 테이블뷰 데이터 소스
extension SettleMoneyRoomVC: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print(self.viewModel.numberOfReceipt)
        return self.viewModel.numberOfReceipt
    }
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.receiptTableView.dequeueReusableCell(
            withIdentifier: Identifier.settlementTableViewCell,
            for: indexPath) as! SettlementTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellViewModel)
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        
        if indexPath.row == 0{
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .normal_white
        }
        return cell
    }
}










// MARK: - 스크롤뷰 델리게이트
extension SettleMoneyRoomVC {
    /// 메인 테이블을 스크롤하면, topView 닫는 코드
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 메인 테이블뷰일 때만,
        // topView가 열려있다면
        if scrollView == self.receiptTableView 
            && self.viewModel.isTopViewOpen {
            // topView 닫기
            self.closeTopView()
        }
    }
    /// ReceiptTableView를 제일 아래로 스크롤하는 메서드
    /// reload가 끝난 후 스크롤 하기 위해 DispatchQueue.main.async 사용
    ///  테이블뷰와 셀을 뒤집었기 때문에 [위로 스크롤]은 -> [하단으로 스크롤]이 됨
    private func scrollToBottom() {
        DispatchQueue.main.async {
            self.receiptTableView.scrollToRow(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: true)
        }
    }
}
