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
    func setDetailLbl(cellTuple: EditCellTypeTuple?,
                      isLast: Bool) {
        guard let cellTuple = cellTuple else { return }
        self.cellStv.userNameLbl.text = cellTuple.type.getCellTitle
        
        // 마지막 셀 모서리 설정
        if isLast { self.setRoundedCorners(.bottom, withCornerRadius: 12) }
        
        
        //
        guard let type = cellTuple.type as? DecorationCellType,
                let detailString = cellTuple.detail else { return }
        let color = UIColor(hex: detailString,
                            defaultColor: .clear)
        switch type {
        case .background:
            if detailString.checkIsHexColor() {
                self.colorIsChanged(color: color)
            } else {
                self.cellStv.rightView.setImage(from: detailString)
            }
            
        case .titleColor, .nameColor:
            self.colorIsChanged(color: color)
            break
        case .blurEffect:
            break
        }
    }
    
    /// 오른쪽 뷰의 색을 바꾸는 메서드
    func colorIsChanged(color: UIColor? = .clear) {
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


extension String {
    func checkIsHexColor() -> Bool {
        // 입력 문자열에서 'background:'를 제거하고 트리밍
        let trimmedInput = self.replacingOccurrences(of: "background:", with: "").trimmingCharacters(in: .whitespaces)
        
        // 색상 코드인지 확인
        if trimmedInput.hasPrefix("#") && trimmedInput.count == 7 {
            return true
        }
        // URL인지 확인
        else if let url = URL(string: trimmedInput), url.scheme == "http" || url.scheme == "https" {
            return false
        }
        
        // 위의 두 경우에 해당하지 않으면 false
        return false
    }
}
