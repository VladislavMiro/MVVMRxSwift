import Foundation
import RxSwift
import RxCocoa

final class MainViewViewModel {
    
    public var contacts: BehaviorRelay<[SectionModel]>
    
    private var storageService: StorageServiceProtocol
    private weak var coordinator: MainCoordinatorProtocol?
    private let disposeBag = DisposeBag()
    
    init(storageService: StorageServiceProtocol, coordinator: MainCoordinatorProtocol) {
        self.storageService = storageService
        self.coordinator = coordinator
        contacts = .init(value: [SectionModel(header: "", items: [])])
    }

}

extension MainViewViewModel: MainViewViewModelProtocol {
        
    @discardableResult public func preloadDataFromStorage() -> Completable {
        let result = storageService.fetchAllData(entityName: "Contact")
        
        if let error = result.error {
            return Completable.create { completable in
                completable(.error(error))
                return Disposables.create()
            }
        } else {
            guard let data = result.data as? [Contact] else {
                return Completable.create { completable in
                    completable(.error(CoreDataErrors.DataError))
                    return Disposables.create()
                }
            }
            
            let section = SectionModel(header: "", items: data)
        
            contacts.accept([section])
            
            return Completable.create { completable in
                completable(.completed)
                return Disposables.create()
            }
        }
    }
    
    public func fetchData(with predicate: String) {
        let predicate = NSPredicate(format: "lastName   CONTAINS[c] %@", predicate)
        var section = contacts.value[0]
        let response = storageService.fetchData(entityName: "Contact", withPredicate: predicate)
        
        if let data = response.data as? [Contact] {
            section.items = data
            contacts.accept([section])
        } else {
            section.items = []
            contacts.accept([section])
        }
    }

    public func deleteData(atIndex index: Int) -> Completable {
        var section = contacts.value[0]
        
        if storageService.deleteData(entity: section.items[index]) {
            section.items.remove(at: index)
            contacts.accept([section])
            return Completable.create { completable in
                completable(.completed)
                return Disposables.create()
            }
        } else {
            return Completable.create { completable in
                completable(.error(CoreDataErrors.DeletingEroor))
                return Disposables.create()
            }
        }
    }
    
    public func openAddContactView() {
        coordinator?.showAddContactView()
    }
    
    public func didSelectRow(data: Contact) {
        coordinator?.showDetailView(data: data)
    }
    
}
