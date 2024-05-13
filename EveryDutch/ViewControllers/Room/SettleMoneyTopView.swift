//
//  SettleMoneyTopView.swift
//  EveryDutch
//
//  Created by 계은성 on 5/13/24.
//

import UIKit
import SnapKit

final class SettleMoneyTopView: UIView {
    
    // MARK: - 유저 금액 테이블뷰
    /// 유저를 보여주는 테이블뷰
    private var usersTableView: UsersTableView = UsersTableView(
        viewModel: UsersTableViewVM(
            roomDataManager: RoomDataManager.shared, .isSettleMoney))
    
    // MARK: - 아래 방향 이미지
    private var arrowDownImg: UIImageView = {
        let img = UIImageView(image: UIImage.arrow_down)
        img.tintColor = .deep_Blue
        return img
    }()
    
    // MARK: - 인디케이터
    private var topViewIndicator: UIView = UIView.configureView(
        color: UIColor.black)
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor.deep_Blue
        // 탑뷰에 그림자 추가
        self.addShadow(shadowType: .bottom)
        
    }
    
    private func configureAutoLayout() {
        // 탑뷰 스택뷰
        self.usersTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(35 + 5 + 35)
            make.height.lessThanOrEqualTo(200 + 5 + 34 - 45 - 4)
        }
        
        // 유저 테이블뷰 아래로 스크롤 버튼
        self.arrowDownImg.snp.makeConstraints { make in
            make.bottom.equalTo(self.usersTableView.snp.bottom).offset(-8)
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        // 하단 인디케이터
        self.topViewIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(4.5)
            make.centerX.equalToSuperview()
        }
    }
}
