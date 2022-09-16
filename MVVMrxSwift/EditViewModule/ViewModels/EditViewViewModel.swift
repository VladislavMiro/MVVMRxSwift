//
//  EditViewViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class EditViewViewModel {
    
    private var storageService: StorageServiceProtocol
    private weak var coordinator: EditViewCoordinatorProtocol?
    
    private(set) var contact: BehaviorRelay<Contact>
    private(set) var name: BehaviorRelay<String>
    private(set) var lastName: BehaviorRelay<String>
    private(set) var phoneNumber: BehaviorRelay<String>
    private(set) var birthday: BehaviorRelay<Date>
    
    init(contact: Contact, storageService: StorageServiceProtocol, coordinator: EditViewCoordinatorProtocol) {
        self.contact = .init(value: contact)
        self.storageService = storageService
        self.coordinator = coordinator
        
        name = .init(value: contact.name ?? "")
        lastName = .init(value: contact.lastName ?? "")
        phoneNumber = .init(value: contact.phoneNumber ?? "")
        birthday = .init(value: contact.dateOfBirth ?? Date())
    }
    
}

extension EditViewViewModel: EditViewViewModelProtocol {
    
    public func saveData() -> Completable {
        
        contact.value.name = name.value
        contact.value.lastName = lastName.value
        contact.value.phoneNumber = phoneNumber.value
        contact.value.dateOfBirth = birthday.value
        
        var keys = [String]()
        
        for (key, _) in contact.value.changedValues() {
            keys.append(key)
        }
        
        let oldData = contact.value.committedValues(forKeys: keys)
        
        if storageService.saveContext() {
            contact.accept(contact.value)
            return Completable.create { [unowned self] completable in
                completable(.completed)
                self.coordinator?.finishEditView(data: self.contact.value)
                return Disposables.create()
            }
        } else {
            contact.value.setValuesForKeys(oldData)
            
            return Completable.create { completable in
                completable(.error(CoreDataErrors.DeletingEroor))
                return Disposables.create()
            }
        }
    }
    
    public func finishEdit() {
    
    }
    
}
