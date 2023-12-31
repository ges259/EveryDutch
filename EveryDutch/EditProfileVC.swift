////
////  EditProfileVC.swift
////  EveryDutch
////
////  Created by 계은성 on 2023/12/30.
////
//
//import UIKit
//import SnapKit
//
//final class EditProfileVC: UIViewController {
//    
//    // MARK: - 레이아웃
//    private lazy var baseView: UIView = UIView.configureView(
//        color: UIColor.medium_Blue)
//
//    private lazy var titleLbl: UILabel = {
//        let lbl = UILabel.configureLbl(
//            font: UIFont.systemFont(ofSize: 18.5))
//
//            lbl.textAlignment = .center
//            lbl.backgroundColor = .normal_white
//        return lbl
//    }()
//
//    private lazy var imgBtn: UIButton = UIButton.btnWithImg(
//        imageEnum: .plus,
//        imageSize: 40,
//        tintColor: .darkGray,
//        backgroundColor: .normal_white)
//
//    private lazy var textField: InsetTextField = InsetTextField(
//        backgroundColor: .normal_white,
//        placeholerColor: .lightGray,
//        placeholderText: "안녕하세요.")
//
//
//    private lazy var numOfCharLbl: UILabel = UILabel.configureLbl(
//        font: UIFont.systemFont(ofSize: 13))
//
//    private lazy var nextBtn: UIButton = UIButton.btnWithTitle(
//        titleColor: UIColor.gray,
//        font: UIFont.boldSystemFont(ofSize: 16),
//        backgroundColor: .normal_white)
//    private lazy var previousBtn: UIButton = UIButton.btnWithTitle(
//        titleColor: UIColor.gray,
//        font: UIFont.boldSystemFont(ofSize: 16),
//        backgroundColor: .normal_white)
//
//    private lazy var btnStackView: UIStackView = UIStackView.configureStackView(
//        arrangedSubviews: [self.nextBtn],
//        axis: .horizontal,
//        spacing: 4,
//        alignment: .fill,
//        distribution: .fill)
//    
//    
//    // MARK: - 프로퍼티
//    
//    
//    
//    // MARK: - 라이프사이클
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.configureUI()
//        self.configureAutoLayout()
//        self.configureAction()
//    }
//}
//
//// MARK: - 화면 설정
//
//extension EditProfileVC {
//    
//    // MARK: - UI 설정
//    private func configureUI() {
//        [self.titleLbl,
//         self.nextBtn,
//         self.previousBtn].forEach { view in
//            view.clipsToBounds = true
//            view.layer.cornerRadius = 12
//        }
//        self.baseView.clipsToBounds = true
//        self.baseView.layer.cornerRadius = 20
//        self.imgBtn.clipsToBounds = true
//        self.imgBtn.layer.cornerRadius = 120 / 2
//
//        // MARK: - Fix
//        self.titleLbl.text = "타이틀"
//        self.previousBtn.setTitle("이전", for: .normal)
//        self.nextBtn.setTitle("버튼", for: .normal)
//        self.numOfCharLbl.text = "0 / 8"
//        self.btnStackView.insertArrangedSubview(self.previousBtn, at: 0)
//    }
//    
//    // MARK: - 오토레이아웃 설정
//    private func configureAutoLayout() {
//        self.view.addSubview(self.baseView)
//
//        [self.titleLbl,
//         self.imgBtn,
//         self.textField,
//         self.numOfCharLbl,
//         self.btnStackView].forEach { view in
//             self.baseView.addSubview(view)
//        }
//
//        self.baseView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
//            make.leading.equalToSuperview().offset(27)
//            make.trailing.equalToSuperview().offset(-27)
//            make.bottom.equalTo(self.nextBtn.snp.bottom).offset(20)
//        }
//        self.titleLbl.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(220)
//            make.height.equalTo(48)
//        }
//        self.imgBtn.snp.makeConstraints { make in
//            make.top.equalTo(self.titleLbl.snp.bottom).offset(15)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(120)
//        }
//        self.textField.snp.makeConstraints { make in
//            make.top.equalTo(self.imgBtn.snp.bottom).offset(15)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.height.equalTo(40)
//        }
//        self.numOfCharLbl.snp.makeConstraints { make in
//            make.centerY.equalTo(self.textField)
//            make.trailing.equalTo(self.textField.snp.trailing).offset(-16)
//        }
//        self.btnStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.textField.snp.bottom).offset(7)
//            make.leading.trailing.equalTo(self.textField)
//            make.height.equalTo(45)
//        }
//
//        self.previousBtn.snp.makeConstraints { make in
//            make.width.equalTo(58)
//        }
//    }
//    
//    // MARK: - 액션 설정
//    private func configureAction() {
//        
//    }
//}
