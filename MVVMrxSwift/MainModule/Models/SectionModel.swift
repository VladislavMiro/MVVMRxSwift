//
//  SectionModel.swift
//  MVVMrxSwift
//
//  Created by Vladislav Miroshnichenko on 23.06.2022.
//

import Foundation
import RxDataSources

struct SectionModel {
    public var header: String
    public var items: [Contact]
}

extension SectionModel: AnimatableSectionModelType {
    
    public var identity: String {
        return header
    }
    
    init(original: SectionModel, items: [Contact]) {
        self = original
        self.items = items
    }
    
}
