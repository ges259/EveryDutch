//
//  MainVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit
import FirebaseAuth

final class MainVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 콜렉션뷰
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        // 컬렉션뷰 레지스터 설정
        view.register(
            MainCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.mainCollectionViewCell)
        
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var noDataView: NoDataView = NoDataView(
        type: .mainScreen,
        cornerRadius: 12)
    // 메뉴 버튼
    private lazy var menuBtn: UIButton = UIButton.btnWithImg(
        image: .menu_Img,
        imageSize: 25,
        tintColor: UIColor.white,
        backgroundColor: UIColor.deep_Blue,
        cornerRadius: self.BigButtonSize())
    // 플로팅 버튼 레이아웃
    private lazy var floatingButtonView: FloatingButtonView = {
        let view = FloatingButtonView()
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: MainVMProtocol
    private var coordinator: MainCoordProtocol
    
    /// 컬렉션뷰 셀의 넓이
    private lazy var width = self.view.frame.width - 20
    
    /// 현재 화면이 Visible인지를 판단하는 변수
    /// viewWillAppear와 viewWillDisappear에서 적용
    private var isViewVisible = false
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNotification()
        self.configureAutoLayout()
        self.configureUI()
        self.configureClosure()
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
        self.floatingButtonView.floatingViewIsHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isViewVisible = true
        self.processPendingUpdates()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isViewVisible = false
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(#function)-----\(self)")
    }
}










// MARK: - 화면 설정
extension MainVC {
    /// UI 설정
    private func configureUI() {
        // 배경 설정
        self.view.backgroundColor = UIColor.base_Blue
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.collectionView,
         self.floatingButtonView,
         self.menuBtn,
         self.noDataView].forEach { view in
            self.view.addSubview(view)
        }
        

        // 콜렉션뷰
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 플로팅 버튼
        self.floatingButtonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 방이 없을 때 나타나는 뷰
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.collectionView)
            make.height.equalTo(self.cardHeight())
        }
        // 메뉴버튼
        self.menuBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.width.equalTo(self.BigButtonSize())
        }
    }
    private func configureAction() {
        self.menuBtn.addTarget(
            self,
            action: #selector(self.menuBtnTapped),
            for: .touchUpInside)
    }
    /// 클로저 설정
    private func configureClosure() {
        // 아이템의 셀을 누르면, 정산방으로 이동
        self.viewModel.moveToSettleMoneyRoomClosure = { [weak self] in
            guard let self = self else { return }
            self.coordinator.settlementMoneyRoomScreen()
        }
    }
    /// 노티피케이션 설정
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleRoomDataChanged(notification:)),
            name: .roomDataChanged,
            object: nil)
    }
}










// MARK: - 액션 설정
extension MainVC {
    /// [메뉴 버튼] 및 [배경] 액션
    @objc private func menuBtnTapped() {
        print(#function)
        self.floatingButtonView.toggleFloatingShow()
    }
}










// MARK: - viewWillAppear 업데이트
extension MainVC {
    @objc private func handleRoomDataChanged(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              !userInfo.isEmpty 
        else { return }
        
        // userInfo를 viewModel에 전달
        self.viewModel.userDataChanged(userInfo)
        // isViewVisible이 true인 경우 processPendingUpdates 호출
        if self.isViewVisible { self.processPendingUpdates() }
    }
    // 모든 대기 중인 변경 사항을 적용
    private func processPendingUpdates() {
        // 뷰모델에 저장된 인덱스 패스 가져오기
        let pendingIndexPaths = self.viewModel.getPendingUpdates()
        // 비어있다면, 아무 행동도 하지 않음
        guard pendingIndexPaths.count != 0 else { return }
        
        if pendingIndexPaths.count == 1 {
            // 콜레션뷰 리로드
            pendingIndexPaths.forEach { (key: String, value: [IndexPath]) in
                self.updateIndexPath(key: key, indexPaths: value)
            }
        } else {
            self.collectionView.reloadData()
        }
        // 변경 사항 초기화
        self.viewModel.resetPendingUpdates()
    }
    
    private func updateIndexPath(key: String, indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            switch key {
            case DataChangeType.updated.notificationName:
                self.collectionView.reloadItems(at: indexPaths)
                break
            case DataChangeType.initialLoad.notificationName:
                self.collectionView.reloadData()
                break
            case DataChangeType.added.notificationName:
                self.collectionView.insertItems(at: indexPaths)
                break
            case DataChangeType.removed.notificationName:
                self.collectionView.deleteItems(at: indexPaths)
                break
            default:
                self.collectionView.reloadData()
                print("\(self) ----- \(#function) ----- Error")
                break
            }
        }
    }
}










// MARK: - 컬렉션뷰_델리게이트
extension MainVC: UICollectionViewDelegateFlowLayout {
    /// 아이템을 눌렀을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath
    ) {
        self.viewModel.itemTapped(index: indexPath.row)
    }
    
    /// 아이템의 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: self.width,
                      height: self.cardHeight())
    }
    
    // 아이템 간 상하 간격 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
}

// MARK: - 컬렉션뷰_데이터소스
extension MainVC: UICollectionViewDataSource {
    /// 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewModel.numberOfRooms
    }
    
    /// 아이템 설정
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.mainCollectionViewCell,
            for: indexPath) as! MainCollectionViewCell
        
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath.item)
        
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
}










// MARK: - 플로팅버튼 델리게이트
extension MainVC: FloatingButtonViewDelegate {
    func goToRoomEditScreen() {
        self.coordinator.roomEditScreen()
    }
    
    func goToProfileScreen() {
        self.coordinator.profileScreen()
    }
    
    func floatingViewIsHidden(
        isHidden: Bool,
        btnTransform: CGAffineTransform,
        btnimage: UIImage?
    ) {
        UIView.animate(withDuration: 0.3) {
            // 플로팅 뷰를 보이게 / 숨기게 하기
            self.floatingButtonView.isHidden = isHidden
            /// 메뉴버튼 이미지 돌리기 (Spin)
            self.menuBtn.transform = btnTransform
            /// 이미지 바꾸기
            self.menuBtn.setImage(btnimage, for: .normal)
        }
    }
}
