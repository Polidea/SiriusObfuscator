//
//  BrewCellScoreView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class Xgwnzd_RLX9xAB4KadJBfk1jGUbX3mV7: UIView {
    @IBOutlet weak var AZGg1BHNnq099MzhkjtJxpeKy6zkriEl: UILabel!
    
    fileprivate let b6HzfiW1jaLaqKFZKS5haCaGtaRGi0bd = UIView()
    var LhDSdgdkeSHrfl1VAQ0ivI5l9VbcZH4o: Double = 0
    var xdr5ccI0yXSwdA7yOFzF14KSrhmL12Kv: UIColor = .white {
        didSet {
            layer.borderColor = xdr5ccI0yXSwdA7yOFzF14KSrhmL12Kv.cgColor
        }
    }
    
    var sp1w0f2lbh3UHNKHwZwmxXgoyr2_sNtO: UIColor = .white {
        didSet {
            b6HzfiW1jaLaqKFZKS5haCaGtaRGi0bd.backgroundColor = sp1w0f2lbh3UHNKHwZwmxXgoyr2_sNtO
        }
    }
    
    required init?(coder _4pgWC05Xa3KMaYqd06_5jAnFPx5SDKh: NSCoder) {
        super.init(coder: _4pgWC05Xa3KMaYqd06_5jAnFPx5SDKh)
        clipsToBounds = true
        layer.borderWidth = 3
        insertSubview(b6HzfiW1jaLaqKFZKS5haCaGtaRGi0bd, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
        b6HzfiW1jaLaqKFZKS5haCaGtaRGi0bd.frame = CGRect(
            x: 0,
            y: frame.height * CGFloat(1 - LhDSdgdkeSHrfl1VAQ0ivI5l9VbcZH4o),
            width: frame.width,
            height: frame.height * CGFloat(LhDSdgdkeSHrfl1VAQ0ivI5l9VbcZH4o)
        )
    }
}

extension Xgwnzd_RLX9xAB4KadJBfk1jGUbX3mV7 {
    
    func Sz29rScPID_qJyKQ4R2HMTLGtRzsLBQj(_ ySgSC9hFsbmoaoVpZ1OnOna_MiKtDybN: uxojwo8aosue9wOkkgXXYi7IMaiKR2jw?) {
        super.mM1hLSts8AMGTpIyOs2I4V0v06Nc9hy_(ySgSC9hFsbmoaoVpZ1OnOna_MiKtDybN)
        AZGg1BHNnq099MzhkjtJxpeKy6zkriEl.mM1hLSts8AMGTpIyOs2I4V0v06Nc9hy_(ySgSC9hFsbmoaoVpZ1OnOna_MiKtDybN)
        AZGg1BHNnq099MzhkjtJxpeKy6zkriEl.backgroundColor = UIColor.clear
    }
}
