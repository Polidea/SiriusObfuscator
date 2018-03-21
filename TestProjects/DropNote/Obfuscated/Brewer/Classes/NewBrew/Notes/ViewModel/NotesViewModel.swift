//
//  NotesViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol b0C8GjAiteIfctiEIRuupq4jHVCCCIwq {
    var SBXmAnmNlJi70UlVJHXMXuECWihqs_XR: Variable<String?> { get }
}

final class lZalNxBQ5gTn3dF9CbvRZqBf4z6KpbNH: b0C8GjAiteIfctiEIRuupq4jHVCCCIwq {
    fileprivate let _kTAL32V0vasvXJqxM49kZaGdP_YJsga = DisposeBag()
    let xcZWtQMmoZ4d40pAaGgK2BYz_zSRSCZ4: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4
    
    fileprivate(set) var SBXmAnmNlJi70UlVJHXMXuECWihqs_XR: Variable<String?> = Variable("")
    
    init(LZfRaUYPRKFzp2uekJfR5nfi7PVoWzih: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4) {
        self.xcZWtQMmoZ4d40pAaGgK2BYz_zSRSCZ4 = LZfRaUYPRKFzp2uekJfR5nfi7PVoWzih
        SBXmAnmNlJi70UlVJHXMXuECWihqs_XR.value = LZfRaUYPRKFzp2uekJfR5nfi7PVoWzih.VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.notes ?? ""
        SBXmAnmNlJi70UlVJHXMXuECWihqs_XR.asDriver().map { $0 ?? "" }.drive(onNext: MOcLoQY7nyZJgFxmUDt4m56vCGCugabr).disposed(by: _kTAL32V0vasvXJqxM49kZaGdP_YJsga)
    }
    
    fileprivate func MOcLoQY7nyZJgFxmUDt4m56vCGCugabr(_ xdiBmAidAeSRUcF40Ie6_3AH17SfmeYK: String) {
        xcZWtQMmoZ4d40pAaGgK2BYz_zSRSCZ4.VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.notes = xdiBmAidAeSRUcF40Ie6_3AH17SfmeYK
    }
}
