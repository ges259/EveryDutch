//
//  SettingVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit

final class SettingVC: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var baseView: UIView = UIView.configureView(
        color: UIColor.medium_Blue)
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel.configureLbl(
            font: UIFont.systemFont(ofSize: 18.5))
        
            lbl.textAlignment = .center
            lbl.backgroundColor = .normal_white
        return lbl
    }()
        
    private lazy var imgBtn: UIButton = UIButton.btnWithImg(
        imageEnum: .plus,
        imageSize: 40,
        tintColor: .darkGray,
        backgroundColor: .normal_white)
    
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField()
        tf.backgroundColor = .normal_white
        tf.insetX = 16
        tf.attributedPlaceholder = NSAttributedString.configure(
            text: "안녕하세요",
            color: .lightGray,
            font: UIFont.systemFont(ofSize: 14.5))
        
        return tf
    }()
    
    private lazy var numOfCharLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13))
    
    private lazy var nextBtn: UIButton = UIButton.btnWithTitle(
        titleColor: UIColor.gray,
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: .normal_white)
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: SettingProtocol?
    private weak var coordinator: PlusBtnCoordinating?
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SettingVM,
         coordinator: PlusBtnCoordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SettingVC {
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        [self.titleLbl,
         self.textField,
         self.nextBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 12
        }
        self.baseView.clipsToBounds = true
        self.baseView.layer.cornerRadius = 20
        self.imgBtn.clipsToBounds = true
        self.imgBtn.layer.cornerRadius = 120 / 2
        
        // MARK: - Fix
        self.titleLbl.text = "타이틀"
        self.nextBtn.setTitle("버튼", for: .normal)
        self.numOfCharLbl.text = "0 / 8"
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
        self.view.addSubview(self.baseView)
        
        [self.titleLbl,
         self.imgBtn,
         self.textField,
         self.numOfCharLbl,
         self.nextBtn].forEach { view in
             self.baseView.addSubview(view)
        }
        
        self.baseView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-27)
            make.bottom.equalTo(self.nextBtn.snp.bottom).offset(20)
        }
        self.titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(48)
        }
        self.imgBtn.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        self.textField.snp.makeConstraints { make in
            make.top.equalTo(self.imgBtn.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        self.numOfCharLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.textField)
            make.trailing.equalTo(self.textField.snp.trailing).offset(-16)
        }
        self.nextBtn.snp.makeConstraints { make in
            make.top.equalTo(self.textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(self.textField)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}
