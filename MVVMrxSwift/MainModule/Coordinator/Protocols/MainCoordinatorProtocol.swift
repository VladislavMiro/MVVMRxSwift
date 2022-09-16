import Foundation

protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func showAddContactView()
    func showDetailView(data: Contact)
    func updateData()
    func finishDetailView(coordinator: CoordinatorProtocol)
}
