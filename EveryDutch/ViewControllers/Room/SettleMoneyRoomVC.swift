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
    
    // MARK: - 레이아웃
    private lazy var navView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    private lazy var topView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    private lazy var topViewIndicator: UIView = UIView.configureView(
        color: UIColor.black)
    
    
    
    
    
    private lazy var topViewTableView: SettlementDetailsTableView = SettlementDetailsTableView(
        viewModel: SettlementDetailsVM(.isSettleMoney))
    
    private lazy var topViewBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.topViewTableView,
                           self.topViewBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    private lazy var arrowDownImg: UIImageView = {
        let img = UIImageView(image: UIImage.arrow_down)
        img.tintColor = .deep_Blue
        return img
    }()
    
    
    private lazy var settlementTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        return view
    }()
    private lazy var bottomBtn: BottomButton = BottomButton(
        title: "영수증 작성")
    
    
    
    
    
    // MARK: - 프로퍼티
    private weak var coordinator: SettleMoneyRoomCoordProtocol?
    private var viewModel: SettleMoneyRoomVM?
    
    
    private lazy var cellHeight: CGFloat = self.settlementTableView.frame.width / 7 * 2
    
    // 탑뷰와 관련된 프로퍼티
    private var topViewHeight: NSLayoutConstraint!
    
    
    
    
    // 인원 수에 따라 maxHeight 크기 바꾸기
    /* 스택뷰
     바텀 앵커 : 35
     하단 버튼 : 45
     상단 레이아웃 : 35
     스택뷰 간격 : 10 -> 4
     네비게이션바 간격 : 12
     => 134
     칸 당 40
     // 최대 5명
     */
    private lazy var maxHeight: CGFloat = {
//        return 134 + 160
        return 131 + 200
    }()
    
    
    private let minHeight: CGFloat = 35
    private var topViewIsOpen: Bool = false
    private var initialHeight: CGFloat = 100
    private var currentTranslation: CGPoint = .zero
    private var currentVelocity: CGPoint = .zero
    

    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SettleMoneyRoomVM,
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
        self.view.backgroundColor = UIColor.base_Blue
        
        self.bottomBtn.addShadow(top: true, bottom: false)
        self.topView.addShadow(top: false, bottom: true)
        
        // 모서리 설정
        self.topView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.topView.layer.cornerRadius = 35
        
        // topViewIndicator
        self.topViewIndicator.clipsToBounds = true
        self.topViewIndicator.layer.cornerRadius = 3
        
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 10
        self.topViewBtn.clipsToBounds = true
        self.topViewBtn.layer.cornerRadius = 10
        
        self.settlementTableView.clipsToBounds = true
        self.settlementTableView.layer.cornerRadius = 10
        
        
        // MARK: - Fix
        self.bottomBtn.setTitle("영수증 작성", for: .normal)
        self.navigationItem.title = "대충 방 이름"
        self.topViewBtn.setTitle("버튼", for: .normal)
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.settlementTableView,
         self.topView,
         self.topViewIndicator,
         self.bottomBtn,
         self.navView].forEach { view in
            self.view.addSubview(view)
        }
        
        self.topView.addSubview(self.stackView)
        self.topView.addSubview(self.arrowDownImg)
        
        //
        self.navView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        
        // 상단 화면 (내리면 움직이는)
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.topViewHeight = self.topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.minHeight)
        self.topViewHeight.isActive = true
        
        // 상단 테이블뷰 - 하단 인디케이터
        self.topViewIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.topView.snp.bottom).offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(4.5)
            make.centerX.equalTo(self.topView)
        }
        // 상단 테이블뷰
        self.topViewTableView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200 + 5 + 34)
        }
        // 상단 테이블뷰 - 하단 버튼
        self.topViewBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // 상단 테이블뷰 - 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(minHeight + 5 + 35)
        }
        // 상단 테이블뷰 - 하단 버튼
        self.arrowDownImg.snp.makeConstraints { make in
            make.bottom.equalTo(self.topViewTableView.snp.bottom).offset(-8)
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        // 바텀 버튼
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
        // 메인 테이블뷰 (영수증)
        self.settlementTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(self.minHeight + 5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.bottomBtn.snp.top).offset(-5)
        }
    }
    

    
    // MARK: - 액션 설정
    private func configureAction() {
        // 왼쪽 네비게이션 바 - 액션
        let leftBtn = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        // 오른쪽 네비게이션 바 - 액션
        let rightBtn = UIBarButtonItem(image: .gear_Fill_Img, style: .done, target: self, action: #selector(self.settingBtnTapped))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        
        // 탑뷰 - 팬 재스쳐
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
        self.topView.addGestureRecognizer(topViewPanGesture)
        // 탑뷰 - 팬 재스쳐
        let indicatorPanGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
        self.topViewIndicator.addGestureRecognizer(indicatorPanGesture)
        // 네비게이션바 - 팬 재스쳐
        let navPanGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
        self.navigationController?.navigationBar.addGestureRecognizer(navPanGesture)
        
        self.bottomBtn.addTarget(self, action: #selector(self.bottomBtnTapped), for: .touchUpInside)

    }
    @objc private func bottomBtnTapped() {
        self.coordinator?.receiptWriteScreen()
    }
    

    
    
    
    
    
    
    // MARK: - 탑뷰 크기 조절
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.
        
        switch sender.state {
        case .began:
            // 제스처가 시작될 때 초기 높이를 저장
            self.initialHeight = self.topViewHeight.constant
            
            
        case .changed:
            self.currentTranslation = translation
            self.currentVelocity = velocity
            // 새 높이를 계산합니다.
            var newHeight = self.initialHeight + translation.y
            
            // 새 높이가 최대 높이를 넘지 않도록 설정
            newHeight = min(self.maxHeight, newHeight)
            // 새 높이가 최소 높이보다 작아지지 않도록 설정
            newHeight = max(self.minHeight, newHeight)
            
            // 제약 조건을 업데이트하지만 layoutIfNeeded는 호출 X
            self.topViewHeight.constant = newHeight
            
            // 스택뷰 alpha값 설정
            self.stackView.alpha = newHeight / self.maxHeight
            
        case .ended, .cancelled:
            self.adjustTopViewHeight()
            
            if self.topViewIsOpen {
                self.stackView.alpha = 1
            }
            
        default: break
        }
    }
    // MARK: - 탑뷰 최대 / 최소 크기 설정
    private func adjustTopViewHeight() {
        if !self.topViewIsOpen
            && self.currentTranslation.y > 0
            && self.currentVelocity.y < 15000
        {
            self.topViewHeight.constant = self.maxHeight
            self.topViewIsOpen = true
        } else if self.currentTranslation.y < 0 {
            self.topViewHeight.constant = self.minHeight
            self.topViewIsOpen = false
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc private func settingBtnTapped() {
        print(#function)
        self.coordinator?.RoomSettingScreen()
    }
    @objc private func backBtnTapped() {
        self.coordinator?.didFinish()
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
        print(#function)
        self.coordinator?.ReceiptScreen()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.settlementTableView.dequeueReusableCell(withIdentifier: Identifier.settlementTableViewCell, for: indexPath) as! SettlementTableViewCell
        
        let cellViewModel = self.viewModel?.cellViewModel(at: indexPath.item)
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}


// MARK: - 스크롤뷰 델리게이트
extension SettleMoneyRoomVC {
    /// 메인 테이블을 스크롤하면, topView 닫는 코드
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 메인 테이블뷰일 때만,
        // topView가 열려있다면
            // -> topView 닫기
        if scrollView == self.settlementTableView
            && self.topViewIsOpen {
            self.adjustTopViewHeight()
        }
    }
}
