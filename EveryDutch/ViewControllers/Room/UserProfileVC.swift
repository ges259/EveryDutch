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
    
    private let totalView: UIView = UIView.configureView(color: .deep_Blue)
    private var totalViewHeightConstraint: Constraint!
    private var totalViewBottomConstraint: Constraint!
    
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
    private var viewModel: UserProfileVMProtocol
    private let coordinator: UserProfileCoordProtocol
    
    private let btnSize: CGFloat = 60
    /// 테이블뷰의 셀의 높이
    private lazy var cellHeight: CGFloat = self.receiptTableView.frame.width / 7 * 2
    
    
    
    private var isInitialLayout: Bool = true
    
    private lazy var topViewBaseHeight: CGFloat = {
        return self.view.safeAreaInsets.bottom
        + 70 + 10 + UIDevice.current.panModalSafeArea
    }()
    
    
    private var currentTotalViewHeight: CGFloat {
        return self.totalView.frame.height
    }
    
    
    
    
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
        self.openView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isInitialLayout {
            self.isInitialLayout = false
            self.layoutUpdate()
        }
    }
}










// MARK: - 화면 설정
extension UserProfileVC {
    /// UI 설정
    private func configureUI() {
        
        if self.viewModel.isRoomManager {
            self.btnStackView.addArrangedSubview(self.kickBtn)
        }
        self.totalView.setRoundedCorners(.top, withCornerRadius: 20)
        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 12)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalView)
        self.totalView.addSubview(self.totalStackView)
        self.totalView.addSubview(self.tabBarView)
        self.tabBarView.addSubview(self.btnStackView)
        
        self.totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.totalViewBottomConstraint = make
                .bottom
                .equalTo(self.view.snp.bottom)
                .offset(self.cardHeight() + 150).constraint
            self.totalViewHeightConstraint = make
                .height
                .equalTo(80 + UIDevice.current.panModalSafeArea + self.cardHeight() + 17)
                .constraint
        }

        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight())
        }
        // 제약 조건을 뷰의 레이아웃이 완료된 후에 업데이트합니다.
        self.receiptTableView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(0) // 초기값 설정
        }
        
        
        self.tabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 버튼 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.panModalSafeArea)
            make.leading.trailing.equalToSuperview().inset(self.viewModel.btnStvInsets)
        }
        
        // 하단 버튼의 높이와 너비를 동일하게 설정
        [self.searchBtn, self.reportBtn, self.kickBtn].forEach { btn in
            btn.snp.makeConstraints { make in
                make.size.equalTo(self.btnSize)
            }
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
        
        // 탑뷰 - 팬 재스쳐
        let topViewPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.totalView.addGestureRecognizer(topViewPanGesture)
        let navPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.view.addGestureRecognizer(navPanGesture)
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
        self.viewModel.searchModeClosure = { [weak self] image, title in
            guard let self = self else { return }
            self.searchBtn.imageAndTitleFix(image: image, title: title)
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
            self.updateTableViewisHidden(!self.viewModel.isTableOpen)
            
        } else {
            print("false")
            self.viewModel.loadUserReceipt()
        }
    }
    @objc private func reportBtnTapped() {
        
    }
    @objc private func kickBtnTapped() {
        self.updateTableViewisHidden(true)
    }
}










// MARK: - 높이 설정
extension UserProfileVC {
    /// 탑뷰의 높이를 바꾸는 메서드
    private func updateTableViewisHidden(_ isHidden: Bool = false) {
        // 새로운 높이 구하기
        let newHeight: CGFloat = self.topViewHeight(isHidden: isHidden)
        // 새로운 높이를 저장
        self.totalViewHeightConstraint.update(offset: newHeight)
        // 현재 상태 저장
        self.viewModel.isTableOpen = isHidden
        // 애니메이션과 함께 UI바꾸기
        UIView.animate(withDuration: 0.3) {
            self.cardImgView.isHidden = isHidden
            self.view.layoutIfNeeded()
        }
    }
    /// 탑뷰의 높이를 구하는 메서드
    private func topViewHeight(isHidden: Bool) -> CGFloat {
        let height = isHidden
        ? self.receiptTableView.frame.height
        : self.cardHeight() + 17
        return self.topViewBaseHeight + height
    }
    
    private func updateTableViewLayout() {
        // 제약 조건 업데이트
        self.receiptTableView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(self.topViewHeight(isHidden: false))
        }
    }
    
    private func layoutUpdate() {
        let height = self.topViewHeight(isHidden: false)
        
        self.totalViewHeightConstraint.update(offset: height)
        self.view.layoutIfNeeded()
        
        
        self.btnStackView.snp.updateConstraints { make in
            make.bottom.equalTo(-self.view.safeAreaInsets.bottom - UIDevice.current.panModalSafeArea)
        }
    }
}










// MARK: - 탑뷰 제스쳐
extension UserProfileVC {
    /// 탑뷰를 스크롤 했을 때 호출되는 메서드
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        switch sender.state {
        case .began, .changed:
            handlePanGestureChanged(translation: translation)
            sender.setTranslation(.zero, in: self.view)
            
        case .ended:
            handlePanGestureEnded(velocity: velocity)
            
        default:
            break
        }
    }
    
    /// 팬 제스처 변경을 처리하는 메서드
    @MainActor
    private func handlePanGestureChanged(translation: CGPoint) {
        let currentOffset = self.totalViewBottomConstraint.layoutConstraints.first!.constant
        let newOffset = currentOffset + translation.y
        let clampedOffset = min(max(newOffset, 0), 
                                self.currentTotalViewHeight)
        
        self.totalViewBottomConstraint.update(offset: clampedOffset)
        self.view.layoutIfNeeded()
    }
    
    /// 팬 제스처 종료를 처리하는 메서드
    @MainActor
    private func handlePanGestureEnded(velocity: CGPoint) {
        // 조금만 아래로 스크롤해도 화면이 내려가도록 임계값을 낮게 설정
        // 속도 임계값 설정
        let thresholdVelocity: CGFloat = 1000
        // 오프셋 임계값 설정
        let thresholdOffset: CGFloat = self.currentTotalViewHeight * 0.15
        // 현재 임계값 가져오기
        let currentOffset = self.totalViewBottomConstraint.layoutConstraints.first!.constant
        
        if velocity.y > thresholdVelocity || currentOffset > thresholdOffset {
            self.closeView()
        } else {
            self.animateTotalViewToDefaultPosition()
        }
    }
    
    @MainActor
    private func openView() {
        self.totalViewBottomConstraint.update(offset: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.view.layoutIfNeeded()
        }
    }
    
    /// 뷰를 닫는 메서드( +애니메이션)
    @MainActor
    private func closeView() {
        self.totalViewBottomConstraint.update(offset: self.currentTotalViewHeight)
        
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.coordinator.didFinish()
        }
    }
    
    /// totalView를 기본 위치(totalView를 닫지 않음)로 되돌리는 메서드
    @MainActor
    private func animateTotalViewToDefaultPosition() {
        UIView.animate(withDuration: 0.4) {
            self.totalViewBottomConstraint.update(offset: 0)
            self.view.layoutIfNeeded()
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
