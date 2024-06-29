//
//  ProfileTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/1/24.
//

import UIKit
import SnapKit

final class ProfileCell: UITableViewCell {
    
    // MARK: - 레이아웃
    var detailLbl: CustomLabel = CustomLabel(
        leftInset: 20)
    
    var infoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 20)
    /// 오른쪽 이미지
    private lazy var rightImg: UIImageView = {
        let img = UIImageView()
            img.tintColor = .black
            img.backgroundColor = UIColor.white
            img.contentMode = .scaleAspectFit
        img.setRoundedCorners(.all, withCornerRadius: self.imageSize / 2)
        return img
    }()
    
    
    
    // MARK: - 프로퍼티
    private var imageSize: CGFloat = 35
    
    
    
    // MARK: - 라이프 사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.infoLbl.text = nil
        self.rightImg.image = nil
    }
}










// MARK: - 화면 설정
extension ProfileCell {
    /// UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
        self.accessoryType = .disclosureIndicator // 오른쪽 화살표 추가
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.detailLbl)
        self.detailLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    
    /// 이미지 오토레이아웃
    private func configureLeftImage() {
        self.addSubview(self.rightImg)
        self.rightImg.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25 - self.imageSize / 2)
            make.width.height.equalTo(self.imageSize)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureInfoLabel() {
        self.addSubview(self.infoLbl)
        self.infoLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    func configureCell(_ cellData: ProfileTypeCell) {
        self.detailLbl.text = cellData.type.cellTitle
        let trimmedInput = cellData.detail
        
        if cellData.isText {
            self.configureInfoLabel()
            self.infoLbl.text = trimmedInput
        } else {
            self.configureLeftImage()
            self.rightImg.setImage(from: trimmedInput)
        }
    }
    
    
    
    
    func configureRightImage(with image: UIImage?) {
        print("\(#function) ----- 1")
        self.rightImg.image = image
    }
}
