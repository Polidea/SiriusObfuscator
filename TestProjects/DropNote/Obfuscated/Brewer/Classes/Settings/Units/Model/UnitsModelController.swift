//
// Created by Maciej Oczko on 18.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger

protocol k8rVGafQT4VHrs6gHsXJ31z1ow7In6w9 {
    func eLDc_7ijNp0JrFx1hRZB2YsXosmvQSVv(ZRIyQfdPa2ZWLId1iC1C2XmDsl6CLTDz dcnlq1_1ggdbaTsUS88vi6gNrFOPcL5K: Int) -> Int
    func To4vpD6nqf9OaSNeXwCiZUcQURhBpEIE(_ lAwHQklVRRjw6XJy3MeeHqkUTyQe65FH: Int, Yn6LqDd_svbxR_gEEgb37CVC1vSL5hLr xJ6fACyYmCbEHw230XI503U7Q84AMuFn: Int)
}

final class raGpACm5J1gnxJF_RZ3jpIfJMcsC2WRg: k8rVGafQT4VHrs6gHsXJ31z1ow7In6w9 {
    struct MF93juzALfuAN5cBqDdAOxLibZkC3JWp {
        static let XjpMlzRZF9GYB8EEGnjdo8ersjEiBKzW = "UnitsSettingsKey"
    }
    
    fileprivate let eG0uSfYEteABHRAlfmJRdeMjlptb7C34: M5jGoZc5zWwxlh8ebhtk0wDxk8apfl1e
    fileprivate(set) var v3Ybyx954ZjQCLWkcHNSNF4516h0fvl6 = [String: Int]()

    init(o86tMTTUomdhTvjjw1gmzcVhOVfEkRYz: M5jGoZc5zWwxlh8ebhtk0wDxk8apfl1e) {
        self.eG0uSfYEteABHRAlfmJRdeMjlptb7C34 = o86tMTTUomdhTvjjw1gmzcVhOVfEkRYz
        crUe7qD1HUWvPY1GyTqGUQ5nwgpd5GTK()
        B6Iw4Avr0sIj4IGT9omH4OHBhm9PzMud()
    }

    func eLDc_7ijNp0JrFx1hRZB2YsXosmvQSVv(ZRIyQfdPa2ZWLId1iC1C2XmDsl6CLTDz dcnlq1_1ggdbaTsUS88vi6gNrFOPcL5K: Int) -> Int {
        return v3Ybyx954ZjQCLWkcHNSNF4516h0fvl6[String(dcnlq1_1ggdbaTsUS88vi6gNrFOPcL5K)]!
    }

    func To4vpD6nqf9OaSNeXwCiZUcQURhBpEIE(_ lAwHQklVRRjw6XJy3MeeHqkUTyQe65FH: Int, Yn6LqDd_svbxR_gEEgb37CVC1vSL5hLr xJ6fACyYmCbEHw230XI503U7Q84AMuFn: Int) {
        v3Ybyx954ZjQCLWkcHNSNF4516h0fvl6[String(xJ6fACyYmCbEHw230XI503U7Q84AMuFn)] = lAwHQklVRRjw6XJy3MeeHqkUTyQe65FH
        eG0uSfYEteABHRAlfmJRdeMjlptb7C34.set(v3Ybyx954ZjQCLWkcHNSNF4516h0fvl6, forKey: MF93juzALfuAN5cBqDdAOxLibZkC3JWp.XjpMlzRZF9GYB8EEGnjdo8ersjEiBKzW)
        _ = eG0uSfYEteABHRAlfmJRdeMjlptb7C34.synchronize()
    }

    // MARK: Settings loading

    fileprivate func B6Iw4Avr0sIj4IGT9omH4OHBhm9PzMud() {
        guard let rawUnitsSettings = eG0uSfYEteABHRAlfmJRdeMjlptb7C34.object(forKey: MF93juzALfuAN5cBqDdAOxLibZkC3JWp.XjpMlzRZF9GYB8EEGnjdo8ersjEiBKzW) as? [String: Int] else {
            XCGLogger.error("Can't load settings!")
            return
        }
        v3Ybyx954ZjQCLWkcHNSNF4516h0fvl6 = rawUnitsSettings
    }

    // MARK: Default settings

    fileprivate func crUe7qD1HUWvPY1GyTqGUQ5nwgpd5GTK() {
        if eG0uSfYEteABHRAlfmJRdeMjlptb7C34.object(forKey: MF93juzALfuAN5cBqDdAOxLibZkC3JWp.XjpMlzRZF9GYB8EEGnjdo8ersjEiBKzW) == nil {
            let defaultSettings = [
                String(LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.water.rawValue): LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.water.v1PAfQpawOxz4EDIRuwPcH5OPJfjL6iM(),
                String(LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.weight.rawValue): LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.weight.v1PAfQpawOxz4EDIRuwPcH5OPJfjL6iM(),
                String(LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.temperature.rawValue): LT8FbLl8EZUIiOt7Edmum4gjRb1NtGOX.temperature.v1PAfQpawOxz4EDIRuwPcH5OPJfjL6iM()
            ]
            eG0uSfYEteABHRAlfmJRdeMjlptb7C34.set(defaultSettings, forKey: MF93juzALfuAN5cBqDdAOxLibZkC3JWp.XjpMlzRZF9GYB8EEGnjdo8ersjEiBKzW)
            _ = eG0uSfYEteABHRAlfmJRdeMjlptb7C34.synchronize()
        }
    }
}
