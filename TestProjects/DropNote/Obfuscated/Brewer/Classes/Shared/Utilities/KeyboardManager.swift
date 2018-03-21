import Foundation
import UIKit
import RxSwift
import RxCocoa

final class VUYvyMPmwITRyhjGtABIcANx_I9HYLML {
    fileprivate let b3A4ZPkeN0Zk1aSWQ5lozLwyzuljlrGg = DisposeBag()
    
    var PPdlLyMdtOtZ5bYHsKQiFmnm3ZDRYtiy: Observable<G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7> {
        return Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t.asObservable()
    }
    fileprivate let Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t: PublishSubject<G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7>
    
    init() {
        Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t = PublishSubject()
        
        let center = NotificationCenter.default
        center.rx.notification(NSNotification.Name.UIKeyboardWillShow).map(oBqe6x7YKAOc3hrc2cZoy9osZqHq9Jk4)
            .subscribe(Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t).disposed(by: b3A4ZPkeN0Zk1aSWQ5lozLwyzuljlrGg)
        center.rx.notification(NSNotification.Name.UIKeyboardDidShow).map(TLPYDJxO_03Ful6CcYYZqsPxaAiHbiTz)
            .subscribe(Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t).disposed(by: b3A4ZPkeN0Zk1aSWQ5lozLwyzuljlrGg)
        center.rx.notification(NSNotification.Name.UIKeyboardWillHide).map(uT5qihsQS6IvgadjU1MaLRAgsJMC5Hyr)
            .subscribe(Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t).disposed(by: b3A4ZPkeN0Zk1aSWQ5lozLwyzuljlrGg)
        center.rx.notification(NSNotification.Name.UIKeyboardDidHide).map(G0ifwdhWOeOpeXc1DynRuWdto7GhipsG)
            .subscribe(Hmyt9QjI01NOfjuRn8sqV2qUYQkQ6Z8t).disposed(by: b3A4ZPkeN0Zk1aSWQ5lozLwyzuljlrGg)
    }
    
    fileprivate func oBqe6x7YKAOc3hrc2cZoy9osZqHq9Jk4(_ NNOUK54NYwZRoKuprFXzKLSFF_31J83n: Notification) -> G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
        return G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7.HIAwYRorJxrAj06vUqNF4VZFrK6RUlvD((NNOUK54NYwZRoKuprFXzKLSFF_31J83n as NSNotification).userInfo, I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf: .willShow)
    }
    
    fileprivate func TLPYDJxO_03Ful6CcYYZqsPxaAiHbiTz(_ QcFAWB_agiK0A8eQZwikS97VjbcnBypK: Notification) -> G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
        return G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7.HIAwYRorJxrAj06vUqNF4VZFrK6RUlvD((QcFAWB_agiK0A8eQZwikS97VjbcnBypK as NSNotification).userInfo, I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf: .visible)
    }
    
    fileprivate func uT5qihsQS6IvgadjU1MaLRAgsJMC5Hyr(_ drqGahwikdK2Z7yBYILCVyw4WVyhwjLY: Notification) -> G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
        return G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7.HIAwYRorJxrAj06vUqNF4VZFrK6RUlvD((drqGahwikdK2Z7yBYILCVyw4WVyhwjLY as NSNotification).userInfo, I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf: .willHide)
    }
    
    fileprivate func G0ifwdhWOeOpeXc1DynRuWdto7GhipsG(_ AfSH1MMx1lalyOsVhjraOT7tRrnYgRw6: Notification) -> G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
        return G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7.HIAwYRorJxrAj06vUqNF4VZFrK6RUlvD((AfSH1MMx1lalyOsVhjraOT7tRrnYgRw6 as NSNotification).userInfo, I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf: .hidden)
    }
}

enum nzmN_uxOgr9lMpPhtTFf9uN7Zw8qJcyb {
    case hidden
    case willShow
    case visible
    case willHide
}

extension nzmN_uxOgr9lMpPhtTFf9uN7Zw8qJcyb: CustomStringConvertible {
    var description: String {
        switch self {
        case .hidden: return "Hidden"
        case .willHide: return "WillHide"
        case .willShow: return "WillShow"
        case .visible: return "Visible"
        }
    }
}

struct G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
    let VCpXSmYTVdVkXLAKlChUbVJkvEd4OfbL: nzmN_uxOgr9lMpPhtTFf9uN7Zw8qJcyb
    let ALJHMWPiEA97_1AN24deDg9QGUAZ86t4: CGRect
    let hRSRSODCsHyCIjH4ZPdDnJjgWhaERr7T: CGRect
    let PKEqpu1kBf6do5PNBsF42MEJ5M_k9Wys: UIViewAnimationCurve
    let ulojvafc1c_qXqirUaglJAfO6FHwJxvD: TimeInterval

    var x3wUbkSz6SMbGTIKscPKfdG0NOc5IFwy: UIViewAnimationOptions {
        switch PKEqpu1kBf6do5PNBsF42MEJ5M_k9Wys {
        case .easeInOut: return UIViewAnimationOptions()
        case .easeIn: return UIViewAnimationOptions.curveEaseIn
        case .easeOut: return UIViewAnimationOptions.curveEaseOut
        case .linear: return UIViewAnimationOptions.curveLinear
        }
    }
    
    static func HIAwYRorJxrAj06vUqNF4VZFrK6RUlvD(_ grtuRA9bLZkbRltPZDKqtGBdFvC1B5Gy: [AnyHashable: Any]?, I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf: nzmN_uxOgr9lMpPhtTFf9uN7Zw8qJcyb) -> G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7 {
        let beginFrame = (grtuRA9bLZkbRltPZDKqtGBdFvC1B5Gy?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let endFrame = (grtuRA9bLZkbRltPZDKqtGBdFvC1B5Gy?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        
        let curve = UIViewAnimationCurve(rawValue: grtuRA9bLZkbRltPZDKqtGBdFvC1B5Gy?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .easeInOut
        let duration = TimeInterval(grtuRA9bLZkbRltPZDKqtGBdFvC1B5Gy?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
        return G5dsTScqJAV2q91wFapgrkC6c9Yo0gh7(VCpXSmYTVdVkXLAKlChUbVJkvEd4OfbL: I4CZfP_ygO7Hb1LLgpfnkvaaw6zAdqxf, ALJHMWPiEA97_1AN24deDg9QGUAZ86t4: beginFrame, hRSRSODCsHyCIjH4ZPdDnJjgWhaERr7T: endFrame, PKEqpu1kBf6do5PNBsF42MEJ5M_k9Wys: curve, ulojvafc1c_qXqirUaglJAfO6FHwJxvD: duration)
    }
}
