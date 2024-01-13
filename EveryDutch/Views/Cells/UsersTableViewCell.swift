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
    private var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    private var userName: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    private var priceLbl: CustomLabel = CustomLabel(
        backgroundColor: .medium_Blue,
        topBottomInset: 4,
        leftInset: 10,
        rightInset: 10)
    
    
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .check_Square_Img,
        imageSize: 13)
    


    // chevronRight
    private lazy var whiteView: UIView = UIView.configureView(
        color: UIColor.white)
    
    private lazy var leftStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.profileImg,
                           self.userName],
        axis: .horizontal,
        spacing: 8,
        alignment: .fill,
        distribution: .fill)
    
    
    private lazy var rightStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.priceLbl],
        axis: .horizontal,
        spacing: 17,
        alignment: .center,
        distribution: .equalCentering)
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: UsersTableViewCellVM?
    
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        self.configureAutoLayout()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.priceLbl.text = ""
        self.userName.text = ""
        self.profileImg.image = nil
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
        
        self.priceLbl.clipsToBounds = true
        self.priceLbl.layer.cornerRadius = 10
    }
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.leftStackView)
        
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    // MARK: - 뷰모델을 통한 셀 설정
    func configureCell(with viewModel: UsersTableViewCellVM?) {
        // 뷰모델 저장
        self.viewModel = viewModel
        // viewModel을 사용하여 셀의 뷰를 업데이트.
        guard let viewModel = viewModel else { return }
        self.userName.text = viewModel.userName
        self.priceLbl.text = viewModel.price
        self.profileImg.image = viewModel.profileImg
        // 오른쪽 버튼이 필요한지 확인
        if !viewModel.rightBtnIsHidden {
            // 필요시 -> 오른쪽 버튼 설정
            self.configureRightBtn(viewModel)
        }
        // 공통 설정
        // 스택뷰를 contentView 위에 올릴지 말지 결정
        self.configureStackView(viewModel.addSubViewOnContentView)
        // 클로져를 사용할지 말지 설정
        self.configureClosure(viewModel.customTableEnum)
        

    }
}
    







    

// MARK: - 상황에 따른 뷰 설정

extension UsersTableViewCell {

    // MARK: - Enum에 따른 설정
    private func configureClosure(_ customTableEnum: CustomTableEnum) {
        switch customTableEnum {
        case .isReceiptWrite:
            // MARK: - isReceiptWrite 삭제
            break
        case .isRoomSetting:
            // 클로져 설정
            self.isRoomSettingClosure()
            break
        case .isReceiptScreen:
            // MARK: - isReceiptScreen 삭제
            // 클로져 설정
            self.isReceiptScreenClosure()
            break
        case .isPeopleSelection:
            self.configureWhiteView()
            break
        case .isSearch:
            break
        case .isSettleMoney, .isSettle:
            break
        }
    }
    
    // MARK: - 스택뷰 설정
    private func configureStackView(_ onContentView: Bool) {
        if onContentView {
            self.contentView.addSubview(self.rightStackView)
            self.configureAction()
            self.rightBtn.isUserInteractionEnabled = true
        } else {
            self.addSubview(self.rightStackView)
            self.rightBtn.isUserInteractionEnabled = false
        }
        
        self.rightStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(22)
        }
    }
    
    // MARK: - 오른쪽 버튼 설정
    private func configureRightBtn(_ viewModel: UsersTableViewCellVM) {
        self.rightStackView.addArrangedSubview(self.rightBtn)
        self.rightBtn.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }

        self.rightBtn.setImage(viewModel.rightBtnImg, for: .normal)
        self.rightBtn.tintColor = viewModel.rightBtnTintColor
    }
    
    
    // MARK: - 흰색 뷰 설정
    private func configureWhiteView() {
        self.insertSubview(self.whiteView, at: 1)
        self.whiteView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.rightBtn)
            make.width.height.equalTo(27)
        }
        self.whiteView.clipsToBounds = true
        self.whiteView.layer.cornerRadius = 27 / 2
        self.rightBtn.tintColor = UIColor.deep_Blue
        
        self.priceLbl.isHidden = true
    }
}










extension UsersTableViewCell {
    // MARK: - 클로져 설정
    private func isRoomSettingClosure() {
        
    }
    
    func isReceiptWriteClosure() {
    }
    
    private func isReceiptScreenClosure() {
        // 뷰모델의 클로져 할당
        self.viewModel?.onButtonSelectionChanged = { [weak self] image in
            self?.rightBtn.setImage(image, for: .normal)
        }
    }
}










extension UsersTableViewCell {
    // MARK: - 액션 설정
    private func configureAction() {
        self.rightBtn.addTarget(self, action: #selector(self.rightBtnTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - 버튼 액션 설정
    @objc func rightBtnTapped() {
        self.viewModel?.rightBtnTapped()
    }

}
