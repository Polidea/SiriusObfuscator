//
// Created by Maciej Oczko on 24.07.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

final class vCkQt8PVcgn_Z0bR0jzr5oqpG1_IaB0t {
    
    static let ey0lB4iJ1VQTsKgM2Kpdd4RYkcFmAaly = vCkQt8PVcgn_Z0bR0jzr5oqpG1_IaB0t()
    
    fileprivate var DxFu82CTL8BQxMX8tIPhSiYZRI7rYaPd: GAITracker?
    
    fileprivate init() {
        #if !DEBUG
            f37S5HNsVcpv_A1Pdj6NwsYrMJzEUKPo()
            DxFu82CTL8BQxMX8tIPhSiYZRI7rYaPd = GAI.sharedInstance().defaultTracker
        #endif
    }
    
    // MARK: Setup

    fileprivate func f37S5HNsVcpv_A1Pdj6NwsYrMJzEUKPo() {
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if let error = error {
            print("Error configuring Google services: \(error.localizedDescription)")
        }
                
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true
        gai?.logger.logLevel = GAILogLevel.warning
    }
    
    // MARK: Events
    
    func Nh2itACzykkA2rC8g655341QOwNhZDPb(TTFGIckdCM6WUr4K4AL4kWbZ4QM0E0zz usbXTDxcnGxLyEmzANhEk8UTXOGXRZBz: String) {
        DxFu82CTL8BQxMX8tIPhSiYZRI7rYaPd?.set(kGAIScreenName, value: usbXTDxcnGxLyEmzANhEk8UTXOGXRZBz)
        DxFu82CTL8BQxMX8tIPhSiYZRI7rYaPd?.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }
    
    func ea9qrDYlHmfLgnFBG86G_9JX3GF3NIhM(MEAGR38h_tZZnWeW0wP7bYjSyE1wlmRG NElSsDQGbfguSZQZkbTEuP08iWASDyZc: String, hVSapHmCQbCoYGGizG08myAdoFTRHRH_: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei) {
        DxFu82CTL8BQxMX8tIPhSiYZRI7rYaPd?.send(
            GAIDictionaryBuilder.createEvent(
                withCategory: NElSsDQGbfguSZQZkbTEuP08iWASDyZc,
                action: "Selected",
                label: hVSapHmCQbCoYGGizG08myAdoFTRHRH_.rawValue,
                value: 1)
                .build() as [NSObject : AnyObject]
        )
    }
}
