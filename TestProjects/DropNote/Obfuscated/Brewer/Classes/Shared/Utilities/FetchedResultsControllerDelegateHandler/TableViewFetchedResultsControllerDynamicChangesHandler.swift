//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import XCGLogger

// swiftlint:disable type_name
final class NyZ2FGOfTA_0BLbXryqHV9mIP26dJpui<ResultType: NSManagedObject>
// swiftlint:enable type_name    
    : NSObject
    , NSFetchedResultsControllerDelegate {
    
    fileprivate(set) unowned var Z_QVn7WI_krx_CemwuvrUi3baeakANDn: UITableView
    unowned fileprivate let qOIOBB7dRpfyjy8OtUJB_8U8f9L2qApf: NSFetchedResultsController<ResultType>
    var eXs12Jvs4jvZqEDSdjljlMsUXRE8oTTI: UITableViewRowAnimation = .none

    var d3P5R5_r9aztVvm5O_Lfj3EAdk4I1Eqo: [AnyObject] {
        return qOIOBB7dRpfyjy8OtUJB_8U8f9L2qApf.fetchedObjects ?? []
    }

    var r7t2Hv9EiuDFPIpxdxUTshxwMcJHWJnQ: (() -> Void)?

    init(SjFCiOYJvoGc3aPGQw9ulwEyXnNYTC4S: UITableView, Ji10BZMRHQ4MspckH7YQ59uxotT4su2k: NSFetchedResultsController<ResultType>, R63f21aTKcwfxEAsMJDzJA50DvQIg9R5: (() -> Void)? = nil) {
        self.qOIOBB7dRpfyjy8OtUJB_8U8f9L2qApf = Ji10BZMRHQ4MspckH7YQ59uxotT4su2k
        self.Z_QVn7WI_krx_CemwuvrUi3baeakANDn = SjFCiOYJvoGc3aPGQw9ulwEyXnNYTC4S
        self.r7t2Hv9EiuDFPIpxdxUTshxwMcJHWJnQ = R63f21aTKcwfxEAsMJDzJA50DvQIg9R5
        super.init()
        mzVtpR_SMVFsikMcyOyvjcY2xrdD138O()
    }

    fileprivate func mzVtpR_SMVFsikMcyOyvjcY2xrdD138O() {
        qOIOBB7dRpfyjy8OtUJB_8U8f9L2qApf.delegate = self
        If86i3Bw84HwRusyWONxxfmWHN4CDiNr()
        if let updateCompletion = r7t2Hv9EiuDFPIpxdxUTshxwMcJHWJnQ {
            updateCompletion()
        }
    }

    func If86i3Bw84HwRusyWONxxfmWHN4CDiNr() {
        do {
            try qOIOBB7dRpfyjy8OtUJB_8U8f9L2qApf.performFetch()
            Z_QVn7WI_krx_CemwuvrUi3baeakANDn.reloadData()
        } catch {
            switch error {
            case let error as NSError:
                XCGLogger.error("Error performing fetch = \((error as NSError).localizedDescription)")
                break
            default:
                break
            }
        }
    }

    // MARK: NSFetchedResultsControllerDelegate

    @objc func controllerDidChangeContent(_ LnFue6WQ1n98hoUyXaZ3gD8akXOxKa95: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updateCompletion = r7t2Hv9EiuDFPIpxdxUTshxwMcJHWJnQ {
            updateCompletion()
        }
    }
}
