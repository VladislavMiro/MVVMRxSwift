import UIKit

protocol DetailViewCoordinatorProtocol: CoordinatorProtocol {
    func finishDetailView()
    func showEditView(data: Contact)
    func finishEdit(data: Contact)
}
