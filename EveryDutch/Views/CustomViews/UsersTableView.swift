//
//  UserTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class UsersTableView: CustomTableView {
    
    // MARK: - 버튼 스택뷰 레이아웃
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
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var viewModel: UsersTableViewVMProtocol
    
    
    
    // MARK: - 라이프사이클
    init(viewModel: UsersTableViewVMProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        
        self.configureUI()
        self.configureAction()
        self.configureEnum(self.viewModel.customTableEnum)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 









// MARK: - 화면 설정

extension UsersTableView {
    
    // MARK: - UI설정
    private func configureUI() {
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.dataSource = self
        
        self.register(
            UsersTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        
        // 모서리 설정
        self.firstBtn.layer.maskedCorners = [.layerMinXMinYCorner]
        self.secondBtn.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.firstBtn.layer.cornerRadius = 10
        self.secondBtn.layer.cornerRadius = 10
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.firstBtn.addTarget(
            self,
            action: #selector(self.firstBtnTapped),
            for: .touchUpInside)
        self.secondBtn.addTarget(
            self,
            action: #selector(self.firstBtnTapped),
            for: .touchUpInside)
    }
    
    
    // MARK: - Enum에 따른 설정
    private func configureEnum(_ customTableEnum: CustomTableEnum) {
        switch customTableEnum {
            // 상단 버튼
        case .isRoomSetting, .isSettleMoney:
            self.layer.maskedCorners = [.layerMinXMaxYCorner,
                                        .layerMaxXMaxYCorner]
            
            self.tableHeaderView = self.btnStackView
            self.btnStackView.frame = CGRect(
                x: 0,
                y: 0,
                width: self.frame.size.width,
                height: 34)
            fallthrough
            // 레이블
        case .isSettle:
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            break
        }
    }
}
    
    








// MARK: - 액션 메서드 설정

extension UsersTableView {
    
    // MARK: - 버튼 액션 메서드
    @objc private func firstBtnTapped(_ sender: UIButton) {
        // 현재 눌린 버튼이 어떤 버튼인지 알아내기
        let btnBoolean = sender == self.firstBtn
        // 눌린 버튼을 뷰모델에 저장
        self.viewModel.firstBtnTapped = btnBoolean
        ? true
        : false
        // 버튼 색상을 바꾸기 위한 함수
        self.btnColorChange()
        // 테이블뷰 reload를 통해 - price의 정보 바꾸기
        self.reloadData()
    }
    
    // MARK: - 버튼 색상 설정
    func btnColorChange() {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numbersOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: Identifier.topViewTableViewCell,
            for: indexPath) as! UsersTableViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel, 
                           firstBtnTapped: self.viewModel.firstBtnTapped)
        return cell
    }
}
