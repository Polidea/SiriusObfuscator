//
//  RootViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import RxSwift
import RxCocoa

extension K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_: Q3c1Yv0NMG53YSzxbfYtUko_jFRWEYtg { }
extension K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_: HSFELwdXllJy_qRSQHcF2C2z5JoyqC0X { }

final class K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_: UITabBarController {
    var x4lIsVujVz6by449wXl0VpmR04T6jHiY: Resolver?
	var RXX5Q_QAsdJLlQ3LK59w6tnRhTQryjNm: uxojwo8aosue9wOkkgXXYi7IMaiKR2jw?

    fileprivate(set) var Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8: [UIViewController]?

	override func viewDidLoad() {
		super.viewDidLoad()

        Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8 = viewControllers?
            .elements(ofType: UINavigationController.self)
            .map { $0.topViewController }
            .flatMap { $0 }
        
        let methodPickerViewController = Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?
            .elements(ofType: NRriTt0LB645QjobKEkunL01CWXAJwrw.self)
            .first
        
        _ = methodPickerViewController?
            .Jgpbhk6wpiwaKJTR4BqXltiEf4GoD5Ch
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                brewMethod in
                vCkQt8PVcgn_Z0bR0jzr5oqpG1_IaB0t.ey0lB4iJ1VQTsKgM2Kpdd4RYkcFmAaly.ea9qrDYlHmfLgnFBG86G_9JX3GF3NIhM(MEAGR38h_tZZnWeW0wP7bYjSyE1wlmRG: saz0MeJCmPLhsdq3XNfrmnmvUuRCSE94.ExailxwlpSxoDOugJH6S_jFgcPEHE6Xm, hVSapHmCQbCoYGGizG08myAdoFTRHRH_: brewMethod)
                self.MXYCBskZZ7lDMQK4FG5y1u77a5oK4jrk(YDRh2H6fImt_aW8FeqPl1PTVfHL30ju8: brewMethod)
            })
        
        Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?
            .elements(ofType: wL8OLrup1pw8GLYJMMAaPZv3uup_FPkv.self)
            .forEach { $0.CRladT5kjUoRJ258xwQDz326EST2v3wR() }

        mM1hLSts8AMGTpIyOs2I4V0v06Nc9hy_(RXX5Q_QAsdJLlQ3LK59w6tnRhTQryjNm)
	}

    override func prepare(for XsXPnhyOTZTmoM9xsgX46SepO7m2_klg: UIStoryboardSegue, sender: Any?) {
        guard let resolver = x4lIsVujVz6by449wXl0VpmR04T6jHiY else { fatalError("Dependency resolver is missing.") }

        if case .StartNewBrew = Y1uYo3WIhilWLaA6lhh6l5FN2guFRmlc(XsXPnhyOTZTmoM9xsgX46SepO7m2_klg) , sender is L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<nuxqDBsI4wfpWaAd6Qa7ngxxhLD6egKy> {
            let boxedBrewContext = sender as! L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi<nuxqDBsI4wfpWaAd6Qa7ngxxhLD6egKy>
            let nc = XsXPnhyOTZTmoM9xsgX46SepO7m2_klg.destination as! UINavigationController
            let newBrewViewController = nc.topViewController as! kKZxXMM_7zHCQz4SWTRisE8sv9qIPLHZ
            newBrewViewController.tDru6hMZtXQsxsevQsz2c7PyQNyZekbg = resolver.resolve(hBaIbDN3kBdPQiSGHMIAiIrUeuMUVXwr.self, argument: boxedBrewContext.Ugbjc7LSYxf4XYd9x9OivSd1QvfKA0V_)!
            _ = newBrewViewController
                .kI4HV5JsC0ecL4uQby1jXxe2QFYEXG0y
                .subscribe(onNext: xvuwdtCmS2_W1eeLk9_KJRg_FA3GdYf9)
        }

        if let unwindSegue = XsXPnhyOTZTmoM9xsgX46SepO7m2_klg as? hLVWBEYtwj5PXdqCZgziHFWgXYvtIl1h , unwindSegue.hfXTbU5XyIqRXFPlrc1UHjv_exif31r3 == true {
            if let historyViewControllerIndex = Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?.index(where: { $0 is efyhSLwe4QpLjRAGdRPwwm2RGWheMQOA }) {
                DispatchQueue.main.async {
                    self.selectedIndex = historyViewControllerIndex
                }
            }
        }
    }
    
    private func xvuwdtCmS2_W1eeLk9_KJRg_FA3GdYf9(_ YCjC6WT6abLI3R5Yl3W01M8M2Oj7xIYS: Bool) {
        if let historyViewControllerIndex = Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?.index(where: { $0 is efyhSLwe4QpLjRAGdRPwwm2RGWheMQOA }) , YCjC6WT6abLI3R5Yl3W01M8M2Oj7xIYS == true {
            selectedIndex = historyViewControllerIndex
        }
        dismiss(animated: true, completion: nil)
    }
    
    func MXYCBskZZ7lDMQK4FG5y1u77a5oK4jrk(YDRh2H6fImt_aW8FeqPl1PTVfHL30ju8 ffWdgHniR5IKCJdGGvM9t5CxPXwNilLb: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei) {
        let context = nuxqDBsI4wfpWaAd6Qa7ngxxhLD6egKy(ojqPxKCAM4nHR37eue0iF7V1Gwgmihqg: ffWdgHniR5IKCJdGGvM9t5CxPXwNilLb)
        xMMeAVhFMYT18OJmPDzdRDiKszpHyo0e(.StartNewBrew, li5bPIJzo8le5JU31fBEZi_FoclyLMDz: L_fnOCj_Jv6MgAL0w2SMUf54v143B9Bi(context))
    }
}

extension K_aAPR1ESq6obbB4iOQKU8CWj_4E6vR_: MwFLWZjR5G3DuYWPa3I4wGndBvUBbip8 {

	func mM1hLSts8AMGTpIyOs2I4V0v06Nc9hy_(_ OZ20SAMVRPm1mANBY3A4hhKFmrJtnZ3A: uxojwo8aosue9wOkkgXXYi7IMaiKR2jw?) {
		guard let theme = OZ20SAMVRPm1mANBY3A4hhKFmrJtnZ3A else { return }

		tabBar.tintColor = theme.p0aTN3DFL50yok1qLaV3K4Mhm5maOb_J.e0mQy4y31ip2PfWSHLxMVT8eqNjaYwB6
		tabBar.barTintColor = theme.p0aTN3DFL50yok1qLaV3K4Mhm5maOb_J.HsiXZlE4Z69Z7VEQWILdepJso8brOgx7
		tabBar.isTranslucent = theme.p0aTN3DFL50yok1qLaV3K4Mhm5maOb_J.PGh7hJz4lbpRRwh88qeC1ZZFuD2uoOBo
        tabBar.items?[0].accessibilityLabel = "Select First"
        tabBar.items?[0].accessibilityHint = "Selects Starting New Brew Tab"
        tabBar.items?[1].accessibilityLabel = "Select Second"
        tabBar.items?[1].accessibilityHint = "Selects History Tab"
        tabBar.items?[2].accessibilityLabel = "Select Third"
        tabBar.items?[2].accessibilityHint = "Selects Settigns Tab"

		Kddh7BYX4KyEz0Tq5whB89mB6FUNB0x8?
            .elements(ofType: MwFLWZjR5G3DuYWPa3I4wGndBvUBbip8.self)			
			.forEach { $0.mM1hLSts8AMGTpIyOs2I4V0v06Nc9hy_(RXX5Q_QAsdJLlQ3LK59w6tnRhTQryjNm) }
	}
}
