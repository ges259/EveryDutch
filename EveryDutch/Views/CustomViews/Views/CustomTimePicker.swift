//
//  CustomTimePicker.swift
//  EveryDutch
//
//  Created by 계은성 on 5/5/24.
//

import UIKit

protocol CustomTimePickerDelegate: AnyObject {
    func setTime(timeString: String)
}

final class CustomTimePicker: UIPickerView {
    
    // MARK: - 프로퍼티
    weak var customTimePickerDelegate: CustomTimePickerDelegate?
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.backgroundColor = UIColor.white
        
        self.dataSource = self
        self.delegate = self
        
        self.isHidden = true
        self.alpha = 0
    }
    // MARK: - 타임피커 초기 설정
    func setupTimePicker() {
        // 타임피커 레이블에 현재 시간(시,분)을 설정
        let currentTime: [Int] = self.getCurrentTime()
        // [타임피커 내부] 레이블 설정
        self.selectRow(currentTime[0], inComponent: 0, animated: false) // 시간
        self.selectRow(currentTime[1], inComponent: 1, animated: false) // 분
        
        self.delegateTimeString(timeIntArray: currentTime)
    }
    /// 현재 시간 반환을 [Int] 형태로 반환
    private func getCurrentTime() -> [Int] {
        let now = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        return [hour, minute]
    }
}

extension CustomTimePicker: UIPickerViewDataSource {
    // MARK: - 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 시간과 분을 위한 두 개의 컴포넌트
        return 2
    }
    
    // MARK: - 최소 및 최대 숫자
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int)
    -> Int {
        return component == 0
        ? 24 // 시간은 0부터 23까지
        : 60 // 분은 0부터 59까지
    }
}

extension CustomTimePicker: UIPickerViewDelegate {
    // MARK: - 형식
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int)
    -> String? {
        // 두 자리 숫자 형식으로 반환
        return self.timePickerFormat(row)
    }
    
    // MARK: - 폰트
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?)
    -> UIView {
        // 재사용 가능한 뷰가 있으면 사용하고,
        var label: UILabel
        if let view = view as? UILabel {
            label = view
            // 없으면 새로운 라벨을 생성
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18) // 폰트 크기를 24로 설정
        label.text = self.timePickerFormat(row)
        return label
    }
    /// 형식 설정
    func timePickerFormat(_ row: Int) -> String {
        return String(format: "%02d", row)
    }
    
    
    
    
    
    // MARK: - 선택 시 액션
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        // 사용자가 선택한 시간과 분을 처리
        let selectedHour = pickerView.selectedRow(inComponent: 0)
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        self.delegateTimeString(timeIntArray: [
            selectedHour,
            selectedMinute
        ])
    }
    /// 델리게이트를 통해 시간을 String데이터로 전달
    private func delegateTimeString(timeIntArray: [Int]) {
        // 시간 계산
        let timeText = self.timePickerString(hour: timeIntArray[0],
                                             minute: timeIntArray[1])
        self.customTimePickerDelegate?.setTime(timeString: timeText)
    }
    /// '시간' 및 '분의 Int값을 파라미터로 받아, '12 : 12' 형태로 String으로 반환
    func timePickerString(hour: Int, minute: Int) -> String {
        // 선택한 시간과 분을 이용하여 필요한 작업 수행
        let hour = String(format: "%02d", hour)
        let minute = String(format: "%02d", minute)
        // 선택한 시간을 timeInfoLbl에 넣기
        return "\(hour) : \(minute)"
    }
}
