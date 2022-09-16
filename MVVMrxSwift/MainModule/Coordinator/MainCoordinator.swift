import UIKit

final class MainCoordinator: MainCoordinatorProtocol {
        
    private(set) var navigationController: UINavigationController?
    private(set) var child: [CoordinatorProtocol] = []
    private var viewModel: MainViewViewModelProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(identifier: "MainView") as? MainViewController else { fatalError("Main view has not opened") }
        view.viewModel = MainViewViewModel(storageService: StorageService.shared, coordinator: self)
        viewModel = view.viewModel
        
        navigationController?.pushViewController(view, animated: false)
    }
    
    public func showAddContactView() {
        let coordinator = AddContactCoordinator(parentCoordinator: self)
        child.append(coordinator)
        coordinator.start()
    }
    
    public func updateData() {
        viewModel?.preloadDataFromStorage()
    }
    
    public func showDetailView(data: Contact) {
        let coordinator = DetailViewCoordinator(parentCoordinator: self, data: data)
        child.append(coordinator)
        coordinator.start()
    }
    
    public func finishDetailView(coordinator: CoordinatorProtocol) {
        viewModel?.preloadDataFromStorage()
        removeChild(coordinator: coordinator)
    }
    
    public func removeChild(coordinator: CoordinatorProtocol) {
        guard let index = child.firstIndex(where: { $0 === coordinator }) else { return }
        child.remove(at: index)
    }
    
}
