//
//  TabelViewCellViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol TableViewCellViewModelProtocol {
    var fullName: BehaviorRelay<String> { get }
}
