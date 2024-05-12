//
//  UserTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class UsersTableView: CustomTableView {
    
    
    // MARK: - 프로퍼티
    var viewModel: UsersTableViewVM
    
    
    // MARK: - 라이프사이클
    init(viewModel: UsersTableViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        
        self.configureUI()
        self.configureEnum(self.viewModel.customTableEnum)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.dataSource = self
        
        self.register(
            SettlementDetailsTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
    }
    
    
    private func configureEnum(_ customTableEnum: CustomTableEnum) {
        switch customTableEnum {
            // 상단 + 하단 버튼
        case .isReceiptWrite: break
            
            // 상단 버튼
        case .isRoomSetting, .isSettle, .isSettleMoney:
            self.layer.maskedCorners = [.layerMaxXMinYCorner,
                .layerMaxXMaxYCorner]
            fallthrough
            // 레이블
        case .isReceiptScreen, .isPeopleSelection, .isSearch:
            self.layer.cornerRadius = 10
            break
        }
    }
}
extension UsersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension UsersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numbersOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: Identifier.topViewTableViewCell,
            for: indexPath) as! SettlementDetailsTableViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel)
        return cell
    }
    
    
}
