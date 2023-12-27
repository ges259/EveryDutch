//
//  SettlementRoomVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import SnapKit

// MARK: - SettlementRoomVC

final class SettlementRoomVC: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var topView: UIView = UIView.configureView(
        color: .deep_Blue)
    
    private lazy var topViewIndicator: UIView = UIView.configureView(
        color: .black)
    
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 22),
        backgroundColor: UIColor.deep_Blue)
    
    
    private lazy var settlementTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.tag = 1
        view.bounces = false
        return view
    }()
    
    private lazy var topViewTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            TopViewTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.tag = 2
        view.backgroundColor = .normal_white
        view.bounces = false
        return view
    }()
    private lazy var topViewBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.topViewTableView,
                                                 self.topViewBtn])
        stv.axis = .vertical
        stv.spacing = 5
        stv.alignment = .fill
        stv.distribution = .fill
        return stv
    }()
    
    private lazy var navView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    
    
    
    // MARK: - 프로퍼티
    private weak var coordinator: SettlementRoomCoordinating?
    private var viewModel: SettlementRoomVM?
    
    private lazy var cellHeight: CGFloat = self.settlementTableView.frame.width / 5 * 2
    
    // 탑뷰와 관련된 프로퍼티
    private var topViewHeight: NSLayoutConstraint!
    private let maxHeight: CGFloat = 350
    private let minHeight: CGFloat = 35
    private var topViewIsOpen: Bool = false
    private var initialHeight: CGFloat = 100
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SettlementRoomVM,
         coordinator: SettlementRoomCoordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SettlementRoomVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        
        // 모서리 설정
        self.topView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.topView.layer.cornerRadius = 35
        
        self.bottomBtn.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.bottomBtn.layer.cornerRadius = 35
        // topViewIndicator
        self.topViewIndicator.clipsToBounds = true
        self.topViewIndicator.layer.cornerRadius = 3
        
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 15
        self.topViewBtn.clipsToBounds = true
        self.topViewBtn.layer.cornerRadius = 15
        
        // MARK: - Fix
        self.bottomBtn.setTitle("영수증 작성", for: .normal)
        self.navigationItem.title = "대충 방 이름"
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
        
        self.navView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.topViewHeight = self.topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.minHeight)
        self.topViewHeight.isActive = true
        
        self.topViewIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.topView.snp.bottom).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(4.5)
            make.centerX.equalTo(self.topView)
        }
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        self.settlementTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(self.minHeight + 5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.bottomBtn.snp.top).offset(-5)
        }
        self.topViewTableView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(240)
        }
        self.topViewBtn.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(50)
        }
        self.stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(minHeight + 5 + 35)
        }
    }
    

    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let leftBtn = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(image: .gear_Fill_Img, style: .done, target: self, action: #selector(settingButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        // panGesture - UIView에 스크롤 제스쳐 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
        
        self.topView.addGestureRecognizer(panGesture)
        let indicatorPanGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
        self.topViewIndicator.addGestureRecognizer(indicatorPanGesture)
    }
    
    
    
    
    
    
    
    
    
    
    
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.
        
        switch sender.state {
        case .began:
            // 제스처가 시작될 때 초기 높이를 저장합니다.
            self.initialHeight = self.topViewHeight.constant
        case .changed:
            // 새 높이를 계산합니다.
            var newHeight = self.initialHeight + translation.y
            
            // 새 높이가 최대 높이를 넘지 않도록 합니다.
            newHeight = min(self.maxHeight, newHeight)
            // 새 높이가 최소 높이보다 작아지지 않도록 합니다.
            newHeight = max(self.minHeight, newHeight)
            
            // 제약 조건을 업데이트하지만 layoutIfNeeded는 호출하지 않습니다.
            self.topViewHeight.constant = newHeight
            
        case .ended, .cancelled:
            // 속도가 충분히 느리고 최소 크기에서만 스와이프한 경우에 최대 크기로 변경합니다.
            if translation.y > 0 && velocity.y < 15000 && !self.topViewIsOpen {
                self.topViewHeight.constant = self.maxHeight
                self.topViewIsOpen = true // 확장 상태로 변경합니다.
            } else {
                // 그렇지 않으면 원래 크기로 돌아갑니다.
                self.topViewHeight.constant = self.minHeight
                self.topViewIsOpen = false
            }
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    
    @objc private func settingButtonTapped() {
        
    }
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}





extension SettlementRoomVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return tableView.tag == 1
        ? self.cellHeight
        : 50
    }
}


extension SettlementRoomVC: UITableViewDataSource {
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
        if tableView.tag == 1 {
            let cell = self.settlementTableView.dequeueReusableCell(withIdentifier: Identifier.settlementTableViewCell, for: indexPath) as! SettlementTableViewCell
            
            return cell
            
        } else {
            let cell = self.topViewTableView.dequeueReusableCell(withIdentifier: Identifier.topViewTableViewCell, for: indexPath) as! TopViewTableViewCell
            
            return cell
        }
        
    }
}
