////
////  UsersTableHeaderView.swift
////  EveryDutch
////
////  Created by 계은성 on 7/2/24.
////
//
//import UIKit
//
//protocol UsersTableViewHeaderViewDelegate: AnyObject {
//    func buttonTapped(isFirstButton: Bool)
//}
//
//
//final class UsersTableHeaderView: UITableViewHeaderFooterView {
//    // MARK: - 레이아웃
//    /// cumulativeAmount 버튼
//    private var firstBtn: UIButton = UIButton.btnWithTitle(
//        title: "누적 금액",
//        font: UIFont.systemFont(ofSize: 14),
//        backgroundColor: UIColor.normal_white)
//    /// payback 버튼
//    private var secondBtn: UIButton = UIButton.btnWithTitle(
//        title: "받아야 할 돈",
//        font: UIFont.systemFont(ofSize: 14),
//        backgroundColor: UIColor.unselected_gray)
//    
//    /// 버튼 스택뷰
//    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
//        arrangedSubviews: [self.firstBtn,
//                           self.secondBtn],
//        axis: .horizontal,
//        spacing: 0,
//        alignment: .fill,
//        distribution: .fillEqually)
//    
//    
//    
//    // MARK: - 프로퍼티
//    weak var delegate: UsersTableViewHeaderViewDelegate?
//    private let btnColorArray: [UIColor] = [
//        .normal_white,
//        .unselected_gray]
//    var isFirstBtnTapped: Bool = true
//    
//    
//    
//    // MARK: - 라이프사이클
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        
//        self.configureUI()
//        self.configureAutoLayout()
//        self.configureAction()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    deinit { NotificationCenter.default.removeObserver(self) }
//    
//    
//    
//    // MARK: - 화면 설정
//    /// UI 설정
//    private func configureUI() {
//        // 첫 번째 버튼의 모서리
//        self.firstBtn.setRoundedCorners(.leftTop, withCornerRadius: 10)
//        // 두 번째 버튼의 모서리
//        self.secondBtn.setRoundedCorners(.rightTop, withCornerRadius: 10)
//    }
//    
//    /// 오토레이아웃 설정
//    private func configureAutoLayout() {
//        self.addSubview(self.btnStackView)
//        
//        self.btnStackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.height.equalTo(30)
//        }
//    }
//    /// 액션 설정
//    private func configureAction() {
//        [self.firstBtn,
//         self.secondBtn].forEach { [weak self] btn in
//            btn.addTarget(
//                self,
//                action: #selector(self?.btnTapped),
//                for: .touchUpInside)
//        }
//    }
//    
//    
//    
//    // MARK: - 액션
//    /// 액션 메서드
//    @objc private func btnTapped(_ sender: UIButton) {
//        // 현재 눌린 버튼이 어떤 버튼인지 알아내기
//        let btnBoolean = sender == self.firstBtn
//        self.isFirstBtnTapped = btnBoolean
//        // 버튼 색상을 바꾸기 위한 함수
//        self.btnColorChange()
//        
//        self.delegate?.buttonTapped(isFirstButton: btnBoolean)
//    }
//    
//    /// 버튼 색상 설정 메서드
//    private func btnColorChange() {
//        // 버튼의 색상을 가져옮 (어떤 버튼이 눌렸는 지에 따라 다랄짐
//        let btnColor = self.isFirstBtnTapped
//        ? self.btnColorArray
//        : self.btnColorArray.reversed()
//        
//        // 버튼 색상 설정
//        self.firstBtn.backgroundColor = btnColor[0]
//        self.secondBtn.backgroundColor = btnColor[1]
//    }
//}
//










//final class UsersTableView: CustomTableView {
//
//    // MARK: - 프로퍼티
//    private var viewModel: UsersTableViewVMProtocol
//    // Delegate 프로퍼티 추가
//    weak var usersTableViewDelegate: UsersTableViewDelegate?
//    var isViewVisible: Bool = true {
//        didSet { self.updateUsersTableView() }
//    }
//
//
//
//    // MARK: - 라이프사이클
//    init(viewModel: UsersTableViewVMProtocol) {
//        self.viewModel = viewModel
//
//        super.init(frame: .zero, style: .plain)
//        self.configureNotification()
//        self.configureTableView()
//        self.configureCornerRadius()
//        self.configureClosure()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//
//
//// MARK: - 화면 설정
//extension UsersTableView {
//    /// UI설정
//    private func configureCornerRadius() {
//        // 뷰(self)의 모서리
//        self.setRoundedCorners(.all, withCornerRadius: 10)
//    }
//
//    /// 테이블뷰 설정
//    private func configureTableView() {
//        self.delegate = self
//        self.dataSource = self
//        self.register(
//            UsersTableViewCell.self,
//            forCellReuseIdentifier: Identifier.topViewTableViewCell)
//        self.register(
//            UsersTableHeaderView.self,
//            forHeaderFooterViewReuseIdentifier: Identifier.usersTableHeaderView)
//
//        self.sectionHeaderTopPadding = 0
//        self.separatorStyle = .none
//        self.showsVerticalScrollIndicator = false
//        self.bounces = true
//        self.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
//    }
//    /// 노티피케이션 설정
//    private func configureNotification() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.handleDataChanged(notification:)),
//            name: .userDataChanged,
//            object: nil)
//    }
//    /// 클로저 설정
//    private func configureClosure() {
//        self.viewModel.userCardDataClosure = { [weak self] in
//            guard let self = self else { return }
//            self.usersTableViewDelegate?.didSelectUser()
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//// MARK: - 상단 버튼 액션
//extension UsersTableView: UsersTableViewHeaderViewDelegate {
//    func buttonTapped(isFirstButton: Bool) {
//        // 눌린 버튼을 뷰모델에 저장
//        self.viewModel.isFirstBtnTapped = isFirstButton
//        // 테이블뷰 reload를 통해 - price의 정보 바꾸기
//        self.reloadData()
//    }
//}
//
//
//
//
//
//
//
//
//
//
//// MARK: - 테이블뷰 델리게이트
//extension UsersTableView: UITableViewDelegate {
//    /// 셀의 높이
//    func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath)
//    -> CGFloat {
//        return 40
//    }
//
//    /// didSelectRowAt
//    func tableView(_ tableView: UITableView,
//                   didSelectRowAt indexPath: IndexPath) {
//        print(#function)
//        self.viewModel.selectUser(index: indexPath.row)
//    }
//
//    func tableView(_ tableView: UITableView,
//                   viewForHeaderInSection section: Int
//    ) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(
//            withIdentifier: Identifier.usersTableHeaderView) as? UsersTableHeaderView else {
//            return nil
//        }
//        headerView.delegate = self
//        return headerView
//    }
//    func tableView(_ tableView: UITableView,
//                   heightForHeaderInSection section: Int
//    ) -> CGFloat {
//        return 30
//    }
//}
//
//
//
//// MARK: - 테이블뷰 데이터소스
//extension UsersTableView: UITableViewDataSource {
//    /// 셀의 개수
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int)
//    -> Int {
//        return self.viewModel.numbersOfUsers
//    }
//
//    /// cellForRowAt
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath)
//    -> UITableViewCell {
//        let cell = self.dequeueReusableCell(
//            withIdentifier: Identifier.topViewTableViewCell,
//            for: indexPath) as! UsersTableViewCell
//
//        let cellViewModel = self.viewModel.cellViewModel(
//            at: indexPath.item)
//        cell.configureCell(with: cellViewModel,
//                           firstBtnTapped: self.viewModel.isFirstBtnTapped)
//        return cell
//    }
//}
//
//
//
//
//
//
//
//
//
//
//// MARK: - 인덱스패스 리로드
//extension UsersTableView {
//    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
//    @objc private func handleDataChanged(notification: Notification) {
//        guard let dataInfo = notification.userInfo as? [String: Any] else { return }
//
//        let rawValue = notification.name.rawValue
//
//        switch rawValue {
//        case Notification.Name.userDataChanged.rawValue:
//            self.viewModel.userDataChanged(dataInfo)
//        default:
//            break
//        }
//        self.updateUsersTableView()
//    }
//
//    private func updateUsersTableView() {
//        guard self.isViewVisible else { return }
//        let pendingIndexPaths = self.viewModel.getPendingUserDataIndexPaths()
//
//        guard pendingIndexPaths.count != 0 else { return }
//
//        if pendingIndexPaths.count == 1 {
//            pendingIndexPaths.forEach { (key: String, value: [IndexPath]) in
//                self.updateIndexPath(key: key, indexPaths: value)
//                self.numberOfUsersChanges(key: key)
//            }
//        } else {
//            self.reloadData()
//        }
//        self.viewModel.resetPendingUserDataIndexPaths()
//    }
//
//    @MainActor
//    private func updateIndexPath(key: String, indexPaths: [IndexPath]) {
//        switch key {
//        case DataChangeType.updated.notificationName:
//            self.reloadRows(at: indexPaths, with: .automatic)
//            break
//        case DataChangeType.initialLoad.notificationName:
//            self.reloadData()
//            break
//        case DataChangeType.added.notificationName:
//            // 테이블 뷰 업데이트
//            self.insertRows(at: indexPaths, with: .automatic)
//            break
//        case DataChangeType.removed.notificationName:
//            // 테이블 뷰 업데이트
//            self.deleteRows(at: indexPaths, with: .automatic)
//            break
//        default:
//            print("\(self) ----- \(#function) ----- Error")
//            self.reloadData()
//            break
//        }
//    }
//    /// 유저의 수가 바뀐다면, 노티피케이션을 post하여 셀의 개수 변경
//    private func numberOfUsersChanges(key indexPathKey: String) {
//        // 업데이트가 아니라면,
//        guard indexPathKey != DataChangeType.updated.notificationName else { return }
//        // 스크롤 가능 여부 업데이트
//        self.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
//        // 높이 업데이트를 위한 delgate
//        self.usersTableViewDelegate?.didUpdateUserCount()
//    }
//}
