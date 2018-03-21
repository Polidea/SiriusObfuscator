//
// Created by Maciej Oczko on 05.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4 {
    func jt7FupVOYUx4T3Anf4JKeezo4kDQXF2Z(VhomefX5UrH8Nx2xfhMiOCtQVGm38T4c leIiaAMVylmBnGspWFFUCOh3Ipol93pY: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei) -> Observable<Brew>
    func eKZ1TKOEFXe_p51hs_IUcp8jFV60zLkM(oz5Pf9wBr9mejrX_o1KnRAtPApYH1dCQ a6Zl1xbItgv4eDVqvxFsrP5tVweufrtE: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei, F5jqS5ywcGHsGlxq9lHyG2RX0FnCU_op: Coffee?, P8xeMXRX7T3C_z3r0_RTV9cjjPmXn6U7: CoffeeMachine?) -> Observable<Brew>
    
    func pc7RokByJs6TFwuLjYDLJqRDi3yyP_so(US2U7U2zqwFKLBrfqx3NQIq7158C0Xdl mZdCneYZI1wqEXEzszTjspF7XjPkdJ5K: Dvzdce97fie2QBNN2QeyAMRncrQUlOcu) -> Observable<BrewAttribute>
    func VPXwgp9nWfsBRXGR06eTZISB91jigODw() -> Brew?
    func BoE6lq1sjHDPoMAeub_28mzFT5SFljKo() -> Observable<Bool>
    func jJoC9t7KPRRlMC6e1cY4pnpY1gichBCM() -> Observable<Bool>
    func r6_Rx5gZbaICMWjStCciLmCzGUe2KrmL() -> Observable<()>
}

final class UBZv4in1kU68M7Heg9g13jYLv42wKF_d: Ba7sD4TLxwMEGLuxsW1pPHa82M4j2TL4 {
    let YDKbl10SMJNjYyu3kSqySOm7HxLaLflc: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG
    fileprivate var TP63Je_3n6pZGzDJ_U573VmtevSZYy8_: Brew?

    init(lIWnqCAcwG3Boo3i5Zd5B8BGr7WoNC0T: FiPo5WjIle8_QlTDYzuos59EOIfdXKGG, SsddQaS5ga4IDp75i9wDODW7EqYX0gtx: Brew? = nil) {
        self.YDKbl10SMJNjYyu3kSqySOm7HxLaLflc = lIWnqCAcwG3Boo3i5Zd5B8BGr7WoNC0T
        self.TP63Je_3n6pZGzDJ_U573VmtevSZYy8_ = SsddQaS5ga4IDp75i9wDODW7EqYX0gtx
    }

    func jt7FupVOYUx4T3Anf4JKeezo4kDQXF2Z(VhomefX5UrH8Nx2xfhMiOCtQVGm38T4c leIiaAMVylmBnGspWFFUCOh3Ipol93pY: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei) -> Observable<Brew> {
        return eKZ1TKOEFXe_p51hs_IUcp8jFV60zLkM(oz5Pf9wBr9mejrX_o1KnRAtPApYH1dCQ: leIiaAMVylmBnGspWFFUCOh3Ipol93pY, F5jqS5ywcGHsGlxq9lHyG2RX0FnCU_op: nil, P8xeMXRX7T3C_z3r0_RTV9cjjPmXn6U7: nil)
    }
    
    func eKZ1TKOEFXe_p51hs_IUcp8jFV60zLkM(oz5Pf9wBr9mejrX_o1KnRAtPApYH1dCQ a6Zl1xbItgv4eDVqvxFsrP5tVweufrtE: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei, F5jqS5ywcGHsGlxq9lHyG2RX0FnCU_op: Coffee?, P8xeMXRX7T3C_z3r0_RTV9cjjPmXn6U7: CoffeeMachine?) -> Observable<Brew> {
        let coffeeID = F5jqS5ywcGHsGlxq9lHyG2RX0FnCU_op?.objectID
        let coffeeMachineID = P8xeMXRX7T3C_z3r0_RTV9cjjPmXn6U7?.objectID
		return Observable.create {
			[weak self] observer in
			self?.YDKbl10SMJNjYyu3kSqySOm7HxLaLflc.ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5 {
				context in
				let operations = UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<Brew>(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY: context)
				do {
					let predicate = NSPredicate(format: "method == %d AND isFinished == NO", a6Zl1xbItgv4eDVqvxFsrP5tVweufrtE.intValue)
					let brews = try operations.yva2yIIgH9kWOW1qDUQJHM2Tcik42XpQ(DN_g_vEN94SMj847h6A5kabmSrTLbEJT: predicate)

					if let brew = brews.last {
						observer.onNext(brew)
						observer.onCompleted()
					} else {
						let brew = operations.AjTgfBkYqZMt3g5OxRpNiAo6JJU5Qt58()
                        self?.pyJBxffBiVd719ZNvc0WJJTQQg2xIjYo(brew, UpUWGOMpXociQI3M4osaOyrgjnICOZy7: a6Zl1xbItgv4eDVqvxFsrP5tVweufrtE)
						self?.kgeKmA3AaRzt63PQejdtmgXzy9kVeM1N(brew, LtPqjlN6T8UYxOMHXSWsd0di6X6vltQr: coffeeID, PeN6gwJABqxjtQtkJOWDXCUX5lS8zLTL: context)
                        self?.YRgTKO1Vn2Fgdn9quZZjl9HDR3tlDnx3(brew, jxjT6euvxtyrnbQE9LhcRTgVwbGbKVU1: coffeeMachineID, BzKcDdo40b5txDwKBdKxMQTrvQwP_jxB: context)
                        self?.uUr05RlWer7qIRYdixjssSa2v4zRZbZm(brew, Vpk8yOKhvF3xyEvxhAsp1Sac3K970lTA: context)
						do {
							try operations.C8MbBUS88Uyuknu_kWv5_U2tgr8j4zZz()
							observer.onNext(brew)
							observer.onCompleted()
						} catch {
							observer.onError(error)
						}
					}
				} catch {
					observer.onError(error)
				}
			}
			return Disposables.create()
		}
			.do(onNext: {
				brew in self.TP63Je_3n6pZGzDJ_U573VmtevSZYy8_ = brew
		})
	}
    
    fileprivate func pyJBxffBiVd719ZNvc0WJJTQQg2xIjYo(_ bcXsaQoRXwG8HBPdHV2ZHNQ91G5DNS9z: Brew, UpUWGOMpXociQI3M4osaOyrgjnICOZy7 y8R6BCDapK_aQtm1shScxGGJuMss7RwF: f4xCOAkIYquRpf3SNFCvwNaK22YKw8ei) {
        bcXsaQoRXwG8HBPdHV2ZHNQ91G5DNS9z.created = Date.timeIntervalSinceReferenceDate
        bcXsaQoRXwG8HBPdHV2ZHNQ91G5DNS9z.method = y8R6BCDapK_aQtm1shScxGGJuMss7RwF.intValue
        bcXsaQoRXwG8HBPdHV2ZHNQ91G5DNS9z.isFinished = false
    }
    
    fileprivate func kgeKmA3AaRzt63PQejdtmgXzy9kVeM1N(_ G2mXd9fx9ZqfMd57jnzt6KKIMe0WsOnY: Brew, LtPqjlN6T8UYxOMHXSWsd0di6X6vltQr RNCLj7gAivcaMsQLmCEfu6Q10nHm9uid: NSManagedObjectID?, PeN6gwJABqxjtQtkJOWDXCUX5lS8zLTL fIltpaUbejkmxrxjOJtGgbW_T4rmNDib: NSManagedObjectContext) {
        if let id = RNCLj7gAivcaMsQLmCEfu6Q10nHm9uid {
            let safeCoffee = fIltpaUbejkmxrxjOJtGgbW_T4rmNDib.object(with: id) as! Coffee
            G2mXd9fx9ZqfMd57jnzt6KKIMe0WsOnY.coffee = safeCoffee
        }
    }
    
    fileprivate func YRgTKO1Vn2Fgdn9quZZjl9HDR3tlDnx3(_ dZhqadIVeTlQWxJcOoxdN14TlDsOoYtM: Brew, jxjT6euvxtyrnbQE9LhcRTgVwbGbKVU1 ocEoknoLg_XLT3jl4zkg0pfE9qnUs9pG: NSManagedObjectID?, BzKcDdo40b5txDwKBdKxMQTrvQwP_jxB DaMMEGx0QUMLhtzPWeEaZHgz3ETZRATb: NSManagedObjectContext) {
        if let id = ocEoknoLg_XLT3jl4zkg0pfE9qnUs9pG {
            let safeCoffeeMachine = DaMMEGx0QUMLhtzPWeEaZHgz3ETZRATb.object(with: id) as! CoffeeMachine
            dZhqadIVeTlQWxJcOoxdN14TlDsOoYtM.coffeeMachine = safeCoffeeMachine
        }
    }
    
    fileprivate func uUr05RlWer7qIRYdixjssSa2v4zRZbZm(_ rfaUcX42w1WI2LLRC58gUlWHgcUClkM1: Brew, Vpk8yOKhvF3xyEvxhAsp1Sac3K970lTA WVGX5esoqCBfJSZC0yPauAf3AOWUTc9z: NSManagedObjectContext) {
        let cuppingOperations = UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<Cupping>(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY: WVGX5esoqCBfJSZC0yPauAf3AOWUTc9z)
        for cuppingAttribute in vrYgz8ae2jdaPI26N_gsmzoxFTBAI3Ze.MZ5qZ2sUdhe7B7ZckEUKczPCWSTRm1QJ {
            let cupping = cuppingOperations.AjTgfBkYqZMt3g5OxRpNiAo6JJU5Qt58()
            cupping.brew = rfaUcX42w1WI2LLRC58gUlWHgcUClkM1
            cupping.type = cuppingAttribute.rawValue
            cupping.value = 0
        }
    }

    func pc7RokByJs6TFwuLjYDLJqRDi3yyP_so(US2U7U2zqwFKLBrfqx3NQIq7158C0Xdl mZdCneYZI1wqEXEzszTjspF7XjPkdJ5K: Dvzdce97fie2QBNN2QeyAMRncrQUlOcu) -> Observable<BrewAttribute> {
        if let attribute = TP63Je_3n6pZGzDJ_U573VmtevSZYy8_?.CIT4NIIpB4gskA2aF8IT74ou_B7fMd_A(mZdCneYZI1wqEXEzszTjspF7XjPkdJ5K) {
            return .just(attribute)
        }
        return Observable.create {
            [weak self] observer in
            self?.YDKbl10SMJNjYyu3kSqySOm7HxLaLflc.ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5 {
                context in
                let operations = UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<BrewAttribute>(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY: context)
                let attribute = operations.AjTgfBkYqZMt3g5OxRpNiAo6JJU5Qt58()
                attribute.type = mZdCneYZI1wqEXEzszTjspF7XjPkdJ5K.intValue
                observer.onNext(attribute)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func r6_Rx5gZbaICMWjStCciLmCzGUe2KrmL() -> Observable<()> {
        VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.coffee?.updatedAt = Date.timeIntervalSinceReferenceDate
        VPXwgp9nWfsBRXGR06eTZISB91jigODw()?.coffeeMachine?.updatedAt = Date.timeIntervalSinceReferenceDate        
        return YDKbl10SMJNjYyu3kSqySOm7HxLaLflc.vCoa_A_kB6HG5sbtNTRfwTHOEWKLR9Z7().map { _ in }
    }

    func VPXwgp9nWfsBRXGR06eTZISB91jigODw() -> Brew? {
        return TP63Je_3n6pZGzDJ_U573VmtevSZYy8_
    }
    
    func BoE6lq1sjHDPoMAeub_28mzFT5SFljKo() -> Observable<Bool> {
        return a28aJmsrztEJzkjgxsNyuzep7kCHLURL(VPXwgp9nWfsBRXGR06eTZISB91jigODw())
    }

    func jJoC9t7KPRRlMC6e1cY4pnpY1gichBCM() -> Observable<Bool> {
        return Observable<Brew?>.create {
            [weak self] observer in
            self?.YDKbl10SMJNjYyu3kSqySOm7HxLaLflc.ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5 {
                context in
                do {
                    let operations = UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<Brew>(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY: context)
                    let predicate = NSPredicate(format: "isFinished == NO")
                    let brews = try operations.yva2yIIgH9kWOW1qDUQJHM2Tcik42XpQ(DN_g_vEN94SMj847h6A5kabmSrTLbEJT: predicate)
                    observer.onNext(brews.last)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .flatMap(a28aJmsrztEJzkjgxsNyuzep7kCHLURL)
    }
    
    fileprivate func a28aJmsrztEJzkjgxsNyuzep7kCHLURL(_ PhQzOJTl0mMYxfXcywfV2L6MkEh43D8D: Brew?) -> Observable<Bool> {
        guard let brew = PhQzOJTl0mMYxfXcywfV2L6MkEh43D8D else { return .just(false) }
        let brewID = brew.objectID
        return Observable.create {
            [weak self] observer in
            self?.YDKbl10SMJNjYyu3kSqySOm7HxLaLflc.ih9sIR2YfBvFqhgKqn1LJL7aRGWJ8kE5 {
                context in
                do {
                    let operations = UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<Brew>(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY: context)
                    let brew = operations.o1i8qOqxKWeD2jkb0KCrX6BiC5pZbPZF(brewID)
                    
                    if let brew = brew {
                        context.delete(brew)
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                    
                    try operations.C8MbBUS88Uyuknu_kWv5_U2tgr8j4zZz()
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
