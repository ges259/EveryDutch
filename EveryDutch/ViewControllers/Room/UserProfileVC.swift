//
//  UserProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 6/10/24.
//

import UIKit
import SnapKit
import PanModal

final class UserProfileVC: UIViewController {
    // MARK: - 레이아웃
    /// 카드 이미지 뷰
    private lazy var cardImgView: CardImageView = {
        let view = CardImageView()
        let userDecoTuple = self.viewModel.getUserDecoTuple
            view.setupUserData(data: userDecoTuple.user)
            view.setupDecorationData(data: userDecoTuple.deco)
        return view
    }()
    
    
    private var tabBarView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    /// 원형 버튼들
    private lazy var searchBtn: UIButton = UIButton.btnWithImg(
        image: .search_Img,
        title: "검색",
        cornerRadius: self.btnSize)
    private lazy var reportBtn: UIButton = UIButton.btnWithImg(
        image: .exclamationmark_Img,
        title: "신고",
        cornerRadius: self.btnSize)
    private lazy var kickBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        title: "강퇴",
        cornerRadius: self.btnSize)
    
    /// 버튼으로 구성된 가로로 된 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.searchBtn,
                           self.reportBtn],
        axis: .horizontal,
        spacing: 16,
        alignment: .fill,
        distribution: .equalSpacing)
    
    
    /// 정산내역 테이블뷰
    private lazy var receiptTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        view.backgroundColor = .clear
        view.bounces = true
        view.isHidden = true
        view.backgroundColor = .red
        view.transform = CGAffineTransform(rotationAngle: .pi)
        return view
    }()
    
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.receiptTableView,
                           self.tabBarView],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    
    
    let viewModel: UserProfileVMProtocol
    let coordinator: UserProfileCoordinator
    private let btnSize: CGFloat = 60
    
    /// 테이블뷰의 셀의 높이
    private lazy var cellHeight: CGFloat = self.receiptTableView.frame.width / 7 * 2
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: UserProfileVMProtocol,
         coordinator: UserProfileCoordinator)
    {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dataChange(data: User) {
        self.cardImgView.setupUserData(data: data)
    }
}





// MARK: - 화면 설정
extension UserProfileVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        
        if self.viewModel.isRoomManager {
            self.btnStackView.addArrangedSubview(self.kickBtn)
        }
        self.tabBarView.setRoundedCorners(.top, withCornerRadius: 20)
        self.receiptTableView.setRoundedCorners(.all, withCornerRadius: 12)
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalStackView)
        self.tabBarView.addSubview(self.btnStackView)
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-UIDevice.current.panModalSafeArea)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight())
        }
        
        // 버튼 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(self.viewModel.btnStvInsets)
        }
        
        // 하단 버튼의 높이와 너비를 동일하게 설정
         [self.searchBtn, self.reportBtn, self.kickBtn].forEach { btn in
             btn.snp.makeConstraints { make in
                 make.size.equalTo(self.btnSize)
             }
         }
    }
    
    /// 액션 설정
    private func configureAction() {
        self.searchBtn.addTarget(
            self, 
            action: #selector(self.searchBtnTapped),
            for: .touchUpInside)
        self.reportBtn.addTarget(
            self,
            action: #selector(self.reportBtnTapped),
            for: .touchUpInside)
        self.kickBtn.addTarget(
            self,
            action: #selector(self.kickBtnTapped),
            for: .touchUpInside)
    }
}




// MARK: - 액션 설정
extension UserProfileVC {
    @objc private func searchBtnTapped() {
        self.receiptTableView.isHidden = false
        self.panModalTransition(to: .longForm)
    }
    @objc private func reportBtnTapped() {
        
    }
    @objc private func kickBtnTapped() {
        
    }
}





// MARK: - 팬모달 설정
extension UserProfileVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(self.cardHeight() + self.btnSize + 17 + 10 + UIDevice.current.panModalSafeArea)
    }
    
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
//        return .contentHeight(self.view.frame.height)
        return .maxHeightWithTopInset(0)
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










// MARK: - 테이블뷰 델리게이트
extension UserProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath.row)
        
        // MARK: - Fix
        // '영수증 화면'으로 화면 이동
//        self.coordinator.ReceiptScreen(receipt: receipt)
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        // 마지막 셀이 보여질 때쯤
        if indexPath.row == self.viewModel.numberOfReceipt - 1 {
            self.viewModel.loadMoreUserReceipt()
        }
    }
}

// MARK: - 테이블뷰 데이터 소스
extension UserProfileVC: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfReceipt
    }
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.receiptTableView.dequeueReusableCell(
            withIdentifier: Identifier.settlementTableViewCell,
            for: indexPath) as! SettlementTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellViewModel)
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        
        if indexPath.row == 0{
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .normal_white
        }
        return cell
    }
}
