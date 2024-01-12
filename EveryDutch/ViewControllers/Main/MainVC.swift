//
//  MainVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit

// MARK: - MainViewController

final class MainVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 콜렉션뷰
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        // 컬렉션뷰 레지스터 설정
        view.register(
            MainCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.mainCollectionViewCell)
        return view
    }()
    /// 플러스 버튼
    private lazy var menuBtn: UIButton = UIButton.btnWithImg(
        image: .menu_Img,
        imageSize: 25,
        tintColor: UIColor.white,
        backgroundColor: UIColor.deep_Blue)
    
    private var noDataView: NoDataView = NoDataView()
    
    
    // 플로팅 버튼 레이아웃
    private var floatingDimView: UIView = {
        let view = UIView.configureView(
            color: .backgroundGray)
        view.isHidden = true
        
        return view
    }()
    
    private var makeRoomScreenBtn: UIButton = UIButton.btnWithImg(
        image: .plus_Img,
        imageSize: 20,
        tintColor: UIColor.deep_Blue,
        backgroundColor: UIColor.normal_white)
    private var profileScreenBtn: UIButton = UIButton.btnWithImg(
        image: .person_Fill_Img,
        imageSize: 20,
        tintColor: UIColor.deep_Blue,
        backgroundColor: UIColor.normal_white)
    
    private lazy var floatingStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.profileScreenBtn,
                           self.makeRoomScreenBtn],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: MainVMProtocol
    
    private var coordinator: MainCoordProtocol
    
    /// 컬렉션뷰 셀의 넓이
    private lazy var width = self.view.frame.width - 20
    /// 컬렉션뷰 셀의 높이
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    private lazy var floatingArray: [UIButton] = [self.makeRoomScreenBtn,
                                                  self.profileScreenBtn]
    
    private var isFloatingShow: Bool = false
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAutoLayout()
        self.configureUI()
        self.configureAction()
    }
    init(viewModel: MainVMProtocol,
         coordinator: MainCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        if self.isFloatingShow {
            self.menuBtnTapped()
        }
    }
}


// MARK: - 화면 설정

extension MainVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 설정
        self.view.backgroundColor = UIColor.base_Blue
        
        
        self.floatingArray.forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 65 / 2
            btn.alpha = 0
        }

        // 버튼을 화면 밖으로 위치시킵니다.
        self.floatingArray.forEach { btn in
            btn.transform = CGAffineTransform(translationX: 0, y: 80)
        }
        
        
        // 코너레디어스 설정
        self.menuBtn.clipsToBounds = true
        self.menuBtn.layer.cornerRadius = 80 / 2
        
        self.noDataView.clipsToBounds = true
        self.noDataView.layer.cornerRadius = 12
        
        // MARK: - Fix
        self.noDataView.isHidden = true
        
        self.viewModel.collectionVeiwReloadClousure = {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.floatingDimView)
        self.view.addSubview(self.floatingStackView)
        self.view.addSubview(self.menuBtn)
        self.view.addSubview(self.noDataView)
        
        
        
        
        

        
        self.floatingDimView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.menuBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.width.equalTo(80)
        }
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.collectionView)
            make.height.equalTo(self.cardHeight)
        }
        
        self.floatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.menuBtn.snp.top).offset(-7)
            make.centerX.equalTo(self.menuBtn)
            
        }
        self.makeRoomScreenBtn.snp.makeConstraints { make in
            make.width.height.equalTo(65)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.menuBtn.addTarget(self, action: #selector(self.menuBtnTapped), for: .touchUpInside)
        self.profileScreenBtn.addTarget(self, action: #selector(self.profileScreenBtnTapped), for: .touchUpInside)
        self.makeRoomScreenBtn.addTarget(self, action: #selector(self.makeRoomScreenBtnTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.floatingViewTappd))
        self.floatingDimView.addGestureRecognizer(tapGesture)
    }
    
}



// MARK: - 플로팅 버튼 액션 설정
extension MainVC {
    @objc private func menuBtnTapped() {
        // 플로팅 버튼 액션
        self.isFloatingShow
        ? self.floatingBtnhidden()
        : self.floatingBtnShow()
        // 상태 업데이트
        self.isFloatingShow.toggle()
        // 메뉴버튼 이미지 돌리기
        self.menuBtnSpin()
    }
    @objc private func profileScreenBtnTapped() {
        self.coordinator.cardScreen(.profile)
    }
    
    @objc private func makeRoomScreenBtnTapped() {
        self.coordinator.cardScreen(.makeRoom)
    }
    
    @objc private func floatingViewTappd() {
        self.menuBtnTapped()
    }
}







// MARK: - 플로팅 Spin 액션
extension MainVC {
    /// 메뉴버튼 이미지 돌리기 (Spin)
    private func menuBtnSpin() {
        // 얼마나 돌릴지 (Spin)
        let roatation = self.isFloatingShow
        ? CGAffineTransform(rotationAngle: .pi - (.pi / 4))
        : CGAffineTransform.identity
        // 돌리기(Spin)
        UIView.animate(withDuration: 0.3) {
            self.menuBtn.transform = roatation
        }
    }
    
    /// 플로팅 버튼 보이게 하는 메서드
    private func floatingBtnShow() {
        // 회색 배경 보이도록 설정
        self.floatingDimView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            // MARK: - Fix
            self.menuBtn.setImage(UIImage.plus_Img, for: .normal)
            // 서서히 보이도록 설정
            self.floatingDimView.alpha = 1
        }
        // 버튼 순서대로 올리기
        for (index, button) in self.floatingArray.enumerated() {
            let delay = Double(index) * 0.1 // 각 버튼마다 0.1초의 지연
            UIView.animate(withDuration: 0.15, delay: delay) {
                button.transform = .identity
                button.alpha = 1
            }
        }
    }
    /// 플로팅 버튼 숨기는 메서드
    private func floatingBtnhidden() {
        
        UIView.animate(withDuration: 0.3) {
            // MARK: - Fix
            self.menuBtn.setImage(UIImage.menu_Img, for: .normal)
            // 서서히 안 보이도록 설정
            self.floatingDimView.alpha = 0
        } completion: { _ in
            self.floatingDimView.isHidden = true
        }
        // 버튼 순서대로 내리기
        for (index, button) in self.floatingArray.reversed().enumerated() {
            let delay = Double(index) * 0.1 // 각 버튼마다 0.1초의 지연
            
            UIView.animate(withDuration: 0.15, delay: delay) {
                button.alpha = 0
                button.transform = CGAffineTransform(translationX: 0, y: 80)
            }
        }
    }
}










// MARK: - 컬렉션뷰_델리게이트
extension MainVC: UICollectionViewDelegateFlowLayout {
    /// 아이템을 눌렀을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let room = self.viewModel.rooms[indexPath.row]
        self.coordinator.settlementMoneyRoomScreen(room: room)
    }
    
    /// 아이템의 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.width,
                      height: self.cardHeight)
    }
    
    // 아이템 간 상하 간격 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {
        return 12
    }
}

// MARK: - 컬렉션뷰_데이터소스
extension MainVC: UICollectionViewDataSource {
    /// 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int)
    -> Int {
        return self.viewModel.numberOfItems
    }
    
    /// 아이템 설정
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.mainCollectionViewCell,
            for: indexPath) as! MainCollectionViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}


extension MainVC: MultiPurposeScreenDelegate {
    func logout() {
        self.coordinator.selectALgoinMethodScreen()
    }
}
