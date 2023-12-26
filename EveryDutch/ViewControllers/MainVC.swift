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
        return view
    }()
    /// 플러스 버튼
    private lazy var plusBtn: UIButton = UIButton.btnWithImg(
        imageEnum: .plus,
        imageSize: 25,
        tintColor: UIColor.white,
        backgroundColor: UIColor.deep_Blue)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: MainVMProtocol?
    
    private var coordinator: MainCoordinating?
    
    
    
    /// 컬렉션뷰 셀의 넓이
    private lazy var width = (self.view.frame.width - 10 * 2)
    /// 컬렉션뷰 셀의 높이
    private lazy var heigh = self.width * 0.63
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAutoLayout()
        self.configureUI()
        self.configureAction()
    }
    init(viewModel: MainVMProtocol,
         coordinator: MainCoordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 화면 설정

extension MainVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 설정
        self.view.backgroundColor = UIColor.base_Blue
        // 네비게이션 타이틀 설정
        self.navigationItem.title = "더치더치"
        
        // 컬렉션뷰 레지스터 설정
        self.collectionView.register(
            MainCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.mainCollectionViewCell)
        // 코너레디어스 설정
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 70 / 2
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.plusBtn)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        self.plusBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.width.equalTo(70)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.plusBtn.addTarget(self, action: #selector(self.plusBtnTapped), for: .touchUpInside)
    }
}



// MARK: - 액션 설정

extension MainVC {
    @objc private func plusBtnTapped() {
        self.coordinator?.plusBtnScreen()
    }
    
    
}



// MARK: - 컬렉션뷰_델리게이트
extension MainVC: UICollectionViewDelegateFlowLayout {
    /// 아이템을 눌렀을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print(#function)
        self.coordinator?.settlementRoomScreen()
    }
    
    /// 아이템의 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.width,
                      height: self.heigh)
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
        return 6
    }
    
    /// 아이템 설정
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.mainCollectionViewCell,
            for: indexPath) as! MainCollectionViewCell
        
        let cellViewModel = self.viewModel?.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}
