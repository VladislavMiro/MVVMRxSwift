//
//  EditViewViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditViewViewModelProtocol {
    var name: BehaviorRelay<String> { get }
    var lastName: BehaviorRelay<String> { get }
    var phoneNumber: BehaviorRelay<String> { get }
    var birthday: BehaviorRelay<Date> { get }
    var contact: BehaviorRelay<Contact> { get }
    
    func saveData() -> Completable
    func finishEdit()
}
