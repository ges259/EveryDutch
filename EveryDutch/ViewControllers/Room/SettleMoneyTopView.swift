//
//  SettleMoneyTopView.swift
//  EveryDutch
//
//  Created by 계은성 on 5/13/24.
//

import UIKit
import SnapKit

final class SettleMoneyTopView: UIView {
    // MARK: - 레이아웃
    /// 유저를 보여주는 테이블뷰
    private var usersTableView: UsersTableView = UsersTableView(
        viewModel: UsersTableViewVM(
            roomDataManager: RoomDataManager.shared, .isSettleMoney))
    
    /// 아래 방향 이미지 (5명 이상일 때 맨 밑으로 내리는 버튼)
    private var arrowDownImg: UIImageView = {
        let img = UIImageView(image: UIImage.arrow_down)
            img.tintColor = .deep_Blue
        return img
    }()
    
    /// 탑뷰 하단 인디케이터
    private var topViewIndicator: UIView = UIView.configureView(
        color: UIColor.black)
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.backgroundColor = UIColor.deep_Blue
        self.topViewIndicator.setRoundedCorners(.all, withCornerRadius: 3)
    }
    
    private func configureAutoLayout() {
        self.addSubview(self.usersTableView)
        self.addSubview(self.arrowDownImg)
        self.addSubview(self.topViewIndicator)
        
        // 탑뷰 스택뷰
        self.usersTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
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
    
    
    
    
    
    // MARK: - 액션
    /// 유저 테이블의 리로드
    func userDataReload(at indexpaths: [String : [IndexPath]]) {
        self.usersTableView.userDataReload(at: indexpaths)
    }
}
