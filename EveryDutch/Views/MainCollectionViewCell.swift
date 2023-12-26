//
//  MainCollectionViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit

// MARK: - MainCollectionViewCell

final class MainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 레이아웃
    private lazy var titleLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 28))
    
    private lazy var timeLbl: UILabel = UILabel.configureLbl(
        textColor: UIColor.gray,
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    // MARK: - 프로퍼티
    weak var viewModel: CollectionViewCellVM?
    

    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureAutoLayout()
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - 화면 설정

extension MainCollectionViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.medium_Blue
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.titleLbl)
        self.addSubview(self.timeLbl)
        
        self.titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        self.timeLbl.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(10)
            make.leading.equalTo(self.titleLbl.snp.leading)
        }
    }
}



// MARK: - 데이터 설정
extension MainCollectionViewCell {

    func configureCell(with viewModel: CollectionViewCellVM?) {
        // 뷰모델 저장
        self.viewModel = viewModel
        
        // viewModel을 사용하여 셀의 뷰를 업데이트.
        if let viewModel = viewModel {
            self.titleLbl.text = viewModel.title
            self.timeLbl.text = viewModel.time_String
        }
    }
}

