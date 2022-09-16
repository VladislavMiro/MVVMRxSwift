//
//  DetailViewModelProtocol.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailViewViewModelProtocol {
    var contact: BehaviorRelay<Contact> { get }
    
    func finishDetailView()
    func openEditView()
}
