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
    
    private let totalView: UIView = UIView.configureView(
        color: .deep_Blue)
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
        let view = CustomTableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        view.register(
            ReceiptSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: Identifier.receiptSectionHeaderView)
        view.backgroundColor = .clear
        view.bounces = true
        view.transform = CGAffineTransform(rotationAngle: .pi)
        view.sectionHeaderTopPadding = 0
        return view
    }()
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.receiptTableView,
                           self.noDataView],
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
        cornerRadius: self.smallButtonSize())
    private lazy var reportBtn: UIButton = UIButton.btnWithImg(
        image: .exclamationmark_Img,
        title: "신고",
        cornerRadius: self.smallButtonSize())
    private lazy var kickBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        title: "강퇴",
        cornerRadius: self.smallButtonSize())
    
    /// 버튼으로 구성된 가로로 된 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.searchBtn],
        axis: .horizontal,
        spacing: 16,
        alignment: .fill,
        distribution: .equalSpacing)
    
    private let noDataView: NoDataView = NoDataView(
        type: .ReceiptWriteScreen,
        cornerRadius: 12)
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UserProfileVMProtocol
    private let coordinator: UserProfileCoordProtocol
    
    
    private var isInitialLayout: Bool = true
    
    private lazy var topViewBaseHeight: CGFloat = {
        return self.view.safeAreaInsets.bottom
        + self.smallButtonSize() + 10 + 10 + UIDevice.current.panModalSafeArea
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
        // 자기 자신인지 확인
        if self.viewModel.currentUserIsEuqualToMyUid {
            // 자기 자신이 아니라면, 신고 버튼 추가
            self.btnStackView.addArrangedSubview(self.reportBtn)
            
            // 방장인지 확인
            if self.viewModel.isRoomManager {
                // 방장이라면, 강퇴 버튼 추가
                self.btnStackView.addArrangedSubview(self.kickBtn)
            }
        }
        self.totalView.setRoundedCorners(.top, withCornerRadius: 20)
        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 12)
        self.totalStackView.setCustomSpacing(0, after: self.receiptTableView)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalView)
        self.totalView.addSubview(self.totalStackView)
        self.totalView.addSubview(self.tabBarView)
        self.tabBarView.addSubview(self.btnStackView)
        
        // [totalStackView, tabBarView]를 포함하는 커스텀 뷰
        self.totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.totalViewBottomConstraint = make
                .bottom
                .equalTo(self.view.snp.bottom)
                .offset(self.cardHeight() + 150).constraint
            self.totalViewHeightConstraint = make
                .height
                .equalTo(
                    self.smallButtonSize() + 10
                    + self.cardHeight() + 17
                    + UIDevice.current.panModalSafeArea)
                .constraint
        }
        
        // [카드 이미지뷰, 영수증 테이블뷰, NoDataView]를 포함하는 스택뷰
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight())
        }
        // 제약 조건을 뷰의 레이아웃이 완료된 후에 업데이트
        self.receiptTableView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(0)
        }
        // 데이터가 없을 때 나타는 뷰의 높이 설정
        self.noDataView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight())
        }
        
        // 하단 탭바 설정
        self.tabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 버튼 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.panModalSafeArea)
            // 버튼 스택뷰의 leading 및 trailing을 설정하는 메서드
            self.configureBtnStackViewConstraints(
                make: make,
                numOfBtn: self.btnStackView.arrangedSubviews.count)
        }
        // 하단 버튼의 높이와 너비를 동일하게 설정
        [self.searchBtn, self.reportBtn, self.kickBtn].forEach { btn in
            btn.snp.makeConstraints { make in
                make.size.equalTo(self.smallButtonSize())
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
        
        // 탑뷰 - 팬 제스쳐
        let topViewPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.totalView.addGestureRecognizer(topViewPanGesture)
        topViewPanGesture.delegate = self

        let viewPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.scrollVertical))
        self.view.addGestureRecognizer(viewPanGesture)
        viewPanGesture.delegate = self
        
        let viewTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.closeView))
        self.view.addGestureRecognizer(viewTapGesture)
        viewTapGesture.delegate = self
    }
    
    /// 클로저를 설정
    private func configureClosure() {
        self.viewModel.fetchSuccessClosure = { [weak self] in
            guard let self = self else { return }
            self.receiptSuccessClosure()
        }
        
        self.viewModel.deleteUserSuccessClosure = { [weak self] in
            guard let self = self else { return }
            self.closeView()
        }
        // choji
        self.viewModel.reportSuccessClosure = { [weak self] alertType, reportCount in
            guard let self = self else { return }
            self.customAlert(alertEnum: alertType, reportCount: reportCount) { _ in
                self.closeView()
            }
        }
        
        self.viewModel.searchModeClosure = { [weak self] image, title in
            guard let self = self else { return }
            self.searchModeSuccess(image: image, title: title)
        }
        
        self.viewModel.errorClosure = { [weak self] error in
            print("errorClosure")
            guard let self = self else { return }
            self.errorClosure(error)
        }
    }
}










// MARK: - 클로저 설정
extension UserProfileVC {
    /// api작업 시, 가져온 데이터 IndexPath배열을 처리하는 메서드
    private func receiptSuccessClosure() {
        let receiptSections = viewModel.getPendingSections()
        
        if let (key, sections) = receiptSections.first, receiptSections.count == 1 {
            self.handleSingleSectionUpdate(for: key, sections: sections)
        } else {
            self.receiptTableViewChange {
                self.receiptTableView.reloadData()
            }
        }
        
        self.viewModel.resetIndexPaths()
    }
    
    private func handleSingleSectionUpdate(for key: String, sections: [Int]) {
        self.receiptTableViewChange {
            switch key {
            case DataChangeType.sectionInsert.notificationName:
                self.insertTableViewSections(sections)
            case DataChangeType.sectionReload.notificationName:
                self.reloadTableViewSections(sections)
            default:
                break
            }
        }
    }
    
    private func reloadTableViewSections(_ sections: [Int]) {
        let sectionsToReload = IndexSet(sections)
        print(#function)
        dump(sectionsToReload)
        
        self.receiptTableView.beginUpdates()
        self.receiptTableView.reloadSections(sectionsToReload, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to reload: \(sectionsToReload)")
    }
    
    private func insertTableViewSections(_ sections: [Int]) {
        let sectionsToInsert = IndexSet(sections)
        print(#function)
        dump(sectionsToInsert)
        
        self.receiptTableView.beginUpdates()
        self.receiptTableView.insertSections(sectionsToInsert, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to insert: \(sectionsToInsert)")
    }
    
    private func receiptTableViewChange(action: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.showLoading(false)
            self.dataChanged()
        }
        action()
        CATransaction.commit()
    }
    
    
    
    
    
    
    
    /// api작업 시, 에러를 처리하는 메서드
    private func errorClosure(_ error: ErrorEnum) {
        self.showLoading(false)
        
        switch error {
        case .noMoreData:
            print("noMoreData")
            self.dataChanged()
            self.viewModel.disableMoreUserReceiptDataLoading()
            break
            
        case .noInitialData:
            print("noInitialData")
            self.viewModel.markNoDataAvailable()
            self.updateNoDataViewIsHidden(false)
            break
            
        case .alreadyReported:
            self.customAlert(alertEnum: error.alertType) { _ in }
            break
            
        default:
            print("default ----- \(error)")
            break
        }
    }
    /// (1회 한정) api작업 후, 테이블뷰의 높이를 설정하는 메서드
    private func dataChanged() {
        if !self.viewModel.userReceiptInitialLoad {
            self.viewModel.userReceiptInitialLoadSetTrue()
            self.updateTableViewisHidden(true)
        }
    }
    /// '검색' 버튼을 눌렀을 때, 검색 버튼의 이미지와 타이틀을 바꾸는 메서드
    private func searchModeSuccess(image: UIImage?, title: String) {
        self.searchBtn.imageAndTitleFix(image: image, title: title)
    }
}











// MARK: - 액션 설정
extension UserProfileVC {
    /// 검색 버튼을 눌렀을 때, 액션
    /// 처음 누른 상태 -> 영수증 데이터를 가져옴
    /// 데이터를 가져온 상태 -> 테이블뷰 오픈 or 닫기
    /// 데이터가 없는 상태 -> NoDataView 오픈 or 닫기
    @objc private func searchBtnTapped() {
        
        // 데이터가 없는 상태
        if self.viewModel.hasNoData {
            self.updateNoDataViewIsHidden(self.viewModel.isTableOpen)
        }
        
        // fireLoadSuccess가 true라면, 테이블만 보이게 하기.
        else if self.viewModel.userReceiptInitialLoad {
            self.updateTableViewisHidden(!self.viewModel.isTableOpen)
        }
        
        // fireLoadSuccess가 false라면, 데이터 가져오기
        else {
            self.viewModel.loadUserReceipt()
        }
    }
    
    /// 신고 버튼을 눌렀을 때 호출 되는 메서드
    /// 신고 횟수를 1회 늘리고, 만약 3회 이상이라면, 강퇴
    @objc private func reportBtnTapped() {
        self.customAlert(alertEnum: .requestReport) { _ in
            self.viewModel.reportUser()
        }
    }
    
    /// 해당 유저를 강퇴하는 메서드
    @objc private func kickBtnTapped() {
        // 얼럿창 띄우기
        self.customAlert(alertEnum: .kickUser) { _ in
            self.viewModel.kickUser()
        }
    }
}










// MARK: - 높이 설정
extension UserProfileVC {
    /// 영수증 데이터가 있을 때, 테이블뷰의 높이에 맞춰 totalView의 높이를 바꾸는 메서드
    private func updateTableViewisHidden(_ isHidden: Bool = false) {
        // 새로운 높이 구하기
        let newHeight: CGFloat = self.totalViewHeight(isHidden: isHidden)
        let currentHeight: CGFloat = self.totalViewHeightConstraint.layoutConstraints.first?.constant ?? 0

        // 새로운 높이와 현재 높이가 같지 않은 경우에만 업데이트
        if newHeight != currentHeight {
            // 새로운 높이를 저장
            self.totalViewHeightConstraint.update(offset: newHeight)
            
            // 현재 상태 저장
            self.viewModel.setTableOpenState(isHidden)
            // 애니메이션과 함께 UI바꾸기
            UIView.animate(withDuration: 0.3) {
                self.cardImgView.isHidden = isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    /// 영수증 데이터가 없을 때, NoDataView에 맞춰 높이를 변경하는 메서드
    private func updateNoDataViewIsHidden(_ isHidden: Bool) {
        // 현재 상태 저장
        self.viewModel.setTableOpenState(!isHidden)
        // 애니메이션과 함께 UI바꾸기
        UIView.animate(withDuration: 0.3) {
            self.noDataView.isHidden = isHidden
            self.cardImgView.isHidden = !isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    /// 탑뷰의 높이를 구하는 메서드
    private func totalViewHeight(isHidden: Bool) -> CGFloat {
        let height = isHidden
        ? self.receiptTableView.frame.height
        : self.cardHeight() + 17
        return self.topViewBaseHeight + height
    }
    
    /// 화면에 처음 들어서면, 레이아웃을 업데이트
    /// safeAreaInsets(top, bottom) 으로 인한 업데이트
    private func layoutUpdate() {
        // 버튼 스택뷰 하단
        self.btnStackView.snp.updateConstraints { make in
            make.bottom.equalTo(
                -self.view.safeAreaInsets.bottom
                - UIDevice.current.panModalSafeArea
            )
        }
        // 테이블뷰 제약 조건 업데이트
        self.receiptTableView.snp.updateConstraints { make in
            make.height.lessThanOrEqualTo(
                self.view.frame.height
                - self.view.safeAreaInsets.top
                - 17 - 10
                - self.tabBarView.frame.height
            )
        }
            
        self.totalViewHeightConstraint.update(
            offset: self.totalViewHeight(isHidden: false)
        )
        self.view.layoutIfNeeded()
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
    @objc
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
        return self.receiptTableCellHeight()
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath)
        // '영수증 화면'으로 화면 이동
        self.coordinator.ReceiptScreen(receipt: receipt)
    }
}

// MARK: - 테이블뷰 데이터 소스
extension UserProfileVC: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numOfSections
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numOfReceipts(section: section)
    }
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Identifier.receiptSectionHeaderView) as? ReceiptSectionHeaderView else {
            return nil
        }
        let sectionInfo = self.viewModel.getReceiptSectionDate(section: section)
        
        headerView.configure(with: sectionInfo,
                             labelBackgroundColor: .normal_white)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 // 최소 높이를 40으로 설정
    }
    
    /// 헤더를 nil로 설정
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        return nil
    }
    /// 헤더의 높이를 0으로 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 0
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.receiptTableView.dequeueReusableCell(
            withIdentifier: Identifier.settlementTableViewCell,
            for: indexPath) as! SettlementTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellViewModel)
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        cell.backgroundColor = .normal_white
        return cell
    }
}










// MARK: - 스크롤뷰 및 제스쳐
extension UserProfileVC: UIGestureRecognizerDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if contentOffsetY > contentHeight - height {
            self.showLoading(true)
            self.viewModel.loadUserReceipt()
        }
    }
    /// 메서드를 통해 팬 제스처와 다른 제스처 인식기가 동시에 인식되지 않도록 설정
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // totalView를 터치했을 경우 view의 tapGesture가 인식되지 않도록 설정
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: self.view)
            if self.totalView.frame.contains(location) {
                return false
            }
        }
        return true
    }
}
