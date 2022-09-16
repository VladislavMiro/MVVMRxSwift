//
//  DetailViewViewModel.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewViewModel: DetailViewViewModelProtocol {

    private(set) var contact: BehaviorRelay<Contact>
    
    public weak var coordinator: DetailViewCoordinatorProtocol?
    
    init(coordinator: DetailViewCoordinatorProtocol, contact: Contact) {
        self.coordinator = coordinator
        self.contact = .init(value: contact)
    }
    
    public func finishDetailView() {
        coordinator?.finishDetailView()
    }
    
    public func openEditView() {
        coordinator?.showEditView(data: contact.value)
    }
    
    public func changeData(data: Contact) {
        
    }
    
}
