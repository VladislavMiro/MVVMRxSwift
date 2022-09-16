import UIKit

final class AddContactCoordinator: NSObject {
    
    public var navigationController: UINavigationController?
    public var child: [CoordinatorProtocol] = []
    private var parentCoordinator: MainCoordinator
    
    init(parentCoordinator: MainCoordinator) {
        self.parentCoordinator = parentCoordinator
        navigationController = parentCoordinator.navigationController
    }
    
}

extension AddContactCoordinator: AddContactCoordinatorProtocol {
    
    public func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(identifier: "AddContactView") as? AddContactViewController else { return }
        view.viewModel = AddContactViewModel(storageService: StorageService.shared, coordinator: self)
        navigationController?.delegate = self
        navigationController?.pushViewController(view, animated: true)
    }
    
    public func finishAddContact() {
        navigationController?.popViewController(animated: true)
        parentCoordinator.updateData()
    }
    
    public func removeChild(coordinator: CoordinatorProtocol) {
        guard let index = child.firstIndex(where: { $0 === coordinator }) else { return }
        child.remove(at: index)
    }
    
}

extension AddContactCoordinator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) { return }
        
        if fromVC is AddContactViewController {
            parentCoordinator.removeChild(coordinator: self)
        }
    }
    
}
