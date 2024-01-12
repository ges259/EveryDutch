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
    
    
    
    private var topLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var whiteVeiw: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    // 스택뷰
    private var memoStackView: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .memo,
        addInfoLbl: true)
    private var dateStackView: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .date,
        addInfoLbl: true)
    private var timeStackView: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .time,
        addInfoLbl: true)
    private var priceStackView: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .price,
        addInfoLbl: true)
    private var payerStackVeiw: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .payer,
        addInfoLbl: true)
    private var paymentMethodStackView: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: .payment_Method,
        addInfoLbl: true)
    
    
    /// 정산내역 레이블
    private var usersLabel: CustomLabel = CustomLabel(
        text: "정산 내역",
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    /// 테이블뷰
    private lazy var usersTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        
        view.register(
            ReceiptScreenTableViewCell.self,
            forCellReuseIdentifier: Identifier.receiptScreenTableViewCell)
        
        return view
    }()
    
    // 하단 버튼
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topLbl,
                           self.whiteVeiw,
                           self.usersLabel,
                           self.usersTableView],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var receiptStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.memoStackView,
                           self.dateStackView,
                           self.timeStackView,
                           self.priceStackView,
                           self.payerStackVeiw,
                           self.paymentMethodStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator
    var viewModel: ReceiptScreenPanVM
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureViewWithViewModel()
        self.configureAction()
        self.configureClosure()
    }
    init(coordinator: Coordinator,
         viewModel: ReceiptScreenPanVM) {
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
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        self.usersTableView.backgroundColor = .normal_white
        
        [self.topLbl,
         self.whiteVeiw,
         self.usersLabel,
         self.usersTableView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        

    }
    
    private func configureViewWithViewModel() {
        let receipt = self.viewModel.receipt
        
        self.memoStackView.receiptInfoLbl.text = receipt.context
        self.dateStackView.receiptInfoLbl.text = receipt.date
        self.timeStackView.receiptInfoLbl.text = receipt.time
        self.priceStackView.receiptInfoLbl.text = "\(receipt.price)"
        self.payerStackVeiw.receiptInfoLbl.text = receipt.payer
        self.paymentMethodStackView.receiptInfoLbl.text = "\(receipt.paymentMethod)"
        
        // MARK: - Fix
        self.topLbl.text = "영수증"
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.totalStackView)
        self.whiteVeiw.addSubview(self.receiptStackView)
        
        
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
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        self.receiptStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.memoStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.usersLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    // MARK: - 클로저 설정
    private func configureClosure() {
        // 데이터를 처음 가져왔을 때
//        self.usersTableView.viewModel.makeCellVM(users: self.viewModel.roomUsers)
//        self.usersTableView.reloadData()
//        self.view.layoutIfNeeded()
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptScreenPanVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 50
    }
}
// MARK: - 테이블뷰 데이터소스
extension ReceiptScreenPanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) 
    -> Int {
        return self.viewModel.currentNumOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.receiptScreenTableViewCell,
            for: indexPath) as! ReceiptScreenTableViewCell
        
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
        return .contentHeight(self.totalStackView.frame.height + 10 + 15 + 8)
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
