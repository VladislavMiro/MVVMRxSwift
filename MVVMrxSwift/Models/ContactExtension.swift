//
//  ContactExtension.swift
//  MVVMrxSwift
//
//  Created by Vladislav Miroshnichenko on 21.06.2022.
//

import Foundation
import RxDataSources

extension Contact: IdentifiableType {
    public typealias Identity = String
    public var identity: Identity { return uuid?.uuidString ?? "" }
}
