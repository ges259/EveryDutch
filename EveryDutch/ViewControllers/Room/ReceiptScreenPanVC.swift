//
//  ReceiptScreenPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class ReceiptScreenPanVC: UIViewController {
    // MARK: - 레이아웃
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    
    /// 테이블뷰
    private lazy var usersTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        
        view.register(
            ReceiptScreenUsersCell.self,
            forCellReuseIdentifier: Identifier.receiptUserCell)
        
        view.register(
            ReceiptScreenDataCell.self,
            forCellReuseIdentifier: Identifier.receiptDataCell)
        view.backgroundColor = .clear
        view.setRoundedCorners(.all, withCornerRadius: 10)
        
        view.sectionHeaderTopPadding = 0
        
        return view
    }()
    
    private var bottomSaveButton: UIButton = UIButton.btnWithTitle(
        title: "저장",
        font: UIFont.boldSystemFont(ofSize: 14),
        backgroundColor: .normal_white)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.usersTableView,
                           self.bottomSaveButton],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator
    var viewModel: ReceiptScreenPanVMProtocol
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
    }
    init(coordinator: Coordinator,
         viewModel: ReceiptScreenPanVMProtocol) {
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
extension ReceiptScreenPanVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        self.bottomSaveButton.setRoundedCorners(.all, withCornerRadius: 10)
        self.bottomSaveButton.isHidden = true
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.totalStackView)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        self.totalStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        self.bottomSaveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        self.bottomSaveButton.addTarget(
            self,
            action: #selector(self.bottomSaveButtonTapped),
            for: .touchUpInside)
    }
    
    /// 클로저 설정
    private func configureClosure() {
        self.viewModel.paymentDetailCountChanged = { [weak self] isHidden in
            guard let self = self else { return }
            self.bottomSaveButton.isHidden = isHidden
            // PanModal의 높이를 바꿈
            self.panModalAnimate {
                self.panModalSetNeedsLayoutUpdate()
                self.panModalTransition(to: .longForm)
            }
        }
    }
}










// MARK: - 버튼 액션
extension ReceiptScreenPanVC {
    @objc private func bottomSaveButtonTapped() {
        print(#function)
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptScreenPanVC: UITableViewDelegate {
    /// 셀의 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return self.viewModel.getCellHeight(section: indexPath.section)
    }
    
    /// 헤더의 높이를 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 40
    }
    
    /// 헤더 뷰를 구성
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        return self.createHeaderView(for: section)
    }
    
    /// 헤더 만들기
    private func createHeaderView(for section: Int) -> UIView {
        let title: String = self.viewModel.getHeaderTitle(section: section)
        
        let view = UIView.configureView(
            color: .clear)
        
        let lbl = CustomLabel(
            text: title,
            font: UIFont.systemFont(ofSize: 15),
            backgroundColor: UIColor.normal_white,
            textAlignment: .center)
        lbl.setRoundedCorners(.all, withCornerRadius: 10)
        
        
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, 
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        // 코너 둥글기 적용
        let isFirstIndex = indexPath.row == 0
        
        let isLastIndex = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        
        // 섹션 내의 첫 번째 셀인지, 마지막 셀인지, 또는 유일한 셀인지 확인
        if isFirstIndex
            && isLastIndex {
            // 섹션에 셀이 하나뿐인 경우
            cell.setRoundedCorners(.all, withCornerRadius: 10)
            
        } else if isFirstIndex {
            // 섹션의 첫 번째 셀인 경우
            cell.setRoundedCorners(.top, withCornerRadius: 10)
        } else if isLastIndex {
            // 섹션의 마지막 셀인 경우
            cell.setRoundedCorners(.bottom, withCornerRadius: 10)
        }
    }
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath
    ) {
        // '유저 셀'인지 확인
        guard indexPath.section == 1 else { return }
        
        // 자신의 영수증인지 판단
        if self.viewModel.isMyReceipt {
            print("\(#function) ----- 1")
            // 자신의 영수증인 경우
            // 바뀐 데이터 저장
            self.viewModel.changedUserPayback(at: indexPath.row)
            // 셀의 UI를 변경
            self.usersTableView.reloadRows(
                at: [IndexPath(row: indexPath.row, section: 1)],
                with: .automatic
            )
            
        } else {
            // 자신의 영수증이 아닌 경우
            print("\(#function) ----- 2")
        }
    }
}










// MARK: - 테이블뷰 데이터소스
extension ReceiptScreenPanVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getNumOfSection
    }
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        return self.viewModel.getNumOfCell(section: section)
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return indexPath.section == 0
        ? self.makeDataCell(indexPath: indexPath)
        : self.makeUsersCell(indexPath: indexPath)
    }
    
    /// cellForRowAt - [데이터 셀]
    private func makeDataCell(indexPath: IndexPath) -> ReceiptScreenDataCell{
        let cell = self.usersTableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptDataCell,
            for: indexPath) as! ReceiptScreenDataCell
        // 데이터 셀의 데이터(튜플)을 가져옴
        let cellData = self.viewModel.getCellData(index: indexPath.row)
        cell.configure(withReceiptEnum: cellData)
        
        return cell
    }
    
    /// cellForRowAt - [유저 셀]
    private func makeUsersCell(indexPath: IndexPath) -> ReceiptScreenUsersCell {
        let cell = self.usersTableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptUserCell,
            for: indexPath) as! ReceiptScreenUsersCell
        
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.row)
        
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}










// MARK: - 팬모달 설정
extension ReceiptScreenPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(
            self.totalStackView.frame.height
            + 35
        )
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
