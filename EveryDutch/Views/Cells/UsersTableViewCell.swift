//
//  TopViewTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class UsersTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var tableCellStv: TableCellStackView = TableCellStackView(
        rightImgInStackView: false)
    
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .check_Square_Img,
        imageSize: 13)
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UsersTableViewCellVM?
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension UsersTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .normal_white
        self.selectionStyle = .none
        self.separatorInset = .zero
    }

    // MARK: - 뷰모델을 통한 셀 설정
    func configureCell(with viewModel: UsersTableViewCellVM?) {
        // 뷰모델 저장
        self.viewModel = viewModel
        // viewModel을 사용하여 셀의 뷰를 업데이트.
        guard let viewModel = viewModel else { return }
        self.tableCellStv.userNameLbl.text = viewModel.userName
        self.tableCellStv.priceLbl.text = "\(viewModel.cumulativeAmount)"
        self.tableCellStv.profileImg.image = viewModel.profileImg
        
        self.rightBtn.setImage(viewModel.rightBtnImg, for: .normal)
        
        self.configureAutoLayout(viewModel: viewModel)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout(viewModel: UsersTableViewCellVM) {
        
        self.addSubview(self.tableCellStv)
        switch viewModel.customTableEnum {
        case .isSettleMoney:
            self.configureSettleMoneyRoomVC()
        case .isRoomSetting:
            self.configureRoomSettingVC()
        case .isSettle:
            self.configureSettleVC()
        }
        
    }
    
    
    
    private func configureSettleMoneyRoomVC() {
        self.addSubview(self.rightBtn)
        self.rightBtn.isUserInteractionEnabled = false
        self.configureStvWithBtn()
    }
    private func configureRoomSettingVC() {
        self.contentView.addSubview(self.rightBtn)
        self.configureAction()
        self.rightBtn.isUserInteractionEnabled = true
        self.configureStvWithBtn()
    }
    private func configureSettleVC() {
        self.tableCellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }

    
    
    
    private func configureStvWithBtn() {
        self.rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        
        self.tableCellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightBtn.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    
}
    







    

// MARK: - 상황에 따른 뷰 설정

extension UsersTableViewCell {
    

    
    // MARK: - 오른쪽 버튼 설정
    private func configureRightBtn(_ viewModel: UsersTableViewCellVM) {


       
        
    }
}










extension UsersTableViewCell {
    // MARK: - 액션 설정
    private func configureAction() {
        self.rightBtn.addTarget(
            self,
            action: #selector(self.rightBtnTapped),
            for: .touchUpInside)
    }
    
    
    
    // MARK: - 버튼 액션 설정
    @objc func rightBtnTapped() {
        print(#function)
    }

}
