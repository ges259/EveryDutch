//
//  UserTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit
import SnapKit

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
        view.bounces = true
        view.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
        return view
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UsersTableViewVMProtocol
    
    
    
    
    
    // MARK: - 라이프사이클
    init(viewModel: UsersTableViewVMProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.configureCornerRadius()
        self.configureAction()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    func userDataReload(at pendingIndexPaths: [String: [IndexPath]]) {
//        self.usersTableView.reloadData()
        if pendingIndexPaths.count > 1 {
            self.usersTableView.reloadData()
        } else {
            pendingIndexPaths.forEach { (key: String, value: [IndexPath]) in
                self.updateIndexPath(key: key, indexPaths: value)
                self.numberOfUsersChanges(key: key)
            }
        }
    }
    @MainActor
    private func updateIndexPath(key: String, indexPaths: [IndexPath]) {
        guard self.checkUserCount else { return }
        switch key {
        case DataChangeType.updated.notificationName:
            self.usersTableView.reloadRows(at: indexPaths, with: .automatic)
            break
        case DataChangeType.initialLoad.notificationName:
            self.usersTableView.reloadData()
            break
        case DataChangeType.added.notificationName:
            // 테이블 뷰 업데이트
            self.usersTableView.insertRows(at: indexPaths, with: .automatic)
            break
        case DataChangeType.removed.notificationName:
            // 테이블 뷰 업데이트
            self.usersTableView.deleteRows(at: indexPaths, with: .automatic)
            break
        default:
            print("\(self) ----- \(#function) ----- Error")
            self.usersTableView.reloadData()
            break
        }
    }
    
    private var checkUserCount: Bool {
        if self.viewModel.numbersOfUsers == self.usersTableView.numberOfRows(inSection: 0)
        {
            self.usersTableView.reloadData()
            return false
        }
        return true
    }
    
    
    /// 유저의 수가 바뀐다면, 노티피케이션을 post하여 셀의 개수 변경
    private func numberOfUsersChanges(key indexPathKey: String) {
        // 업데이트가 아니라면,
        guard indexPathKey != DataChangeType.updated.notificationName else { return }
        // 높이 업데이트
        self.usersTableView.isScrollEnabled = self.viewModel.tableViewIsScrollEnabled
        // 노티피케이션 전송
        NotificationCenter.default.post(
            name: .numberOfUsersChanges,
            object: nil,
            userInfo: nil)
    }
}
