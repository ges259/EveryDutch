//
//  PeopleSelectionPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class PeopleSelectionPanVC: UIViewController {
    // MARK: - 레이아웃
    private var peopleTableView: UsersTableView = UsersTableView(
        viewModel: UsersTableViewVM(.isPeopleSelection))
    
    private lazy var searchMethodTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(SearchMethodTableViewCell.self, forCellReuseIdentifier: Identifier.searchMethodTableViewCell)
        return view
    }()
    
    
    private var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: UIColor.normal_white)
    
    
    
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.peopleTableView,
                           self.bottomBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator?
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.didFinish()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension PeopleSelectionPanVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        
        self.bottomBtn.clipsToBounds = true
        self.bottomBtn.layer.cornerRadius = 10
        
        self.searchMethodTableView.clipsToBounds = true
        self.searchMethodTableView.layer.cornerRadius = 10
        
        
        // MARK: - Fix
        self.bottomBtn.setTitle("선택 완료", for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {

        self.view.addSubview(self.stackView)
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        // MARK: - Fix
        self.stackView.insertArrangedSubview(self.searchMethodTableView, at: 1)
        self.searchMethodTableView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.bottomBtn.addTarget(self, action: #selector(self.bottomBtnTapped), for: .touchUpInside)
    }
    @objc private func bottomBtnTapped() {
        self.view.layoutIfNeeded()
    }
}



// MARK: - 검색 방법 텍스트필드 델리게이트
extension PeopleSelectionPanVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

// MARK: - 검색 방법 텍스트필드 데이터소스
extension PeopleSelectionPanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.searchMethodTableViewCell,
            for: indexPath) as! SearchMethodTableViewCell
        
        return cell
    }
}




// MARK: - 팬모달 설정
extension PeopleSelectionPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(self.stackView.frame.height + 10 + 15)
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


// MARK: - Fix
// 테이블뷰가 0일 때 -> 아래로 스크롤하면 dismiss
