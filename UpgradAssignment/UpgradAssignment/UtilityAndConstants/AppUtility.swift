//
//  AppUtility.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import Foundation
import Reachability

class AppUtility {
    static let sharedInstance = AppUtility()
    var reachability: Reachability?
}


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
