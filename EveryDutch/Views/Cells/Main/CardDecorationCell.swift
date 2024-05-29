//
//  CardDecorationTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit

final class CardDecorationCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var cellStv: CellSelectionUIStv = CellSelectionUIStv(
        stvEnum: .cardDecoration)
    
    
    
    // MARK: - 라이프사이클
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
        // 셀이 재사용 되기 전, UI 초기화
        self.layer.cornerRadius = 0
    }
}










// MARK: - 화면 설정
extension CardDecorationCell {
    /// UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - 데이터 및 UI 업데이트
    /// 데이터 설정
    func setDetailLbl(type: EditCellTypeTuple?,
                      isLast: Bool) {
        guard let data = type else { return }
        self.cellStv.userNameLbl.text = data.type.getCellTitle
        
        // 마지막 셀 모서리 설정
        if isLast { self.setRoundedCorners(.bottom, withCornerRadius: 12) }
    }
    
    /// 오른쪽 뷰의 색을 바꾸는 메서드
    func colorIsChanged(color: UIColor) {
        self.cellStv.rightView.image = nil
        self.cellStv.isTapped(color: color)
    }
    
    /// 오른쪽 뷰의 이미지를 바꾸는 메서드
    func imgIsChanged(image: UIImage?) {
        self.cellStv.rightView.image = image
        self.cellStv.isTapped(color: .clear)
    }
    
    /// 색상 넣기
    func blurEffectIsHidden(_ isHidden: Bool) {
        self.cellStv.isTappedView.isHidden.toggle()
    }
}
