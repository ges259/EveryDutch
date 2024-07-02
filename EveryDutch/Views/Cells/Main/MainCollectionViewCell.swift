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
    private var cardImageView: CardImageView = CardImageView()
        
    
    // MARK: - 프로퍼티
    var viewModel: MainCollectionViewCellVMProtocol?
    

    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureAutoLayout()
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cardImageView.prepareForReuseData()
    }
}



// MARK: - 화면 설정
extension MainCollectionViewCell {
    /// UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.medium_Blue
        self.layer.cornerRadius = 10
        self.addShadow(shadowType: .card)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cardImageView)
        self.cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



// MARK: - 데이터 설정
extension MainCollectionViewCell {
    func configureCell(with viewModel: MainCollectionViewCellVMProtocol?) {
        guard let viewModel = viewModel else { return }
        // 뷰모델 저장
        self.viewModel = viewModel
        // viewModel을 사용하여 셀의 뷰를 업데이트
        self.cardImageView.setupRoomData(data: viewModel.getRoom)
        self.cardImageView.setupDecorationData(data: viewModel.getDecoration)
    }
}

