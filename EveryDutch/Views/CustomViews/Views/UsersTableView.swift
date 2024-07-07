//
//  UserTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit
import SnapKit

protocol UsersTableViewDelegate: AnyObject {
    func didSelectUser()
    func didUpdateUserCount()
}
extension UsersTableViewDelegate {
    func didUpdateUserCount() {
        print("didUpdateUserCount ---- Error")
    }
}

final class UsersTableView: UIView {
    // MARK: - 레이아웃
    /// cumulativeAmount 버튼
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        title: "누적 금액",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)
    /// payback 버튼
    private var secondBtn: UIButton = UIButton.btnWithTitle(
        title: "받아야 할 돈",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    /// 버튼 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.firstBtn,
                           self.secondBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    /// 유저 테이블뷰
    private lazy var usersTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            UsersTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        view.sectionHeaderTopPadding = 0
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.bounces = true
        view.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
        return view
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UsersTableViewVMProtocol
    
    // Delegate 프로퍼티 추가
    weak var delegate: UsersTableViewDelegate?
    
    var isViewVisible: Bool = true {
        didSet { self.updateUsersTableView() }
    }
    var currentTableViewRowCount: Int {
        return self.usersTableView.numberOfRows(inSection: 0)
    }
    
    // MARK: - 라이프사이클
    init(viewModel: UsersTableViewVMProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureNotification()
        self.configureCornerRadius()
        self.configureAction()
        self.configureAutoLayout()
        self.configureClosure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit { NotificationCenter.default.removeObserver(self) }
}










// MARK: - 화면 설정
extension UsersTableView {
    /// UI설정
    private func configureCornerRadius() {
        // 뷰(self)의 모서리
        self.setRoundedCorners(.all, withCornerRadius: 10)
        // 첫 번째 버튼의 모서리
        self.firstBtn.setRoundedCorners(.leftTop, withCornerRadius: 10)
        // 두 번째 버튼의 모서리
        self.secondBtn.setRoundedCorners(.rightTop, withCornerRadius: 10)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.btnStackView)
        self.addSubview(self.usersTableView)
        
        self.btnStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.usersTableView.snp.makeConstraints { make in
            make.top.equalTo(self.btnStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        [self.firstBtn,
         self.secondBtn].forEach { btn in
            btn.addTarget(
                self,
                action: #selector(self.btnTapped),
                for: .touchUpInside)
        }
    }
    /// 노티피케이션 설정
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: .userDataChanged,
            object: nil)
    }
    /// 클로저 설정
    private func configureClosure() {
        self.viewModel.userCardDataClosure = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didSelectUser()
        }
    }
}
    
    








// MARK: - 상단 버튼 액션
extension UsersTableView {
    @objc private func btnTapped(_ sender: UIButton) {
        // 현재 눌린 버튼이 어떤 버튼인지 알아내기
        let btnBoolean = sender == self.firstBtn
        // 눌린 버튼을 뷰모델에 저장
        self.viewModel.isFirstBtnTapped = btnBoolean
        // 버튼 색상을 바꾸기 위한 함수
        self.btnColorChange()
        // 테이블뷰 reload를 통해 - price의 정보 바꾸기
        self.usersTableView.reloadData()
    }
    
    /// 버튼 색상 설정 메서드
    private func btnColorChange() {
        // 버튼의 색상을 가져옮 (어떤 버튼이 눌렸는 지에 따라 다랄짐
        let btnColor = self.viewModel.getBtnColor
        // 버튼 색상 설정
        self.firstBtn.backgroundColor = btnColor[0]
        self.secondBtn.backgroundColor = btnColor[1]
    }
}










// MARK: - 테이블뷰 델리게이트
extension UsersTableView: UITableViewDelegate {
    /// 셀의 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        print(#function)
        self.viewModel.selectUser(index: indexPath.row)
    }
}



// MARK: - 테이블뷰 데이터소스
extension UsersTableView: UITableViewDataSource {
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.numbersOfUsers
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.usersTableView.dequeueReusableCell(
            withIdentifier: Identifier.topViewTableViewCell,
            for: indexPath) as! UsersTableViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(
            at: indexPath.item)
        cell.configureCell(with: cellViewModel,
                           firstBtnTapped: self.viewModel.isFirstBtnTapped)
        return cell
    }
}










// MARK: - 인덱스패스 리로드
extension UsersTableView {
    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
    @objc private func handleDataChanged(notification: Notification) {
        guard let dataInfo = notification.userInfo as? [String: Any] else { return }
        let rawValue = notification.name.rawValue
        
        switch rawValue {
        case Notification.Name.userDataChanged.rawValue:
            self.viewModel.userDataChanged(dataInfo)
        default:
            break
        }
        self.updateUsersTableView()
    }
    
    private func updateUsersTableView() {
        // 현재 화면에 보이는 상태라면,
        guard self.isViewVisible else { return }
        // 변경된 IndexPath배열 가져오기
        let pendingIndexPaths = self.viewModel.getPendingUserDataIndexPaths()
        // 비어있다면, return
        guard !pendingIndexPaths.isEmpty else { return }
        // 메인스레드에서 진행
        DispatchQueue.main.async {
            if pendingIndexPaths.count == 1 {
                // 1개라면, 따로 진행
                self.updateIndexPath(pendingIndexPaths: pendingIndexPaths)
                
            } else {
                // 여러개라면, 전체 리로드
                self.usersTableView.reloadData()
            }
        }
        // 변경된 IndexPath배열을 리셋
        self.viewModel.resetPendingUserDataIndexPaths()
    }
    
    private func updateIndexPath(pendingIndexPaths: [String : [IndexPath]]) {
        pendingIndexPaths.forEach { (key: String, indexPaths: [IndexPath]) in
            switch key {
            case DataChangeType.updated.notificationName:
                self.handleUpdate(indexPaths: indexPaths)
                
            case DataChangeType.added.notificationName:
                self.handleAdd(indexPaths: indexPaths)
                
            case DataChangeType.removed.notificationName:
                self.handleRemove(indexPaths: indexPaths)
                
            default:
                print("DEBUG: Unexpected key \(key)")
                self.tableViewTotalReload()
            }
            // 유저의 수가 바뀌었는지 확인, 바뀌었다면, TopView를 업데이트
            self.numberOfUsersChanges(key: key)
        }
    }
    // 셀 업데이트
    private func handleUpdate(indexPaths: [IndexPath]) {
        guard self.viewModel.validateRowExistenceForUpdate(
            indexPaths: indexPaths,
            totalRows: self.currentTableViewRowCount
        ) else {
            self.tableViewTotalReload()
            return
        }
        self.usersTableView.reloadRows(at: indexPaths, with: .automatic)
    }
    // 셀 insert
    private func handleAdd(indexPaths: [IndexPath]) {
        guard self.viewModel.validateRowCountChange(
            currentRowCount: self.currentTableViewRowCount,
            changedUsersCount: indexPaths.count
        ) else {
            self.tableViewTotalReload()
            return
        }
        self.usersTableView.insertRows(at: indexPaths, with: .automatic)
    }
    // 셀 삭제
    private func handleRemove(indexPaths: [IndexPath]) {
        guard self.viewModel.validateRowCountChange(
            currentRowCount: self.currentTableViewRowCount,
            changedUsersCount: -indexPaths.count
        ) else {
            self.tableViewTotalReload()
            return
        }
        self.usersTableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /// 유저의 수가 바뀐다면, 노티피케이션을 post하여 셀의 개수 변경
    private func numberOfUsersChanges(key indexPathKey: String) {
        // 업데이트가 아니라면,
        guard indexPathKey != DataChangeType.updated.notificationName else { return }
        // 스크롤 가능 여부 업데이트
        self.usersTableView.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
        // 높이 업데이트를 위한 delgate
        self.delegate?.didUpdateUserCount()
    }
    
    // 셀 리로드
    func tableViewTotalReload() {
        print("DEBUG: ----- \(#function)")
        self.usersTableView.reloadData()
    }
}
