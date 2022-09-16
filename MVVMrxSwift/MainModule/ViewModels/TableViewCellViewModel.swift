//
//  TableViewCellViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 19.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class TableViewCellViewModel: TableViewCellViewModelProtocol {
    
    private(set) var fullName: BehaviorRelay<String>
    
    required init(name: String, lastName: String) {
        fullName = .init(value: name + " " + lastName)
    }
    
}
