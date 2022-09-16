import Foundation
import RxSwift
import RxCocoa

protocol MainViewViewModelProtocol {
    var contacts: BehaviorRelay<[SectionModel]> { get }
    
    @discardableResult func preloadDataFromStorage() -> Completable
    func fetchData(with predicate: String)
    func deleteData(atIndex index: Int) -> Completable
    func openAddContactView()
    func didSelectRow(data: Contact)
}
