//
//  SettingVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit
import Photos
/*
 successDataClosure
 데이터 성공 후, 뒤로가기만 구현한 상태.
 -> Rooms인 경우 방 추가 (MainVC에)
 -> User인 경우 아무것도 안함
 
 Decoration이 저장이 안 됨
 */
final class EditScreenVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
            scrollView.delegate = self
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private var contentView: UIView = UIView()
    /// 카드 이미지뷰
    private var cardImgView: CardImageView = CardImageView()
    /// 테이블뷰
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.register(
            CardDataCell.self,
            forCellReuseIdentifier: Identifier.cardDataCell)
        view.register(
            CardDecorationCell.self,
            forCellReuseIdentifier: Identifier.cardDecorationCell)
        
        view.sectionHeaderTopPadding = 12
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    /// 하단 버튼
    private var bottomBtn: BottomButton = BottomButton(
        title: "완료")
    /// 이미지 피커
    private lazy var imagePickerView: ImageCropView = {
        let view = ImageCropView()
        view.delegate = self
        return view
    }()
    /// 이미지 피커의 높이를  조절
    private var imagePickrHeight: Constraint!
    
    
    private let customColorPicker: CustomColorPicker = CustomColorPicker()
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ProfileEditVMProtocol
    private var coordinator: ProfileEditVCCoordProtocol
    /// CardScreenCoordinator로 전달 됨
    weak var delegate: EditScreenDelegate?
    /// 카드 이미지뷰의 높이
    private lazy var cardHeight: CGFloat = {
        return (self.view.frame.width - 20) * 1.8 / 3
    }()
    /// 열린 상태의 이미지 피커의 높이
    private lazy var openImagePickerHeight: CGFloat = {
        return self.view.frame.height - (self.view.safeAreaInsets.top + self.cardHeight + 14)
    }()
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
    }
    init(viewModel: ProfileEditVMProtocol,
         coordinator: ProfileEditVCCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension EditScreenVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        self.imagePickerView.addShadow(shadowType: .top)
        
        self.imagePickerView.setRoundedCorners(.top, withCornerRadius: 12)
        
        // 하단 버튼 설정
        self.bottomBtn.setTitle(self.viewModel.getBottomBtnTitle, for: .normal)
        // 네비게이션 타이틀 설정
        self.navigationItem.title = self.viewModel.getNavTitle
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.cardImgView)
        self.contentView.addSubview(self.tableView)
        self.view.addSubview(self.bottomBtn)
        self.view.addSubview(self.imagePickerView)
        self.view.addSubview(self.customColorPicker)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(self.cardHeight)
        }
        // 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.cardImgView.snp.bottom)
            make.leading.trailing.equalTo(self.cardImgView)
            make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight - 10)
        }
        // 바텀뷰
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
        // 이미지 피커 뷰
        self.imagePickerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            self.imagePickrHeight = make.height.equalTo(0).constraint
        }
        // 컬러 피커 뷰
        self.customColorPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
    }
    
    func configureBackBtn(isMakeMode: Bool) {
        if isMakeMode {
            self.navigationItem.hidesBackButton = true
            return
        }
        
        // 버튼 생성
        let backButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        self.viewModel.successDataClosure = { @MainActor [weak self] in
            print("\(#function) --- successDataClosure")
            self?.coordinator.didFinish()
        }
        
        self.viewModel.updateDataClosure = { @MainActor [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.makeDataClosure = { @MainActor [weak self] userData in
            self?.coordinator.makeProviderData(with: userData)
        }
        
        self.viewModel.errorClosure = { [weak self] errorType in
            self?.errorType(errorType)
        }
        
        self.viewModel.decorationDataClosure = { [weak self] deco in
            self?.cardImgView.originalDecorationData = deco
        }
    }
}











// MARK: - 액션 메서드

extension EditScreenVC {
    
    // MARK: - 뒤로가기 버튼
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    
    // MARK: - 하단 버튼
    @objc private func bottomBtnTapped() {
        self.view.endEditing(true)
        self.viewModel.validation()
    }
    
    // MARK: - 에러 설정
    @MainActor
    private func errorType(_ errorType: ErrorEnum) {
        switch errorType {
            
        default: break
        }
    }
}










// MARK: - 스크롤뷰 델리게이트
extension EditScreenVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}










// MARK: - 테이블뷰 델리게이트

extension EditScreenVC: UITableViewDelegate {
    
    // MARK: - 셀의 높이
    /// 셀의 높이를 설정합니다.
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 60
    }
    
    // MARK: - 헤더뷰 설정
    /// 헤더 뷰를 구성합니다.
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int)
    -> UIView? {
        let title = self.viewModel.getHeaderTitle(
            section: section)
        return TableHeaderView(
            title: title,
            tableHeaderEnum: .profileVC)
    }
    
    // MARK: - 헤더 높이
    /// 헤더의 높이를 설정합니다.
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
    -> CGFloat {
        return 65
    }
}










// MARK: - 테이블뷰 데이터소스

extension EditScreenVC: UITableViewDataSource {
    
    // MARK: - 섹션 수
    // 테이블 뷰의 섹션 수를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getNumOfSection
    }
    
    // MARK: - 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.getNumOfCell(section: section)
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        return indexPath.section == 0
        ? self.configureDataCell(indexPath: indexPath)
        : self.configureDecorationCell(indexPath: indexPath)
    }
    
    // MARK: - [데이터 셀]
    private func configureDataCell(
        indexPath: IndexPath)
    -> CardDataCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.cardDataCell,
            for: indexPath) as! CardDataCell
        
        // 첫 번째 셀이라면, 오른쪽 상단 모서리 설정
        let isFirst = indexPath.row == 0
        let isLast = self.viewModel.getLastCell(indexPath: indexPath)
        
        // 셀의 타입 가져오기
        let type = self.viewModel.cellTypes(indexPath: indexPath)
        // 셀의 텍스트 및 모서리 설정
        cell.setDetailLbl(type: type,
                          isFirst: isFirst,
                          isLast: isLast)
        cell.delegate = self
        return cell
    }
    
    // MARK: - [데코 셀]
    private func configureDecorationCell(
        indexPath: IndexPath)
    -> CardDecorationCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.cardDecorationCell,
            for: indexPath) as! CardDecorationCell
        let isLast = self.viewModel.getLastCell(indexPath: indexPath)
        // 셀의 타입 가져오기
        let type = self.viewModel.cellTypes(indexPath: indexPath)
        // 셀의 텍스트 설정
        cell.setDetailLbl(type: type, isLast: isLast)
        
        return cell
    }
    
    
    
    
    
    // MARK: - didSelectRowAt
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        print(#function)
        // 현재 선택된 셀의 [타입 및 IndexPath] 저장
        self.viewModel.saveCurrentIndex(indexPath: indexPath)
        
        // 섹션마다(타입 별로) 다른 역할
        switch self.viewModel.getCurrentType() {
            // 데코 섹션
        case let decorationType as DecorationCellType:
            self.selectedDecorationTypeCell(type: decorationType)
        default: break
        }
    }
    
    // MARK: - [데코 섹션]
    private func selectedDecorationTypeCell(type: DecorationCellType) {
        switch type {
        case .blurEffect:
            self.blurEffectChanged()
            break
        case .titleColor, .pointColor:
            self.coordinator.colorPickerScreen()
            break
        case .background:
            // 이미지 권한 확인 -> 문제 없으면, 이미지 피커로 이동
            self.requestPhotoLibraryAccess()
            break
        }
    }
}
    









// MARK: - 셀 관련 델리게이트

extension EditScreenVC: CardDataCellDelegate,
                        ColorPickerDelegate,
                        ImagePickerDelegate {
    
    func textData(cell: CardDataCell, type: EditCellType, text: String) {
        print(#function)
        // 선택된 셀의 IndexPath 저장
        let row = self.saveTextFieldsIndexPath(cell: cell)
        // 변경된 텍스트 데이터 저장
        self.viewModel.saveChangedData(data: text)
        // 카드 텍스트 변경
        self.cardImgView.updateDataCellText(indexPath: row, text: text)
    }
    private func saveTextFieldsIndexPath(cell: CardDataCell) -> Int {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.viewModel.saveCurrentIndex(indexPath: indexPath)
            return indexPath.row
        }
        return -1
    }
    
    
    // MARK: - 이미지 변경
    func imageSelect(image: UIImage?) {
        // 이미지 띄우기
        self.setupImagePicker(isOpen: true, image: image)
    }
    
    // MARK: - 색상 변경
    func decorationCellChange(_ data: UIColor) {
        
    }
}
    
    
    
    
    
    
    
    
    

// MARK: - 셀 업데이트 분기처리

extension EditScreenVC {
    
    // MARK: - 블러 효과 변경
    private func blurEffectChanged() {
        // 추후 변경 예정
        let booleanData: Bool = false
        
        self.updatedDecorationCellUI(data: booleanData) { cell in
            cell.blurEffectIsHidden(booleanData)
        }
    }
    
    // MARK: - 이미지
    private func updateImage(image: UIImage) {
        self.updatedDecorationCellUI(data: image) { cell in
            cell.imgIsChanged(image: image)
        }
    }
    
    // MARK: - 색상
    func updateColor(color: UIColor) {
        self.updatedDecorationCellUI(data: color) { cell in
            cell.colorIsChanged(color: color)
        }
    }
    
    
    
    
    
    // MARK: - [셀 UI 업데이트]
    // 변경된 데이터 처리 및 셀 업데이트
    func updatedDecorationCellUI(
        data: Any?,
        updateAction: @escaping (CardDecorationCell) -> Void)
    {
        // 변경된 데이터와 타입을 저장하고 반환받기
        guard let changedData = self.viewModel.getDecorationCellTypeTuple() else {
            self.customAlert(alertEnum: .userAlreadyExists) { _ in return }
            return
        }
        guard let data = data else {
            self.customAlert(alertEnum: .roomDataError) { _ in return }
            return
        }
        
        // 변경된 데이터 저장
        self.viewModel.saveChangedData(data: data)
        // 셀 업데이트
        self.updateDecorationCell(at: changedData.indexPath, withUpdateAction: updateAction)
        // 카드 이미지 뷰를 업데이트
        self.cardImgView.updateCardView(type: changedData.type, data: data, onFailure: self.errorType(_:))
    }
    
    // MARK: - 셀 업데이트
    // 클로저를 통해 셀을 변경한다.
    private func updateDecorationCell(
        at indexPath: IndexPath,
        withUpdateAction action: (CardDecorationCell) -> Void)
    {
        if let cell = tableView.cellForRow(at: indexPath) as? CardDecorationCell {
            action(cell)
        }
    }
}




















// MARK: - [권한 설정]

extension EditScreenVC {
    
    // MARK: - 이미지 권한 확인
    func requestPhotoLibraryAccess() {
        // iOS 14 이상에서 사용할 수 있는 authorizationStatus(for:) 메서드 사용
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
            // .authorized == [전체 접근 허용]
                // 사용자가 앱에 자신의 사진 라이브러리 전체에 대한 접근을 허용한 경우
            // .limited == [접근 제한]
                // 사용자가 앱에 사진 라이브러리의 전체 접근을 허용하지 않고,
                // 대신 특정 사진이나 앨범에 대한 접근만을 허용한 경우
        case .authorized, .limited:
            print("Authorized or Limited Access")
            // 권한이 이미 있음
            self.coordinator.imagePickerScreen()
            
            // .notDetermined == [접근 제한되지 않음]
                // 사용자가 아직 앱에 대한 사진 라이브러리 접근 권한을 결정하지 않은 상태
        case .notDetermined:
            print("notDetermined")
            self.photoAccess()
            
            // .denied == [접근 거부]
                // 사용자가 앱의 사진 라이브러리 접근을 명시적으로 거부한 경우
                // 사용자가 권한을 거부함. 설정으로 유도할 수 있음
            // .restricted == [접근 불가]
                // 부모의 제어 설정이나 기업 정책 등 외부 요인으로 인해 앱이 사진 라이브러리에 접근할 수 없는 경우
        case .denied, .restricted:
            print("denied or restricted")
            self.showPhotoLibraryAccessDeniedAlert()
            
            
        @unknown default: break
        }
    }
    
    // MARK: - 권한 요청
    private func photoAccess() {
        // 권한 요청
        PHPhotoLibrary.requestAuthorization { newStatus in
            if newStatus == .authorized {
                DispatchQueue.main.async {
                    self.coordinator.imagePickerScreen()
                }
            }
        }
    }
    
    // MARK: - 설정으로 이동
    private func showPhotoLibraryAccessDeniedAlert() {
        self.customAlert(alertEnum: .photoAccess) { _ in
            // 사용자를 앱의 설정 화면으로 이동
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl)
            else { return }
            UIApplication.shared.open(settingsUrl, options: [:])
        }
    }
}













// MARK: - 하단 이미지 피커 뷰
extension EditScreenVC {
    
    // EditScreenVC에서 requestPhotoLibraryAccess함수 -> 코디네이터 -> 이미지 선택창 이동
    // 이미지 선택 시 -> coordinator에서 openImagePicker함수 호출
    // 저장 선택 시 -> 화면 내려감
    
    func setupImagePicker(
        isOpen: Bool,
        image: UIImage? = nil)
    {
        // 현재 상태 저장
        self.viewModel.imagePickerIsOpen = isOpen
        // 이미지가 있다면, 바꾸기
        if let image = image { self.changeImagePicker(with: image) }
        // 스크롤뷰 설정 변경
        self.disableScrollAndMoveToTop(isOpen: isOpen)
        // 이미지 피커의 높이 재설정
        self.changeImagePickerHeight(isOpen: isOpen)
    }
    
    private func changeImagePickerHeight(isOpen: Bool) {
        // 높이 설정
        let height = self.viewModel.imagePickerIsOpen
        ? self.openImagePickerHeight // 열려있는 상태
        : 0 // 닫혀있는 상태
        // 이미지 피커의 높이 업데이트
        self.imagePickrHeight.update(offset: height)
        // 애니메이션을 통한 화면 바꾸기
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func changeImagePicker(with image: UIImage) {
        self.imagePickerView.setupImage(image: image)
    }
    func disableScrollAndMoveToTop(isOpen: Bool) {
        if isOpen {
            // 스크롤뷰의 contentOffset을 (0,0)으로 설정하여 맨 위로 이동
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        // 스크롤 기능을 비활성화
        self.scrollView.isScrollEnabled = !isOpen
    }
}










// MARK: - 이미지 크롭 델리게이트
extension EditScreenVC: ImageCropDelegate{
    func cancel() {
        guard let currentType = self.viewModel.getDecorationCellTypeTuple() else { return }
        // 원래 이미지로 변경
        self.cardImgView.resetCardData(type: currentType.type)
        // 이미지 피커 안 보이게 하기
        self.setupImagePicker(isOpen: false)
    }
    
    func done(with image: UIImage) {
        // 이미지 바꾸기 및 바뀐 이미지 저장
        self.updateImage(image: image)
        // 이미지 피커 안 보이게 하기2
        self.setupImagePicker(isOpen: false)
    }
    func changedLocation(image: UIImage) {
        guard let currentType = self.viewModel.getDecorationCellTypeTuple() else { return }
        self.cardImgView.updateCardView(type: currentType.type, data: image, onFailure: self.errorType(_:))
    }
}














final class CustomColorPicker: UIView {
    
    // MARK: - 레이아웃
    private let colorPicker = ChromaColorPicker()
    private let brightnessSlider = ChromaBrightnessSlider()
    private lazy var homeHandle: ChromaColorHandle = {
        let handle = ChromaColorHandle(color: .blue)
            handle.accessoryView = imageView
            handle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
        return handle
    }()
    
    private let imageView: UIImageView = {
        let img = UIImageView(image: UIImage.Exit_Img)
            img.contentMode = .scaleAspectFit
            img.tintColor = .white
        return img
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupView()
        self.setupAutoLayaout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func setupView() {
        self.backgroundColor = .medium_Blue
//        self.colorPicker.dele
    }
    
    // MARK: - 오토레이아웃 설정
    private func setupAutoLayaout() {
        self.addSubview(self.colorPicker)
        self.addSubview(self.brightnessSlider)
        self.colorPicker.connect(self.brightnessSlider) // or `brightnessSlider.connect(to: colorPicker)`
        self.colorPicker.addHandle(self.homeHandle)
        
        
        self.colorPicker.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        self.brightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(self.colorPicker.snp.bottom).offset(50)
            make.leading.trailing.equalTo(self.colorPicker)
            make.height.equalTo(50)
        }
    }
}
