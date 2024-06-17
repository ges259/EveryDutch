//
//  UserProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 6/10/24.
//

import UIKit
import SnapKit

final class UserProfileVC: UIViewController {
    // MARK: - 레이아웃
    /// 카드 이미지 뷰
    private lazy var cardImgView: CardImageView = {
        let view = CardImageView()
        let userDecoTuple = self.viewModel.getUserDecoTuple
        if let tuple = userDecoTuple {
            view.setupUserData(data: tuple.user)
            view.setupDecorationData(data: tuple.deco)
        }
        return view
    }()
    
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
    
    private let topView: UIView = UIView.configureView(
        color: .deep_Blue)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.receiptTableView],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    private var tabBarView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    /// 원형 버튼들
    private lazy var searchBtn: UIButton = UIButton.btnWithImg(
        image: .search_Img,
        title: "검색",
        cornerRadius: self.btnSize)
    private lazy var reportBtn: UIButton = UIButton.btnWithImg(
        image: .exclamationmark_Img,
        title: "신고",
        cornerRadius: self.btnSize)
    private lazy var kickBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        title: "강퇴",
        cornerRadius: self.btnSize)
    
    /// 버튼으로 구성된 가로로 된 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.searchBtn,
                           self.reportBtn],
        axis: .horizontal,
        spacing: 16,
        alignment: .fill,
        distribution: .equalSpacing)
    
    

    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var viewModel: UserProfileVMProtocol
    let coordinator: UserProfileCoordProtocol
    private let btnSize: CGFloat = 60
    
    /// 테이블뷰의 셀의 높이
    private lazy var cellHeight: CGFloat = self.receiptTableView.frame.width / 7 * 2
    
    var topViewBottomConstraint: Constraint!
    
    
    private var isInitialLayout: Bool = true
    
    var topViewBaseHeight: CGFloat = 0
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
    }
    init(viewModel: UserProfileVMProtocol,
         coordinator: UserProfileCoordProtocol)
    {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(#function) ----- 1")
        if self.isInitialLayout {
            print("\(#function) ----- 2")
            let height = self.view.frame.height
            - self.view.safeAreaInsets.top
            - self.tabBarView.frame.height
            - self.cardHeight() - 17 - 10

            self.topViewBottomConstraint.update(offset: height)
            self.topViewBaseHeight = height
            self.view.layoutIfNeeded()
            self.isInitialLayout = false
        }
    }
    
    private func updateTableViewLayout() {
        // 제약 조건 업데이트
        self.receiptTableView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(
                self.view.frame.height
                - 17
                - self.cardHeight()
                - 10
                - self.tabBarView.frame.height
                - self.view.safeAreaInsets.top)
        }
    }
    
    
    private func dataChange(data: User) {
        self.cardImgView.setupUserData(data: data)
    }
}










// MARK: - 화면 설정
extension UserProfileVC {
    /// UI 설정
    private func configureUI() {
        
        if self.viewModel.isRoomManager {
            self.btnStackView.addArrangedSubview(self.kickBtn)
        }
        self.topView.setRoundedCorners(.top, withCornerRadius: 20)
        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 12)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.topView)
        self.topView.addSubview(self.totalStackView)
        
        
        
        self.view.addSubview(self.tabBarView)
        self.tabBarView.addSubview(self.btnStackView)
        
        
        self.tabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 버튼 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-UIDevice.current.panModalSafeArea)
            
            make.leading.trailing.equalToSuperview().inset(self.viewModel.btnStvInsets)
        }
        // 하단 버튼의 높이와 너비를 동일하게 설정
        [self.searchBtn, self.reportBtn, self.kickBtn].forEach { btn in
            btn.snp.makeConstraints { make in
                make.size.equalTo(self.btnSize)
            }
        }
        // 상단 뷰
        self.topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(self.cardHeight())
            
            //            self.topViewBottomConstraint = make.bottom.equalTo(self.tabBarView.snp.top).offset(0).constraint
            self.topViewBottomConstraint = make
                .top
                .equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .offset(self.view.frame.height)
                .constraint
        }
        // 제약 조건을 뷰의 레이아웃이 완료된 후에 업데이트합니다.
        self.receiptTableView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(0) // 초기값 설정
        }
        
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight())
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        self.searchBtn.addTarget(
            self,
            action: #selector(self.searchBtnTapped),
            for: .touchUpInside)
        self.reportBtn.addTarget(
            self,
            action: #selector(self.reportBtnTapped),
            for: .touchUpInside)
        self.kickBtn.addTarget(
            self,
            action: #selector(self.kickBtnTapped),
            for: .touchUpInside)
    }
    
    private func configureClosure() {
        self.viewModel.fetchSuccessClosure = { [weak self] indexPaths in
            guard let self = self else { return }
            print(#function)
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.updateTableViewisHidden(true)
            }
            self.updateTableViewLayout()
            self.receiptTableView.reloadData()
            CATransaction.commit()
        }
    }
}




// MARK: - 액션 설정
extension UserProfileVC {
    @objc private func searchBtnTapped() {
        print(#function)
        // 눌렸다면,
        // fireLoadSuccess가 false라면, 데이터 가져오기
        // fireLoadSuccess가 true라면, 테이블만 보이게 하기.
        if self.viewModel.getUserReceiptLoadSuccess {
            print("true")
//            self.updateTableViewisHidden(false)
            self.updateTableViewisHidden(!self.viewModel.isTableOpen)
            
        } else {
            print("false")
            self.viewModel.loadUserReceipt()
        }
    }
    @objc private func reportBtnTapped() {
        self.view.backgroundColor = .clear
        self.coordinator.didFinish()
    }
    @objc private func kickBtnTapped() {
        self.updateTableViewisHidden(true)
    }
    
    
    private func updateTableViewisHidden(_ bool: Bool = false) {
        
//        if self.topViewBottomConstraint.layoutConstraints.first?.constant == self.topViewBaseHeight
        if bool {
            self.viewModel.isTableOpen = true
            // 테이블 뷰가 숨겨져 있을 때 보이도록 설정하고 아래서 위로 애니메이션
            self.topViewBottomConstraint
                .update(offset: self.topViewBaseHeight
                        - self.receiptTableView.frame.height
                        + cardHeight() + 17)
            
            UIView.animate(withDuration: 0.3) {
                self.cardImgView.isHidden = true
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.viewModel.isTableOpen = false
            // 테이블 뷰가 보이고 있을 때 위에서 아래로 애니메이션하고 숨김 설정
            self.topViewBottomConstraint.update(offset: self.topViewBaseHeight)
            
            UIView.animate(withDuration: 0.3) {
                self.cardImgView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
        
        
    }
}










// MARK: - 테이블뷰 델리게이트
extension UserProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath.row)
        
        // MARK: - Fix
        // '영수증 화면'으로 화면 이동
        self.coordinator.ReceiptScreen(receipt: receipt)
    }
}

// MARK: - 테이블뷰 데이터 소스
extension UserProfileVC: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
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
