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
    private lazy var bottomBtn: BottomButton = BottomButton(
        title: self.viewModel.getBottomBtnTitle ?? "완료")
    /// 이미지 피커
    private lazy var customImagePicker: CustomImageCropView = {
        let view = CustomImageCropView()
        view.delegate = self
        return view
    }()
    /// 이미지 피커의 높이를  조절
    private var imagePickrHeight: Constraint!
    
    
    private lazy var customColorPicker: CustomColorPicker = {
        let picker = CustomColorPicker()
        picker.delegate = self
        return picker
    }()
    /// 컬러 피커의 높이를  조절
    private var colorPickrHeight: Constraint!
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ProfileEditVMProtocol
    private var coordinator: EditScreenCoordProtocol
    
    /// 열린 상태의 이미지 피커의 높이
    private lazy var openImagePickerHeight: CGFloat = {
        return self.view.frame.height - (self.view.safeAreaInsets.top + self.cardHeight() + 14)
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
         coordinator: EditScreenCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.viewModel.initializeCellTypes()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정
extension EditScreenVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        // 네비게이션 타이틀 설정
        self.navigationItem.title = self.viewModel.getNavTitle
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.cardImgView)
        self.contentView.addSubview(self.tableView)
        self.view.addSubview(self.bottomBtn)
        self.view.addSubview(self.customImagePicker)
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
            make.height.equalTo(self.cardHeight())
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
        self.customImagePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            self.imagePickrHeight = make.height.equalTo(0).constraint
        }
        // 컬러 피커 뷰
        self.customColorPicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            self.colorPickrHeight = make.height.equalTo(0).constraint
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        self.bottomBtn.addTarget(
            self,
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
    }
    
    /// 클로저 설정
    private func configureClosure() {
        self.viewModel.successDataClosure = { @MainActor [weak self] in
            print("\(#function) --- successDataClosure")
            guard let self = self else { return }
            self.coordinator.didFinish()
        }
        
        self.viewModel.updateDataClosure = { @MainActor [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        self.viewModel.errorClosure = { [weak self] errorType in
            guard let self = self else { return }
            self.errorType(errorType)
        }
        
        self.viewModel.decorationDataClosure = { [weak self] deco in
            guard let self = self else { return }
            self.cardImgView.setupOriginalDecorationData(deco)
        }
    }
    
    /// 왼쪽 상단 뒤로가기 버튼 설정
    /// isMakeMode가 true이 때만 설정 (새로운 유저가 유저 데이터를 추가하는 상황)
    /// isMakeMode가 false
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
}











// MARK: - 액션 메서드
extension EditScreenVC {
    /// 뒤로가기 버튼
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    
    /// 하단 버튼
    @objc private func bottomBtnTapped() {
        self.view.endEditing(true)
        self.viewModel.validation()
    }
    
    /// 에러 설정
    @MainActor
    private func errorType(_ errorType: ErrorEnum) {
        switch errorType {
        case .validationError(let errorString):
            self.coordinator.checkReceiptPanScreen(errorString)
            break
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
    /// 셀의 높이를 설정
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 60
    }
    
    /// 헤더 뷰를 구성
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int)
    -> UIView? {
        let title = self.viewModel.getHeaderTitle(
            section: section)
        return TableHeaderView(
            title: title,
            tableHeaderEnum: .profileVC)
    }
    
    /// 헤더의 높이를 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
    -> CGFloat {
        return 65
    }
}










// MARK: - 테이블뷰 데이터소스
extension EditScreenVC: UITableViewDataSource {
    // 테이블 뷰의 섹션 수를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getNumOfSection
    }
    
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.getNumOfCell(section: section)
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        return indexPath.section == 0
        ? self.configureDataCell(indexPath: indexPath)
        : self.configureDecorationCell(indexPath: indexPath)
    }
    /// cellForRowAt - [데이터 셀] 구성
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
        let cellTuple = self.viewModel.getCellTuple(indexPath: indexPath)
        
        // 셀의 텍스트 및 모서리 설정
        cell.setDetailLbl(cellTuple: cellTuple,
                          isFirst: isFirst,
                          isLast: isLast)
        cell.delegate = self
        return cell
    }
    /// cellForRowAt - [데코 셀] 구성
    private func configureDecorationCell(
        indexPath: IndexPath)
    -> CardDecorationCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.cardDecorationCell,
            for: indexPath) as! CardDecorationCell
        let isLast = self.viewModel.getLastCell(indexPath: indexPath)
        // 셀의 타입 가져오기
        let cellTuple = self.viewModel.getCellTuple(indexPath: indexPath)
        // 셀의 텍스트 설정
        cell.setDetailLbl(cellTuple: cellTuple, isLast: isLast)
        
        return cell
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 텍스트 필드를 수정 주이라면 -> 멈추기
        self.view.endEditing(true)
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
    /// didSelectRowAt - [데코 섹션]
    private func selectedDecorationTypeCell(type: DecorationCellType) {
        switch type {
        case .blurEffect:
            // 카드 이미지 뷰 업데이트
            self.blurEffectChanged()
            self.blurCellSelected()
            break
        case .titleColor, .nameColor:
            self.configureColorPicker(isOpen: true)
            break
        case .background:
            // 이미지 권한 확인 -> 문제 없으면, 이미지 피커로 이동
            self.selectBackground()
            break
        }
    }
    /// didSelectRowAt - .background(배경) 셀 선택 시, 얼럿 창 띄우기
    private func selectBackground() {
        self.customAlert(alertStyle: .actionSheet,
                         alertEnum: .backgroundSelect
        ) { [weak self] index in
            guard let self = self else { return }
            switch index {
            case 0: // 이미지
                self.coordinator.requestPhotoLibraryAccess(delegate: self)
                break
            case 1: // 색상
                self.configureColorPicker(isOpen: true)
                break
            default: break
            }
        }
    }
    /// didSelectRowAt - .blurEffect(블러효과) 셀 선택 시, 카드이미지뷰의 효과 바꾸기
    private func blurCellSelected() {
        self.cardImgView.updateCardView(
            type: .blurEffect,
            data: true,
            onFailure: self.errorType(_:)
        )
    }
}
    









// MARK: - [데이터] 셀 델리게이트
extension EditScreenVC: CardDataCellDelegate {
    /// CardDataCell에서 텍스트 변경 시, 해당 메서드가 호출 됨.
    func textData(cell: CardDataCell, type: EditCellType, text: String) {
        // 선택된 셀의 IndexPath 저장
        // row가져오기 및 옵셔널 바인딩(존재하는지 확인)
        guard let row = self.saveTextFieldsIndexPath(cell),
                row >= 0
        else { return }
        // 변경된 텍스트 데이터 저장
        self.viewModel.saveChangedTextData(data: text)
        // 카드 텍스트 변경
        self.cardImgView.updateDataCellText(index: row, text: text)
    }
    private func saveTextFieldsIndexPath(_ cell: CardDataCell) -> Int? {
        if let indexPath = self.tableView.indexPath(for: cell) {
            self.viewModel.saveCurrentIndex(indexPath: indexPath)
            return indexPath.row
        }
        return nil
    }
}
    
    
    
    
    
    
    
    
    

// MARK: - [데코] 셀 업데이트
extension EditScreenVC {
    /// 변경된 데이터 처리 및 셀 업데이트
    private func updatedDecorationCellUI(
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
        self.viewModel.saveChangedDecorationData(data: data)
        // 셀 업데이트
        if let cell = self.tableView.cellForRow(at: changedData.indexPath) as? CardDecorationCell {
            updateAction(cell)
        }
    }
    /// 블러 효과 변경
    private func blurEffectChanged() {
        // 추후 변경 예정
        let booleanData: Bool = false
        
        self.updatedDecorationCellUI(data: booleanData) { cell in
            cell.blurEffectIsHidden(booleanData)
        }
    }
    /// 이미지
    private func updateImage(image: UIImage) {
        self.updatedDecorationCellUI(data: image) { cell in
            cell.imgIsChanged(image: image)
        }
    }
    /// 색상
    private func updateColor(color: UIColor) {
        self.updatedDecorationCellUI(data: color) { cell in
            cell.colorIsChanged(color: color)
        }
    }
}










// MARK: - 이미지 피커 델리게이트
extension EditScreenVC: ImagePickerDelegate {
    /// CardDecorationCell에서 .blackground셀 선택 -> 앨범으로 화면이동 -> 이미지 선택 -> 해당 함수 호출 됨
    func imageSelected(image: UIImage?) {
        // 이미지 피커 띄우기
        self.configureImagePicker(isOpen: true, with: image)
    }
}










// MARK: - 피커 뷰 open / close
extension EditScreenVC {
    /// [공통] 메인 설정 함수는 필요에 따라 각 설정 메소드를 호출
    private func setPickerState(type: EditScreenPicker,
                                isOpen: Bool,
                                image: UIImage? = nil,
                                color: UIColor? = nil
    ) {
        switch type {
        case .imagePicker:
            self.configureImagePicker(isOpen: isOpen, with: image)
        case .colorPicker:
            self.configureColorPicker(isOpen: isOpen)
        }
    }
    /// [color] 색상 피커 설정
    private func configureColorPicker(isOpen: Bool) {
        self.setPickerMode(for: .colorPicker, isOpen: isOpen)
        self.customColorPicker.updateConstraintsForExpandedState(isExpanded: isOpen)
    }
    /// [image] 이미지 피커 설정
    private func configureImagePicker(isOpen: Bool, with image: UIImage? = nil) {
        // 피커를 여는 상황이라면,
        if isOpen {
            // 이미지 변경
            self.customImagePicker.setupImage(image: image)
        }
        // 피러 모드 설정
        self.setPickerMode(for: .imagePicker, isOpen: isOpen)
    }
    
    /// [공통] picker 타입에 따른 설정
    private func setPickerMode(for picker: EditScreenPicker, isOpen: Bool) {
        // 현재 상태 저장
        self.viewModel.savePickerState(picker: picker, isOpen: isOpen)
        // 스크롤뷰 설정 변경
        self.disableScrollAndMoveToTop(isOpen: isOpen)
        // 피커의 높이 재설정
        self.adjustPickerHeight(for: picker, isOpen: isOpen)
    }
    /// [공통] 화면 상단 고정
    private func disableScrollAndMoveToTop(isOpen: Bool) {
        if isOpen {
            // 스크롤뷰의 contentOffset을 (0,0)으로 설정하여 맨 위로 이동
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        // 스크롤 기능을 비활성화
        self.scrollView.isScrollEnabled = !isOpen
    }
    /// [공통] 이미지 피커 높이 재설정
    private func adjustPickerHeight(for picker: EditScreenPicker, isOpen: Bool) {
        // 높이 설정
        let height = isOpen ? self.openImagePickerHeight : 0
        
        switch picker {
        case .imagePicker:
            // 이미지 피커의 높이 업데이트
            self.imagePickrHeight.update(offset: height)
            
        case .colorPicker:
            // 색상 피커의 높이 업데이트
            self.colorPickrHeight.update(offset: height)
        }
        
        // 애니메이션을 통한 화면 바꾸기
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}










// MARK: - 피커뷰 델리게이트
extension EditScreenVC: CustomPickerDelegate {
    // [ 공통 ]
    // ----- 취소 버튼 -----
    /// 이미지 및 색상 피커에서 '취소' 버튼을 눌렀을 때, 카드 이미지 뷰에서 원래 이미지로 되돌림
    func cancel(type: EditScreenPicker) {
        // 카드 이미지뷰 리셋
        guard let currentType = self.viewModel.getDecorationCellTypeTuple() else { return }
        // 원래 이미지로 변경
        self.cardImgView.resetDecorationData(type: currentType.type)
        // 피커 내리기
        self.setPickerState(type: type, isOpen: false)
    }
    
    // ----- 도중 -----
    /// 이미지 및 색상 피커에서 이미지 및 색상이 변경이 되면, 카드 이미지 뷰를 업데이트
    func changedCropLocation(data: Any) {
        // 현재 타입 가져오기
        guard let currentType = self.viewModel.getDecorationCellTypeTuple() else { return }
        // 카드 이미지 뷰 업데이트
        self.cardImgView.updateCardView(type: currentType.type, data: data, onFailure: self.errorType(_:))
    }
    
    // ----- 완료 버튼 -----
    /// 이미지 및 색상 피커에서 '완료' 버튼을 눌렀을 때, 호출되는 메서드
    /// [카드 이미지 뷰 업데이트]
    /// [커스텀 피커 내리기]
    func done<T>(with data: T) {
        // 현재 타입 가져오기
        guard let currentType = self.viewModel.getDecorationCellTypeTuple() else { return }
        // 현재 데이터(색상 또는 이미지) 저장
        self.cardImgView.saveCurrentData(type: currentType.type)
        
        switch data {
        case let image as UIImage:
            self.processImage(image)
            break
        case let color as UIColor:
            self.processColor(color)
            break
        default:
            self.errorType(.readError)
            break
        }
    }
    /// 이미지 저장 및 피커 내리기
    private func processImage(_ image: UIImage) {
        // [셀] - 이미지 바꾸기 및 바뀐 이미지 저장
        self.updateImage(image: image)
        // 이미지 피커 안 보이게 하기
        self.configureImagePicker(isOpen: false, with: image)
    }
    /// 색상 저장
    private func processColor(_ color: UIColor) {
        // [셀] - 이미지 바꾸기 및 바뀐 이미지 저장
        self.updateColor(color: color)
        // 이미지 피커 안 보이게 하기
        self.configureColorPicker(isOpen: false)
    }
}







































//
//// MARK: - 이미지 권한 설정
//extension EditScreenVC {
//    /// 이미지 권한을 확인하는 메서드
//    func requestPhotoLibraryAccess() {
//        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
//        switch status {
//        case .authorized:
//            print("Authorized Access")
//            // 권한이 이미 있음
//            // .authorized == [전체 접근 허용]
//            // 사용자가 앱에 자신의 사진 라이브러리 전체에 대한 접근을 허용한 경우
//            self.coordinator.presentImagePicker()
//            
//        case .limited:
//            print("Limited Access")
//            // .limited == [접근 제한]
//            // 사용자가 앱에 사진 라이브러리의 전체 접근을 허용하지 않고,
//            // 대신 특정 사진이나 앨범에 대한 접근만을 허용한 경우
//            self.presentLimitedLibraryPicker()
//            
//        case .notDetermined:
//            print("notDetermined")
//            
//            // .notDetermined == [접근 제한되지 않음]
//            // 사용자가 아직 앱에 대한 사진 라이브러리 접근 권한을 결정하지 않은 상태
//            self.requestPhotoAccess()
//            
//        case .denied, .restricted:
//            print("denied or restricted")
//            // .denied == [접근 거부]
//            // 사용자가 앱의 사진 라이브러리 접근을 명시적으로 거부한 경우
//            // 사용자가 권한을 거부함. 설정으로 유도할 수 있음
//            // .restricted == [접근 불가]
//            // 부모의 제어 설정이나 기업 정책 등 외부 요인으로 인해 앱이 사진 라이브러리에 접근할 수 없는 경우
//            self.showPhotoLibraryAccessDeniedAlert()
//        @unknown default:
//            break
//        }
//    }
//    
//    /// notDetermined(접근 제한 됨) 상태일 때, 권한을 요청하는 메서드
//    private func requestPhotoAccess() {
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
//            DispatchQueue.main.async {
//                if newStatus == .authorized || newStatus == .limited {
//                    self.coordinator.presentImagePicker()
//                }
//            }
//        }
//    }
//    
//    /// denied(접근 거부) 및 restriced(접근 불가) 상태일 때, 설정으로 이동하는 메서드
//    private func showPhotoLibraryAccessDeniedAlert() {
//        self.customAlert(alertEnum: .photoAccess) { _ in
//            // 사용자를 앱의 설정 화면으로 이동
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl)
//            else { return }
//            UIApplication.shared.open(settingsUrl, options: [:])
//        }
//    }
//    
//    /// 제한된 접근 권한일 때, 추가 사진 선택을 허용하는 메서드
//    func presentLimitedLibraryPicker() {
//        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) {_ in 
//            // 사용자에게 추가 사진 선택을 요청한 후, 이미지 피커를 열기
//            self.coordinator.presentImagePicker()
//        }
//    }
//}
