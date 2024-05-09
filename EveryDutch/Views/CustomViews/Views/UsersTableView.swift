//
//  UserTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit
import SnapKit

final class UsersTableView: UIView {
    
    // MARK: - 버튼 레이아웃
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        title: "누적 금액",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)
    
    private var secondBtn: UIButton = UIButton.btnWithTitle(
        title: "받아야 할 돈",
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.firstBtn,
                           self.secondBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    // MARK: - 유저 테이블뷰
    private lazy var usersTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            UsersTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        
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
    
    
    func userDataReload(at pendingIndexPaths: [String: [IndexPath]]) {
        
        
        if !((pendingIndexPaths["initialLoad"] ?? []).isEmpty) {
            self.usersTableView.reloadData()
            return
        }
        
        self.usersTableView.performBatchUpdates {
            print(#function)
            print(pendingIndexPaths["added"] ?? [])
            print(pendingIndexPaths["removed"] ?? [])
            print(pendingIndexPaths["updated"] ?? [])
                
            self.usersTableView.insertRows(
                at: pendingIndexPaths["added"] ?? [],
                with: .automatic)
            self.usersTableView.deleteRows(
                at: pendingIndexPaths["removed"] ?? [],
                with: .automatic)
            self.usersTableView.reloadRows(
                at: pendingIndexPaths["updated"] ?? [],
                with: .automatic)
        }
    }
    func moneyDataReload(at pendingIndexPaths: [String: [IndexPath]]) {
        self.usersTableView.performBatchUpdates {
            self.usersTableView.reloadRows(
                at: pendingIndexPaths["updated"] ?? [],
                with: .automatic)
        }
    }
    
}
    
    
 







// MARK: - 화면 설정

extension UsersTableView {
    
    // MARK: - UI설정
    private func configureCornerRadius() {
        // 뷰(self)의 모서리
        self.setRoundedCorners(.all, withCornerRadius: 10)
        // 첫 번째 버튼의 모서리
        self.firstBtn.setRoundedCorners(.leftTop, withCornerRadius: 10)
        // 두 번째 버튼의 모서리
        self.secondBtn.setRoundedCorners(.rightTop, withCornerRadius: 10)
    }
    
    
    private func configureAutoLayout() {
        self.addSubview(self.btnStackView)
        self.addSubview(self.usersTableView)
        
        self.btnStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        self.usersTableView.snp.makeConstraints { make in
            make.top.equalTo(self.btnStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        [self.firstBtn,
         self.secondBtn].forEach { btn in
            btn.addTarget(
                self,
                action: #selector(self.btnTapped),
                for: .touchUpInside)
        }
    }
    
    
    // MARK: - 셀 생성
    /// SettleMoneyRoomVC에서 데이터를 받아온 시점에서 뷰모델을 만드는 함수
    func makeCellViewModel() {
        
        // MARK: - Fix
//        self.viewModel.makeCellVM()
        self.usersTableView.reloadData()
    }
}
    
    








// MARK: - 액션 메서드

extension UsersTableView {
    
    // MARK: - 버튼 액션 메서드
    @objc private func btnTapped(_ sender: UIButton) {
        // 현재 눌린 버튼이 어떤 버튼인지 알아내기
        let btnBoolean = sender == self.firstBtn
        // 눌린 버튼을 뷰모델에 저장
        self.viewModel.isFirstBtnTapped = btnBoolean
        // 버튼 색상을 바꾸기 위한 함수
        self.btnColorChange()
        // 테이블뷰 reload를 통해 - price의 정보 바꾸기
        self.usersTableView.reloadData()
        
        print(self.viewModel.numbersOfUsers)
    }
    
    // MARK: - 버튼 색상 설정 메서드
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
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}



// MARK: - 테이블뷰 데이터소스
extension UsersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        print(#function)
        print(self.viewModel.numbersOfUsers)
        return self.viewModel.numbersOfUsers
    }
    
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
