import Foundation
import UIKit
import RxSwift
import RxCocoa

final class KeyboardManager {
    fileprivate let disposeBag = DisposeBag()
    
    var keyboardInfoChange: Observable<KeyboardInfo> {
        return keyboardInfoChangeSubject.asObservable()
    }
    fileprivate let keyboardInfoChangeSubject: PublishSubject<KeyboardInfo>
    
    init() {
        keyboardInfoChangeSubject = PublishSubject()
        
        let center = NotificationCenter.default
        center.rx.notification(NSNotification.Name.UIKeyboardWillShow).map(keyboardWillShowNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx.notification(NSNotification.Name.UIKeyboardDidShow).map(keyboardDidShowNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx.notification(NSNotification.Name.UIKeyboardWillHide).map(keyboardWillHideNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx.notification(NSNotification.Name.UIKeyboardDidHide).map(keyboardDidHideNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
    }
    
    fileprivate func keyboardWillShowNotification(_ notification: Notification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo((notification as NSNotification).userInfo, state: .willShow)
    }
    
    fileprivate func keyboardDidShowNotification(_ notification: Notification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo((notification as NSNotification).userInfo, state: .visible)
    }
    
    fileprivate func keyboardWillHideNotification(_ notification: Notification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo((notification as NSNotification).userInfo, state: .willHide)
    }
    
    fileprivate func keyboardDidHideNotification(_ notification: Notification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo((notification as NSNotification).userInfo, state: .hidden)
    }
}

enum KeyboardState {
    case hidden
    case willShow
    case visible
    case willHide
}

extension KeyboardState: CustomStringConvertible {
    var description: String {
        switch self {
        case .hidden: return "Hidden"
        case .willHide: return "WillHide"
        case .willShow: return "WillShow"
        case .visible: return "Visible"
        }
    }
}

struct KeyboardInfo {
    let state: KeyboardState
    let beginFrame: CGRect
    let endFrame: CGRect
    let animationCurve: UIViewAnimationCurve
    let animationDuration: TimeInterval

    var animationOptions: UIViewAnimationOptions {
        switch animationCurve {
        case .easeInOut: return UIViewAnimationOptions()
        case .easeIn: return UIViewAnimationOptions.curveEaseIn
        case .easeOut: return UIViewAnimationOptions.curveEaseOut
        case .linear: return UIViewAnimationOptions.curveLinear
        }
    }
    
    static func fromNotificationUserInfo(_ info: [AnyHashable: Any]?, state: KeyboardState) -> KeyboardInfo {
        let beginFrame = (info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let endFrame = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        
        let curve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .easeInOut
        let duration = TimeInterval(info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
        return KeyboardInfo(state: state, beginFrame: beginFrame, endFrame: endFrame, animationCurve: curve, animationDuration: duration)
    }
}
