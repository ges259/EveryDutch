//
//  SettlementDetailsTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class SettlementDetailsTableView: UIView {
    
    // MARK: - 레이아웃
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)
    
    private var secondBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.firstBtn,
                           self.secondBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    lazy var topViewTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementDetailsTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        return view
    }()
    private lazy var topLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 15),
        textAlignment: .center)
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.topViewTableView],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
//    weak var delegate:
    private var viewModel: SettlementDetailsVM?
    
    
    // MARK: - 라이프사이클
    init(viewModel: SettlementDetailsVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.btnChangedClosure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SettlementDetailsTableView {
    
    // MARK: - 기본 설정
    private func configureUI() {
        guard let viewModel = self.viewModel else { return }
        
        if let lblText = viewModel.topLblText {
            self.topLbl.text = lblText
        }
        else if let btnTextArray = viewModel.btnTextArray {
            self.firstBtn.setTitle(btnTextArray[0], for: .normal)
            self.secondBtn.setTitle(btnTextArray[1], for: .normal)
        }
        
        self.topLbl.backgroundColor = self.viewModel?.topLblBackgroundColor
        self.configureEnum(viewModel.customTableEnum)
    }
    private func configureEnum(_ customTableEnum: CustomTableEnum) {
        switch customTableEnum {
        case .isReceiptWrite:
            self.isReceiptWrite()
            self.configureSegmentCtrl(bottomCorner: false)
            break
        case .isSettleMoney:
            self.isTopView()
            self.configureSegmentCtrl()
            break
        case .isRoomSetting:
            self.isRoomSetting()
            self.configureSegmentCtrl()
            break
        case .isReceiptScreen:
            self.isReceiptScreen()
            self.configureLbl()
            break
        case .isPeopleSelection, .isSearch:
            self.isSelectPerson()
            self.configureLbl()
            break
        case .isSettle:
            self.isNothing()
            self.configureLbl()
            break
        }
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.totalStackView)
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func configureAction() {
        // 세그먼트 컨트롤 - 액션
        self.firstBtn.addTarget(self, action: #selector(self.firstBtnTapped), for: .touchUpInside)
        self.secondBtn.addTarget(self, action: #selector(self.secondBtnTapped), for: .touchUpInside)
    }
    
    
    
    
    

    
    private func isTopView() {
    }
    private func isReceiptWrite() {
    }
    private func isRoomSetting() {
    }
    private func isReceiptScreen() {
    }
    private func isSelectPerson() {
    }
    private func isNothing() {
    }
}







    
    
    
// MARK: - 상황에 따른 화면 설정

extension SettlementDetailsTableView {
    
    // MARK: - 상단 레이블 설정
    private func configureLbl() {
        self.totalStackView.insertArrangedSubview(self.topLbl, at: 0)
        
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        self.topLbl.clipsToBounds = true
        self.topLbl.layer.cornerRadius = 10
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 10
    }
    
    // MARK: - 상단 버튼 설정
    private func configureSegmentCtrl(bottomCorner: Bool = true) {
        if bottomCorner { self.setSegmentCtrlCorner() }
        self.configureAction()
        
        self.totalStackView.insertArrangedSubview(self.btnStackView, at: 0)
        self.totalStackView.setCustomSpacing(0, after: self.btnStackView)
        self.btnStackView.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        
        self.firstBtn.layer.maskedCorners = [.layerMinXMinYCorner]
        self.secondBtn.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        self.firstBtn.layer.cornerRadius = 10
        self.secondBtn.layer.cornerRadius = 10
    }
    // MARK: - 상단 버튼 모서리 설정
    private func setSegmentCtrlCorner() {
        // 모서리 설정 (상단)
        self.topViewTableView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 10
    }
    // MARK: - 상단 버튼 액션
    @objc private func firstBtnTapped() {
        self.viewModel?.isFirstBtnTapped = true
    }
    @objc private func secondBtnTapped() {
        self.viewModel?.isFirstBtnTapped = false
    }
    // MARK: - 상단 버튼 클로저
    private func btnChangedClosure() {
        self.viewModel?.segmentBtnClosure = { colorArray in
            self.firstBtn.backgroundColor = colorArray[0]
            self.secondBtn.backgroundColor = colorArray[1]
        }
    }
}










// MARK: - 테이블뷰 델리게이트
extension SettlementDetailsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - 테이블뷰 데이터 소스
extension SettlementDetailsTableView: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
//        return 30
//        return 9
//        return 16
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.topViewTableView.dequeueReusableCell(
            withIdentifier: Identifier.topViewTableViewCell,
            for: indexPath) as! SettlementDetailsTableViewCell
        
        let cellViewModel = self.viewModel?.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel)
        return cell
    }
}
