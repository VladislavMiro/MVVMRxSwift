import UIKit

final class EditViewCoordinator: NSObject, EditViewCoordinatorProtocol {
    
    private(set) var navigationController: UINavigationController?
    private(set) var child: [CoordinatorProtocol] = []
  
    private var parentCoordinator: DetailViewCoordinatorProtocol
    private var data: Contact
    
    init(parentCoordinator: DetailViewCoordinatorProtocol, data: Contact) {
        self.parentCoordinator = parentCoordinator
        self.data = data

        navigationController = parentCoordinator.navigationController
    }
    
    public func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "EditVIew") as? EditViewController else { return }
        let sotorageService = StorageService.shared

        view.viewModel = EditViewViewModel(contact: data, storageService: sotorageService, coordinator: self)
        
        navigationController?.delegate = self
        navigationController?.pushViewController(view, animated: true)
    }
    
    public func finishEditView(data: Contact) {
        parentCoordinator.finishEdit(data: data)
        self.navigationController?.popViewController(animated: true)
    }
    
    public func removeChild(coordinator: CoordinatorProtocol) {
        guard let index = child.firstIndex(where: { $0 === coordinator }) else { return }
        child.remove(at: index)
    }
    
}

extension EditViewCoordinator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) { return }
        
        if fromVC is EditViewController {
            parentCoordinator.removeChild(coordinator: self)
        }
    }
    
}
