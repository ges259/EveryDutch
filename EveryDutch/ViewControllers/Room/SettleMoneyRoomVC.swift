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
    private lazy var topView: SettleMoneyTopView = {
        let view = SettleMoneyTopView()
        view.delegate = self
        return view
    }()
    
    /// 정산내역 테이블뷰
    private lazy var receiptTableView: ReceiptTableView = {
        let receiptVM = ReceiptTableViewVM(
            roomDataManager: RoomDataManager.shared,
            isSearchMode: false
        )
        let view = ReceiptTableView(viewModel: receiptVM)
        view.receiptDelegate = self
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
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setIsViewVisible(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setIsViewVisible(false)
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
        // MARK: - Fix
        // 영수증 테이블뷰 모서리 설정
//        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 10)
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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(self.viewModel.minHeight + 5)
            make.leading.trailing.equalToSuperview().inset(10)
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
        // 네비게이션바 - 팬 재스쳐
        let navPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.navigationController?.navigationBar.addGestureRecognizer(navPanGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.presentViewDismiss(notification:)),
            name: .presentViewChanged,
            object: nil)
    }
}
    
    




    
    
    

// MARK: - isVisible
extension SettleMoneyRoomVC {
    @objc private func presentViewDismiss(notification: Notification) {
        let isVisible: Bool
        
        if notification.name == .presentViewChanged,
           let userInfo = notification.userInfo,
           let value = userInfo["someKey"] as? Bool
        {
            isVisible = value
            
        } else {
            isVisible = isViewLoaded && (view.window != nil)
        }
        self.setIsViewVisible(isVisible)
    }
    
    private func setIsViewVisible(_ boolean: Bool) {
        self.receiptTableView.isViewVisible = boolean
        self.topView.setupIsViewVisible(boolean)
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










// MARK: - 탑뷰 크기 조절
extension SettleMoneyRoomVC {
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
    
    
    /// 탑뷰의 높이를 업데이트 하기 전, 검사
    private func updateTopViewHeight() {
        // 탑뷰의 업데이트 플레그가 true라면,
        // 현재 화면이 보인다면,
        // 탑뷰가 열려있다면,
        if self.viewModel.topViewHeightPlag,
            self.viewModel.isTopViewOpen
        {
            // 탑뷰의 높이 업데이트
            self.openTopView()
            self.viewModel.topViewHeightPlag = false
        }
    }
}










// MARK: - 유저 테이블뷰 델리게이트
extension SettleMoneyRoomVC: UsersTableViewDelegate {
    func didSelectUser() {
        self.coordinator.userProfileScreen()
    }
    
    /// 유저의 수가 변경되었을 때, 탑뷰의 높이를 업데이트 하는 메서드
    func didUpdateUserCount() {
        // 탑뷰 플래그를 true로 변경
        self.viewModel.topViewHeightPlag = true
        // 탑뷰의 높이를 업데이트
        self.updateTopViewHeight()
    }
}










// MARK: - 영수증 테이블뷰 델리게이트
extension SettleMoneyRoomVC: ReceiptTableViewDelegate {
    func didSelectRowAt(_ receipt: Receipt) {
        self.coordinator.ReceiptScreen(receipt: receipt)
    }
    
    func willDisplayLastCell() {
        self.viewModel.loadMoreReceiptData()
    }
}
