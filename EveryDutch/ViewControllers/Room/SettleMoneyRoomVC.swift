//
//  SettleMoneyRoomVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import SnapKit

// MARK: - SettlementRoomVC

final class SettleMoneyRoomVC: UIViewController {
    
    // MARK: - 탑뷰 레이아웃
    /// 네비게이션바를 가리는 뷰
    private lazy var navView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    /// 밑으로 내릴 수 있느 탑뷰
    private lazy var topView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    
    
    // 탑뷰 내부 레이아웃
    /// 유저를 보여주는 테이블뷰
    private lazy var usersTableView: UsersTableView = UsersTableView(
        viewModel: UsersTableViewVM(
            roomDataManager: RoomDataManager.shared, .isSettleMoney))
    /// 검색 버튼
    private lazy var topViewBottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    /// 탑뷰 스택뷰
    private lazy var topViewStackView: UIStackView = {
        let stv = UIStackView.configureStv(
            arrangedSubviews: [self.usersTableView,
                               self.topViewBottomBtn],
            axis: .vertical,
            spacing: 0,
            alignment: .fill,
            distribution: .fill)
        stv.setCustomSpacing(4, after: self.usersTableView)
        return stv
    }()
    private lazy var arrowDownImg: UIImageView = {
        let img = UIImageView(image: UIImage.arrow_down)
        img.tintColor = .deep_Blue
        return img
    }()
    private lazy var topViewIndicator: UIView = UIView.configureView(
        color: UIColor.black)
    
    
    
    // MARK: - 메인 레이아웃
    /// 정산내역 테이블뷰
    private lazy var receiptTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        // 테이블뷰 셀이 아래->위로 보이도록 설정
        view.transform = CGAffineTransform(rotationAngle: -.pi)
        view.backgroundColor = .clear
        view.bounces = true
        return view
    }()
    /// 하단 '영수증 작성' 버튼
    private lazy var bottomBtn: BottomButton = BottomButton()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var coordinator: SettleMoneyRoomCoordProtocol
    private var viewModel: SettleMoneyRoomProtocol
    
    
    private lazy var cellHeight: CGFloat = self.receiptTableView.frame.width / 7 * 2
    
    // 탑뷰와 관련된 프로퍼티
    private var topViewHeight: NSLayoutConstraint!
    
    
    
    

    
    
    
//    private var topViewIsOpen: Bool = false
    private var initialHeight: CGFloat = 100
    private var currentTranslation: CGPoint = .zero
    private var currentVelocity: CGPoint = .zero
    

    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
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
}

// MARK: - 화면 설정

extension SettleMoneyRoomVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경화면 설정
        self.view.backgroundColor = UIColor.base_Blue
        // 바텀 버튼에 그림자 추가
        self.bottomBtn.addShadow(top: true)
        // 탑뷰에 그림자 추가
        self.topView.addShadow(bottom: true)
        // 모서리 설정
        // 탑뷰
        self.topView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.topView.layer.cornerRadius = 35
        // 탑뷰 하단 '인디케이터'
        self.topViewIndicator.clipsToBounds = true
        self.topViewIndicator.layer.cornerRadius = 3
        // 탑뷰 하단 버튼
        // 영수증 테이블뷰
        [self.topViewBottomBtn,
         self.receiptTableView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        
        // MARK: - Fix
        self.bottomBtn.setTitle("영수증 작성", for: .normal)
        self.navigationItem.title = "대충 방 이름"
        self.topViewBottomBtn.setTitle("버튼", for: .normal)
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.receiptTableView,
         self.topView,
         self.topViewIndicator,
         self.bottomBtn,
         self.navView].forEach { view in
            self.view.addSubview(view)
        }
        self.topView.addSubview(self.topViewStackView)
        self.topView.addSubview(self.arrowDownImg)
        
        // 네비게이션 가리기 위한 뷰
        self.navView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        // 탑뷰 (내리면 움직이는)
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.topViewHeight = self.topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.viewModel.minHeight)
        self.topViewHeight.isActive = true
        
        // 탑뷰 - 하단 인디케이터
        self.topViewIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.topView.snp.bottom).offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(4.5)
            make.centerX.equalTo(self.topView)
        }
        // 유저 테이블뷰
        self.usersTableView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200 + 5 + 34)
        }
        // 탑뷰 하단 버튼
        self.topViewBottomBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // 탑뷰 스택뷰
        self.topViewStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(self.viewModel.minHeight + 5 + 35)
        }
        // 유저 테이블뷰 아래로 스크롤 버튼
        self.arrowDownImg.snp.makeConstraints { make in
            make.bottom.equalTo(self.usersTableView.snp.bottom).offset(-8)
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        // 메인 화면 바텀 버튼
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
        // 영수증 테이블뷰 (영수증)
        self.receiptTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(self.viewModel.minHeight + 5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.bottomBtn.snp.top).offset(-5)
        }
    }
    

    
    // MARK: - 액션 및 제스쳐 설정
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
        
        // ********** 제스쳐 **********
        // 탑뷰 - 팬 재스쳐
        let topViewPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.topView.addGestureRecognizer(topViewPanGesture)
        // 탑뷰 - 팬 재스쳐
        let indicatorPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.topViewIndicator.addGestureRecognizer(indicatorPanGesture)
        // 네비게이션바 - 팬 재스쳐
        let navPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.navigationController?.navigationBar.addGestureRecognizer(navPanGesture)
    }
    
    
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        // 레시피를 가져왔을 때
        self.viewModel.receiptChangedClosure = {
            self.receiptTableView.reloadData()
        }
        // 데이터를 처음 가져왔을 때
        self.viewModel.fetchMoneyDataClosure = {
            self.usersTableView.viewModel.makeCellVM()
            self.usersTableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 액션 함수
    @objc private func bottomBtnTapped() {
        self.coordinator.receiptWriteScreen()
    }
    @objc private func settingBtnTapped() {
        self.coordinator.RoomSettingScreen()
    }
    @objc private func backBtnTapped() {
        self.coordinator.didFinish()
    }
    
    
    
    
    // MARK: - 액션
    
    
    

    
    
    
    
    
    
    // MARK: - 탑뷰 크기 조절
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.
        
        switch sender.state {
        case .began:
            // 제스처가 시작될 때 초기 높이를 저장
            self.initialHeight = self.topViewHeight.constant
            break
            
        case .changed:
            self.currentTranslation = translation
            self.currentVelocity = velocity
            // 새 높이를 계산합니다.
            var newHeight = self.initialHeight + translation.y
            
            // 새 높이가 최대 높이를 넘지 않도록 설정
            newHeight = min(self.viewModel.maxHeight, newHeight)
            // 새 높이가 최소 높이보다 작아지지 않도록 설정
            newHeight = max(self.viewModel.minHeight, newHeight)
            
            // 제약 조건을 업데이트하지만 layoutIfNeeded는 호출 X
            self.topViewHeight.constant = newHeight
            break
            
        case .ended, .cancelled:
            // 최종 높이 조절
            self.adjustTopViewHeight()
        default: break
        }
    }
    // MARK: - 탑뷰 최대 / 최소 크기 설정
    private func adjustTopViewHeight() {
        // 탑뷰가 닫혀 있고, 
        // 스와이프 방향이 아래로,
        // 스와이프 속도가 기준치 이하일 때,
        if !self.viewModel.topViewIsOpen
            && self.currentTranslation.y > 0
            && self.currentVelocity.y < 15000
        {
            // 최대 높이로 설정하고 탑뷰를 열기
            self.openTopView()
            // 스와이프 방향이 위로일 때
        } else if self.currentTranslation.y < 0 {
            // 최소 높이로 설정하고 탑뷰를 닫기
            self.closeTopView()
        }
    }
    
    private func openTopView() {
        // 상단 뷰의 높이를 최대 높이로 설정
        self.topViewHeight.constant = self.viewModel.maxHeight
        // 뷰모델 상태 true(open)으로 업데이트
        self.viewModel.topViewIsOpen = true
        // 뷰의 레이아웃을 애니메이션과 함께 업데이트
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func closeTopView() {
        // 상단 뷰의 높이를 최소 높이로 설정
        self.topViewHeight.constant = self.viewModel.minHeight
        // 뷰모델 상태 false(close)으로 업데이트
        self.viewModel.topViewIsOpen = false
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
        // 셀의 영수증 가져오기
        let receipt = self.viewModel.receipts[indexPath.row]
        // '영수증 화면'으로 화면 이동
        self.coordinator.ReceiptScreen(
            receipt: receipt)
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
        return self.viewModel.numberOfReceipt
    }
    
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
        // 테이블을 뒤집었?으므로, 셀도 뒤집어준다.
        cell.transform = CGAffineTransform(rotationAngle: -.pi)
        return cell
    }
}


// MARK: - 스크롤뷰 델리게이트
extension SettleMoneyRoomVC {
    /// 메인 테이블을 스크롤하면, topView 닫는 코드
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 메인 테이블뷰일 때만,
        // topView가 열려있다면
        if scrollView == self.receiptTableView && self.viewModel.topViewIsOpen {
            // topView 닫기
            self.closeTopView()
        }
    }
}
