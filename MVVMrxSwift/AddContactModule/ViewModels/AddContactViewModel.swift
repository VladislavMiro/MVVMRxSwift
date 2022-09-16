//
//  AddContactViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 19.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class AddContactViewModel {
    
    private(set) var name = BehaviorRelay<String>(value: "")
    private(set) var lastName = BehaviorRelay<String>(value: "")
    private(set) var phoneNumber = BehaviorRelay<String>(value: "")
    private(set) var birthday = BehaviorRelay<Date>(value: Date())
    
    private weak var coordinator: AddContactCoordinator?
    private var storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol, coordinator: AddContactCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
    }
    
}

extension AddContactViewModel: AddContactViewViewModelProtocol {
    
    public func saveContact() -> Completable {
        let contact = storageService.createNewEntity(forEntityName: "Contact") as! Contact
        
        contact.uuid = UUID()
        contact.name = name.value
        contact.lastName = lastName.value
        contact.phoneNumber = phoneNumber.value
        contact.dateOfBirth = birthday.value
        
        if storageService.saveContext() {
            
            return Completable.create { completable in
                completable(.completed)
                return Disposables.create()
            }
        } else {
            
            return Completable.create { completable in
                completable(.error(CoreDataErrors.DataError))
                return Disposables.create()
            }
        }
    }
    
    public func dismiss() {
        coordinator?.finishAddContact()
    }
    
}
