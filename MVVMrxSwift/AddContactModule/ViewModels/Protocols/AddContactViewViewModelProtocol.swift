//
//  AddContactViewViewModelProtocol.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift

protocol AddContactViewViewModelProtocol {
    
    func saveContact() -> Completable
    func dismiss()
}
