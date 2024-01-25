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
    
    private var noDataView: NoDataView = {
        let view = NoDataView()
        view.isHidden = true
        return view
    }()
    
    
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
    
    /// 플로팅 버튼의 배열
    private lazy var floatingArray: [UIButton] = [self.makeRoomScreenBtn,
                                                  self.profileScreenBtn]
    
//    private var isFloatingShow: Bool = false
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAutoLayout()
        self.configureUI()
        self.configureAction()
        self.configureGesture()
        self.configureClosure()
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
        
        if self.viewModel.getIsFloatingStatus {
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
        
        // 플로팅 버튼 배열 설정
            // 모서리 설정
            // 화면 밖으로 설정
        self.floatingArray.forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 65 / 2
            btn.alpha = 0
            // 버튼을 화면 밖으로 위치시키기
            btn.transform = CGAffineTransform(translationX: 0, y: 80)
        }
        
        // 코너레디어스 설정
        self.menuBtn.clipsToBounds = true
        self.menuBtn.layer.cornerRadius = 80 / 2
        
        self.noDataView.clipsToBounds = true
        self.noDataView.layer.cornerRadius = 12
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.collectionView,
         self.floatingDimView,
         self.floatingStackView,
         self.menuBtn,
         self.noDataView].forEach { view in
            self.view.addSubview(view)
        }
        // 플로팅 버튼 백그라운드 화면
        self.floatingDimView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        // 콜렉션뷰
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 메뉴버튼
        self.menuBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.width.equalTo(80)
        }
        // 방이 없을 때 나타나는 뷰
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.collectionView)
            make.height.equalTo(self.cardHeight)
        }
        // 플로팅 버튼 스택뷰
        self.floatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.menuBtn.snp.top).offset(-7)
            make.centerX.equalTo(self.menuBtn)
        }
        // 플로팅 버튼 넓이 및 높이 설정
        self.makeRoomScreenBtn.snp.makeConstraints { make in
            make.width.height.equalTo(65)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.menuBtn.addTarget(
            self, 
            action: #selector(self.menuBtnTapped),
            for: .touchUpInside)
        self.profileScreenBtn.addTarget(
            self, 
            action: #selector(self.profileScreenBtnTapped),
            for: .touchUpInside)
        self.makeRoomScreenBtn.addTarget(
            self, 
            action: #selector(self.makeRoomScreenBtnTapped),
            for: .touchUpInside)
    }
    
    // MARK: - 제스처 설정
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.floatingViewTappd))
        self.floatingDimView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        self.viewModel.collectionVeiwReloadClousure = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        self.viewModel.onFloatingShowChanged = { [weak self] floatingType in
            self?.updateFloatingUI(type: floatingType)
        }
    }
}



// MARK: - 플로팅 버튼 액션 설정
extension MainVC {
    @objc private func menuBtnTapped() {
        self.viewModel.toggleFloatingShow()
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
    
    private func updateFloatingUI(type: floatingType) {
        // 메뉴버튼 이미지 돌리기
        self.menuBtnSpin()
        // 플로팅 버튼 배경 설정
        self.configureFloatingDimView(type: type)
        // 플로팅 버튼 액션
        self.configureFloatingButtons(type: type)
    }
}







// MARK: - 플로팅 Spin 액션

extension MainVC {
    
    // MARK: - 메뉴 버튼 회전
    /// 메뉴버튼 이미지 돌리기 (Spin)
    private func menuBtnSpin() {
        // 돌리기(Spin)
        UIView.animate(withDuration: 0.3) {
            self.menuBtn.transform = self.viewModel.getSpinRotation
        }
    }
    
    // MARK: - 배경 (숨김/보임) 처리
    private func configureFloatingDimView(type: floatingType) {
        let image = self.viewModel.getMenuBtnImg
        self.floatingDimView.isHidden = !type.show
        
        // 회색 배경 설정 및 메뉴 버튼 이미지 설정
        UIView.animate(withDuration: 0.3) {
            self.menuBtn.setImage(image, for: .normal)
            self.floatingDimView.alpha = type.alpha
        }
    }
    
    // MARK: - 버튼 (숨김/보임) 처리
    private func configureFloatingButtons(type: floatingType) {
        // 버튼 애니메이션
        let buttons = type.show
        ? self.floatingArray
        : self.floatingArray.reversed()
        
        for (index, button) in buttons.enumerated() {
            // 각 버튼마다 0.1초의 지연
            let delay = Double(index) * 0.1
            // 각 버튼을 순차적으로 작업
            UIView.animate(withDuration: 0.15, delay: delay) {
                button.transform = self.viewModel.getBtnTransform
                button.alpha = type.alpha
            }
        }
    }
}










// MARK: - 컬렉션뷰_델리게이트
extension MainVC: UICollectionViewDelegateFlowLayout {
    /// 아이템을 눌렀을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
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


extension MainVC: CardScreenDelegate {
    func logout() {
        self.coordinator.selectALgoinMethodScreen()
    }
}
