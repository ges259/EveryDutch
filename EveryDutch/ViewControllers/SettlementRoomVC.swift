//
//  SettlementRoomVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/26.
//

import UIKit
import SnapKit

final class SettlementRoomVC: UIViewController {
    // MARK: - 레이아웃
    private lazy var topView: UIView = UIView.configureView(
        color: .deep_Blue)
    
    private lazy var topViewIndicator: UIView = UIView.configureView(
        color: .black)
    
    
    

    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private weak var coordinator: SettlementRoomCoordinating?
    private var viewModel: SettlementRoomVM?
    
    // 탑뷰와 관련된 프로퍼티
    private lazy var topViewHeight: NSLayoutConstraint = self.topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80)
    private let maxHeight: CGFloat = 350
    private let minHeight: CGFloat = 100
    private var topViewIsOpen: Bool = false
    
    
    var initialHeight: CGFloat = 0
    private var initialTranslationY: CGFloat = 0
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SettlementRoomVM,
         coordinator: SettlementRoomCoordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SettlementRoomVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        
        self.topView.clipsToBounds = true
        self.topView.layer.cornerRadius = 35
        
        self.topViewIndicator.clipsToBounds = true
        self.topViewIndicator.layer.cornerRadius = 3
        
        
        // 뷰 액션 설정
        // 위로 스와이프 -> 달력 크기 변경(주)
//        let swipeUp = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(self.swipeAction(_:)))
//            swipeUp.direction = .up
//        // 아래로 스와이프 -> 달력 크기 변경(월)
//        let swipeDown = UISwipeGestureRecognizer(
//            target: self,
//            action: #selector(self.swipeAction(_:)))
//            swipeDown.direction = .down
//        self.topView.addGestureRecognizer(swipeUp)
//        self.topView.addGestureRecognizer(swipeDown)
//
        
        
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.topView,
         self.topViewIndicator].forEach { view in
            self.view.addSubview(view)
        }
        
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.topViewHeight.isActive = true
        
        self.topViewIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.topView.snp.bottom).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(6)
            make.centerX.equalTo(self.topView)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        
        // panGesture - UIView에 스크롤 제스쳐 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollVertical))
//        panGesture.delegate = self
        
        self.topView.addGestureRecognizer(panGesture)
    }
     
//    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: view)
//
//         // 최소 크기에서는 아래로 드래그 했을 때만, 최대 크기에서는 위로 드래그 했을 때만 크기가 변경되게 합니다.
//         switch sender.state {
//         case .changed:
//             // 현재 높이에 변화량을 더합니다.
//             let newHeight = self.topViewHeight!.constant + translation.y
//
//             // 높이를 범위 내로 제한합니다.
//             if newHeight < maxHeight, newHeight > minHeight {
//                 self.topViewHeight?.constant = newHeight
//                 sender.setTranslation(.zero, in: view) // 제스처 인식기의 변화량을 리셋합니다.
//             }
//         case .ended:
//             // 드래그를 끝냈을 때 최소 또는 최대 높이를 넘어가면 애니메이션으로 되돌립니다.
//             UIView.animate(withDuration: 0.3) {
//                 if self.topViewHeight!.constant > self.maxHeight {
//                     self.topViewHeight?.constant = self.maxHeight
//                 } else if self.topViewHeight!.constant < self.minHeight {
//                     self.topViewHeight?.constant = self.minHeight
//                 }
//                 self.view.layoutIfNeeded()
//             }
//         default:
//             break
//         }
//     }
    @objc private func scrollVertical3(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
         let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.

         switch sender.state {
         case .changed:
             if !self.topViewIsOpen {
                 // 최소 크기일 때, 아래로 스와이프하는 경우에만 처리합니다.
                 if translation.y > 0 {
                     // 스와이프 속도를 체크합니다. 속도가 너무 빠르면 최대 크기로 바로 전환합니다.
                     if velocity.y < 1000 { // 속도 제한을 설정합니다.
                         let newHeight = self.topViewHeight.constant + translation.y

                         // 새 높이가 최대 높이를 넘지 않도록 합니다.
                         if newHeight <= maxHeight {
                             self.topViewHeight.constant = newHeight
                             sender.setTranslation(.zero, in: view)
                         }
                     }
                 }
             }
         case .ended, .cancelled:
             // 속도가 충분히 느리고 최소 크기에서만 스와이프한 경우에 최대 크기로 변경합니다.
             if translation.y > 0 && velocity.y < 3000 && !self.topViewIsOpen {
                 self.topViewHeight.constant = maxHeight
                 self.topViewIsOpen = true // 확장 상태로 변경합니다.
             } else {
                 // 그렇지 않으면 원래 크기로 돌아갑니다.
                 self.topViewHeight.constant = minHeight
                 self.topViewIsOpen = false
             }

             UIView.animate(withDuration: 0.3) {
                 self.view.layoutIfNeeded()
             }
         default:
             break
         }
     }


    
    
    
    @objc private func scrollVertical(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view) // 스와이프 속도를 가져옵니다.
        
          switch sender.state {
          case .began:
              // 제스처가 시작될 때 초기 높이를 저장합니다.
              initialHeight = topViewHeight.constant
          case .changed:
              // 새 높이를 계산합니다.
              var newHeight = initialHeight + translation.y

              // 새 높이가 최대 높이를 넘지 않도록 합니다.
              newHeight = min(maxHeight, newHeight)
              // 새 높이가 최소 높이보다 작아지지 않도록 합니다.
              newHeight = max(minHeight, newHeight)

              // 제약 조건을 업데이트하지만 layoutIfNeeded는 호출하지 않습니다.
              topViewHeight.constant = newHeight

          case .ended, .cancelled:
              // 속도가 충분히 느리고 최소 크기에서만 스와이프한 경우에 최대 크기로 변경합니다.
              if translation.y > 0 && velocity.y < 15000 && !self.topViewIsOpen {
                  self.topViewHeight.constant = maxHeight
                  self.topViewIsOpen = true // 확장 상태로 변경합니다.
              } else {
                  // 그렇지 않으면 원래 크기로 돌아갑니다.
                  self.topViewHeight.constant = minHeight
                  self.topViewIsOpen = false
              }

              UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
              }
              
              
          default:
              break
          }
      }
    
    //          case .ended, .cancelled:
    //              // 드래그를 끝냈을 때 최종 높이를 결정합니다.
    //              let shouldExpand = topViewHeight.constant > (maxHeight + minHeight) / 2
    //              topViewHeight.constant = shouldExpand ? maxHeight : minHeight
    //              topViewIsOpen = shouldExpand
    //
    //              UIView.animate(withDuration: 0.3) {
    //                  self.view.layoutIfNeeded()
    //              }
    @objc private func scrollVertical2(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            // Calculate the change in Y
            let translation = sender.translation(in: view)
            let newHeight = topViewHeight.constant + translation.y
            
            // Check if we should switch state and if the gesture is significant
            if !topViewIsOpen && translation.y > 0 && newHeight > minHeight {
                topViewHeight.constant = maxHeight
                topViewIsOpen = true
            } else if topViewIsOpen && translation.y < 0 && newHeight < maxHeight {
                topViewHeight.constant = minHeight
                topViewIsOpen = false
            }
            
            sender.setTranslation(.zero, in: view) // Reset the translation
        default:
            break
        }

        // Animate the height change
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}



//extension SettlementRoomVC: UIGestureRecognizerDelegate {
//
//}
