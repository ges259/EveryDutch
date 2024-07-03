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
    /// 스택뷰
    private var tableCellStv: TableCellStackView = TableCellStackView()
    
    /// 오른쪽 이미지
    private lazy var rightImg: UIImageView = {
        let img = UIImageView()
            img.tintColor = .black
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UsersTableViewCellVMProtocol?
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.tableCellStv.profileImg.image = UIImage.person_Fill_Img
    }
}










// MARK: - 화면 설정
extension UsersTableViewCell {
    /// UI 설정
    private func configureUI() {
        self.backgroundColor = .normal_white
        self.selectionStyle = .none
        self.separatorInset = .zero
    }
    
    /// 뷰모델을 통한 셀 설정
    func configureCell(with viewModel: UsersTableViewCellVMProtocol?,
                       firstBtnTapped: Bool) {
        // 뷰모델 저장
        self.viewModel = viewModel
        
        // viewModel을 사용하여 셀의 뷰를 업데이트
        guard let viewModel = viewModel else { return }
        
        // 오토레이아웃 설정
        self.configureStvAutoLayout(viewModel: viewModel)
        // 버튼 설정
        if viewModel.isButtonExist { self.configureLeftImage() }
        // 스택뷰의 데이터 설정
        self.setStackViewData(with: viewModel,
                              firstBtnTapped: firstBtnTapped)
    }
    
    /// 스택뷰 오토레이아웃
    private func configureStvAutoLayout(viewModel: UsersTableViewCellVMProtocol) {
        self.addSubview(self.tableCellStv)
        self.tableCellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(viewModel.imgLeftAnchor)
            make.centerY.equalToSuperview()
        }
    }
    
    /// 이미지 오토레이아웃
    private func configureLeftImage() {
        self.tableCellStv.addArrangedSubview(self.rightImg)
        
        self.rightImg.image = self.viewModel?.rightBtnImg
        
        self.rightImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
    }
    
    /// 스택뷰 데이터 설정
    private func setStackViewData(with viewModel: UsersTableViewCellVMProtocol,
                                  firstBtnTapped: Bool) {
        // 스택뷰 설정
        self.tableCellStv.userNameLbl.text = viewModel.getUserName
        
        self.tableCellStv.priceLbl.text = firstBtnTapped
        ? "\(viewModel.cumulativeAmount)"
        : "\(viewModel.paybackPrice)"
        
        
        if let imageUrl = viewModel.imageUrl {
            self.tableCellStv.profileImg.setImage(from: imageUrl)
        }
    }
}
