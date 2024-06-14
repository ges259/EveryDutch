//
//  CheckReceiptPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class CheckReceiptPanVC: UIViewController {
    // MARK: - 레이아웃
    /// 상단 레이블 ("아직 체크되지 않은 부분이 있어요")
    private var topLbl: CustomLabel = CustomLabel(
        text: "아직 체크되지 않은 부분이 있어요",
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    /// 빠진 사항이 적힌 테이블
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        
        view.register(
            CheckReceiptPanCell.self,
            forCellReuseIdentifier: Identifier.checkReceiptPanCell)
        return view
    }()
    
    /// 하단 버튼
    private var bottomBtn: UIButton = UIButton.btnWithTitle(
        title: "확인",
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: UIColor.normal_white)
    
    /// 토탈 스택뷰
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topLbl,
                           self.tableView,
                           self.bottomBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: CheckReceiptPanVMProtocol
    private var coordinator: Coordinator
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: CheckReceiptPanVMProtocol,
         coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator.didFinish()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정
extension CheckReceiptPanVC {
    /// UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.deep_Blue
        // 모서리 설정
        [self.topLbl,
         self.tableView,
         self.bottomBtn].forEach { view in
            view.setRoundedCorners(.all, withCornerRadius: 10)
        }
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalStackView)
        
        // 전체 스택뷰 (상단 레이블, 레이블 스택뷰, 하단 버튼)
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        // 상단 레이블
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        // 하단 버튼
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    // 액션 설정
    private func configureAction() {
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
    }
    
    
    
    
    
    // MARK: - 액션 설정
    @objc private func bottomBtnTapped() {
        self.dismiss(animated: true)
    }
}










// MARK: - 팬모달 설정
extension CheckReceiptPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(self.totalStackView.frame.height + 10 + 15)
    }
    /// 화면 밖 - 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
    var cornerRadius: CGFloat {
        return 23
    }
}





// MARK: - [테이블뷰] 델리게이트
extension CheckReceiptPanVC: UITableViewDelegate {
    
    // MARK: - 셀의 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 45
    }
}





// MARK: - [테이블뷰] 데이터소스
extension CheckReceiptPanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        self.viewModel.getNilValueArray
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.checkReceiptPanCell,
            for: indexPath) as! CheckReceiptPanCell
        
        cell.label.text = self.viewModel.getLabelText(index: indexPath.row)
        
        return cell
    }
}
