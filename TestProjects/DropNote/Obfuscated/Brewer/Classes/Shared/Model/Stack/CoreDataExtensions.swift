//
// Created by Maciej Oczko on 16.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

protocol JIYMScaUYtWOwxrqigfwVzlyftw3yezf {
    static func kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS() -> String
}

struct UKhmSld8V2hEARR7qC_pdjMTeOm4HmAl<T> where T: NSManagedObject, T: JIYMScaUYtWOwxrqigfwVzlyftw3yezf {
    let WYkThth3V961PzZLffABg77SUj89khBd: NSManagedObjectContext

    init(FIPojejqJdQs2Vt3Ynx5wqB7tV0mTrCY TzxpgRBU3WOOSOJ1nSSvgxocfh6nyfzQ: NSManagedObjectContext) {
        self.WYkThth3V961PzZLffABg77SUj89khBd = TzxpgRBU3WOOSOJ1nSSvgxocfh6nyfzQ
    }

    func AjTgfBkYqZMt3g5OxRpNiAo6JJU5Qt58() -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS(), into: WYkThth3V961PzZLffABg77SUj89khBd) as! T
    }
    
    func yva2yIIgH9kWOW1qDUQJHM2Tcik42XpQ(DN_g_vEN94SMj847h6A5kabmSrTLbEJT S3IvQMymc4zc9WrlO7aNcqjA2p0mxuAS: NSPredicate? = nil, WYOve5KdH3yWbwTzPPR3zYR0th83OryH: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.kiP0LT8ZEQiRcS3ZjoViSQTJwbjg0NkS())
        fetchRequest.predicate = S3IvQMymc4zc9WrlO7aNcqjA2p0mxuAS
        fetchRequest.sortDescriptors = WYOve5KdH3yWbwTzPPR3zYR0th83OryH
        return try WYkThth3V961PzZLffABg77SUj89khBd.fetch(fetchRequest)
    }

    func C8MbBUS88Uyuknu_kWv5_U2tgr8j4zZz() throws {
        try WYkThth3V961PzZLffABg77SUj89khBd.save()
    }
    
    func o1i8qOqxKWeD2jkb0KCrX6BiC5pZbPZF(_ YR6dh05vkxZlRYw6NULoVCZ_3ACCpbIE: NSManagedObjectID) -> T? {
        return WYkThth3V961PzZLffABg77SUj89khBd.registeredObject(for: YR6dh05vkxZlRYw6NULoVCZ_3ACCpbIE) as? T
    }
}
