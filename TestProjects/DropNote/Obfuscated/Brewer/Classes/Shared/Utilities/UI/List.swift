import Foundation
import UIKit

protocol ZzToPnlnDFg8jzFTd4GddvjqomKImZhw {
    associatedtype ListView
    associatedtype Cell
    associatedtype Object
    
    func CmL83CjitWUSc4Gbbn6iduvkBknk7Weg(_ COMoiPOv3O2VbFpQYB7tf2JQ74sAcXve: IndexPath) -> String
    func Y5CEbIk4WvTFFIDo77JDXxpm7hlynQqx(_ xax3JZ6tHmiRVpJoZqus_HpvDK9k11pr: ListView, aX_Rv2r3zl64bse_TtLkBCkPmZVPntV1 cQqcU2pUuStIe12WrtXBElURTRST76oH: Cell, ST3_hFY0A5aH_nNsVizEw2fa9a3mQ63S oQjz6vZZyuWQwYSoDjtiW4_wlhShoRWZ: Object, SeusQnNJziihWFkiyjJ0Va6uvjd1diPY Z6OVGGyuSfXk_2aC4kXHkI_Za6eq8Rfg: IndexPath)
}

// --

protocol oOqKdMkAw941UYBKqtzdGnTpGIrjsUJz: ZzToPnlnDFg8jzFTd4GddvjqomKImZhw {
    var eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9: [[Object]] { get }
}

extension oOqKdMkAw941UYBKqtzdGnTpGIrjsUJz {
    var YpCa0Nzi6V_vZHVFGVIfisx8gfBKCZWu: Int {
        return eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9.count
    }
    
    func cBcN7THZkaeigEy3GlLBpa0Y_P1brkj1(_ Dto2qVxI1aU4MsXWm5NXsym9Rq8IRiBL: Int) -> Int {
        return eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9[Dto2qVxI1aU4MsXWm5NXsym9Rq8IRiBL].count
    }
    
    func XHCEmskc3nc8WdGrLFn262l6F6Dnhdce(_ y5RNDWrRUhmOtJn09W4Bcahim4GURxcT: IndexPath) -> Object? {
        guard C7SW9C6Dy84kVIQ5LUcvV3RKJWda1QOx(y5RNDWrRUhmOtJn09W4Bcahim4GURxcT) else {
            return nil
        }
        return eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9[(y5RNDWrRUhmOtJn09W4Bcahim4GURxcT as NSIndexPath).section][(y5RNDWrRUhmOtJn09W4Bcahim4GURxcT as NSIndexPath).row]
    }
    
    func C7SW9C6Dy84kVIQ5LUcvV3RKJWda1QOx(_ kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM: IndexPath) -> Bool {
        guard (kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM as NSIndexPath).section >= 0 && (kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM as NSIndexPath).section < eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9.count else {
            return false
        }
        return (kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM as NSIndexPath).row >= 0 && (kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM as NSIndexPath).row < eKLc0NmTO8xkOxfGYUg5o8MqMo19sQt9[(kJxDg0uplhpcxETNg_0t4W0YE1C3rAsM as NSIndexPath).section].count
    }
}

// --

protocol trHtIBud3vUAoe8fSUJs1wWKWcD_XuEt: oOqKdMkAw941UYBKqtzdGnTpGIrjsUJz { }

extension trHtIBud3vUAoe8fSUJs1wWKWcD_XuEt where ListView == UITableView {
    
    func AMKLuDuYysuVMAW2rwNTBMg9rv01ehoa(_ ujqr06uQ_PTYtqcgPZYB3GYX7CcTekLT: UITableView, tafFuvyqL1RDX6w357PYTeBnB54EJvmq: IndexPath) -> Cell {
        let identifier = CmL83CjitWUSc4Gbbn6iduvkBknk7Weg(tafFuvyqL1RDX6w357PYTeBnB54EJvmq)
        let cell = ujqr06uQ_PTYtqcgPZYB3GYX7CcTekLT.dequeueReusableCell(withIdentifier: identifier, for: tafFuvyqL1RDX6w357PYTeBnB54EJvmq) as! Cell
        
        if let object = XHCEmskc3nc8WdGrLFn262l6F6Dnhdce(tafFuvyqL1RDX6w357PYTeBnB54EJvmq) {
            Y5CEbIk4WvTFFIDo77JDXxpm7hlynQqx(ujqr06uQ_PTYtqcgPZYB3GYX7CcTekLT, aX_Rv2r3zl64bse_TtLkBCkPmZVPntV1: cell, ST3_hFY0A5aH_nNsVizEw2fa9a3mQ63S: object, SeusQnNJziihWFkiyjJ0Va6uvjd1diPY: tafFuvyqL1RDX6w357PYTeBnB54EJvmq)
        }
        
        return cell
    }
}

// --

final class VbdganQ2LYLjSk37z8XGtvVtJja2eT4I<T>: NSObject, UITableViewDataSource where T: AnyObject, T: trHtIBud3vUAoe8fSUJs1wWKWcD_XuEt, T.ListView == UITableView {
    unowned let COA2kmXG3cEyB5UET5lyuSF3vCEwvR_P: T
    
    init(nxES96GloIWyO8MGy_UPML2IhaGhpiky: T) {
        self.COA2kmXG3cEyB5UET5lyuSF3vCEwvR_P = nxES96GloIWyO8MGy_UPML2IhaGhpiky
    }
    
    func numberOfSections(in XL8pXTxsm8rbrGskdB2yObquYEoUAW3u: UITableView) -> Int {
        return COA2kmXG3cEyB5UET5lyuSF3vCEwvR_P.YpCa0Nzi6V_vZHVFGVIfisx8gfBKCZWu
    }
    
    func tableView(_ ecTsGYb9parUagawwGiI918_oaNiKzp3: UITableView, numberOfRowsInSection K6ton1roknb83ZUXQ2AMgsQGhzSd2dyL: Int) -> Int {
        return COA2kmXG3cEyB5UET5lyuSF3vCEwvR_P.cBcN7THZkaeigEy3GlLBpa0Y_P1brkj1(K6ton1roknb83ZUXQ2AMgsQGhzSd2dyL)
    }
    
    func tableView(_ nzDxjjrjhHcA2w0KWRbokQmnj0F1xOdH: UITableView, cellForRowAt equ65WZ5k0qpiSPuvMaRLy6797fYsuwO: IndexPath) -> UITableViewCell {
        return COA2kmXG3cEyB5UET5lyuSF3vCEwvR_P.AMKLuDuYysuVMAW2rwNTBMg9rv01ehoa(nzDxjjrjhHcA2w0KWRbokQmnj0F1xOdH, tafFuvyqL1RDX6w357PYTeBnB54EJvmq: equ65WZ5k0qpiSPuvMaRLy6797fYsuwO) as! UITableViewCell
    }
}

protocol X3QzfSWF7FXrJis8XrEqtXrsIKULjTwH {
    func gwTV0VhuSezxUv2O76TjK169SGXRWAcD(_ DdVEVteC8HX1EBUVwqK4fqLlUSLI3TAs: UITableView)
}
