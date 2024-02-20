//
//  NoDataView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit

enum NodataViewType {
    case mainScreen
    case versionScreen
    case ReceiptWriteScreen
}


final class NoDataView: UIView {
    
    // MARK: - 레이아웃
    private var noDataImg: UIImageView = UIImageView()
    
    private var noDataText: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.numberOfLines = 2
        return lbl
    }()
    private lazy var stackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.noDataImg,
                           self.noDataText],
        axis: .vertical,
        spacing: 14,
        alignment: .center,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    // MARK: - 라이프사이클
    init(type: NodataViewType) {
        super.init(frame: .zero)
        
        self.configureUIWithType(type: type)
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension NoDataView {
    
    // MARK: - UI 설정
    private func configureUIWithType(type: NodataViewType) {
        switch type {
        case .mainScreen:
            self.isHidden = true
            self.noDataImg.image = UIImage.plus_Circle_Img
            self.noDataText.text = "채팅방이 아직 없습니다.\n+ 버튼을 눌러 생성해보세요!"
            self.backgroundColor = UIColor.deep_Blue
            self.noDataImg.tintColor = .normal_white
            
        case .versionScreen:
            self.isHidden = true
            self.noDataImg.image = UIImage.plus_Circle_Img
            self.noDataText.text = "버전 정보가 없습니다.\n+ 정산 버튼을 눌러 버전을 생성해보세요!"
            self.backgroundColor = UIColor.deep_Blue
            self.noDataImg.tintColor = .normal_white
            
        case .ReceiptWriteScreen:
            self.isHidden = false
            self.noDataImg.image = UIImage.plus_Circle_Img
            self.noDataText.text = "채팅방이 아직 없습니다.\n+ 버튼을 눌러 생성해보세요!"
            self.backgroundColor = UIColor.normal_white
            self.noDataImg.tintColor = .deep_Blue
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.noDataImg.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
    }
}
