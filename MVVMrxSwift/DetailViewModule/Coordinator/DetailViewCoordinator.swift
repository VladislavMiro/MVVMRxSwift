import UIKit
import RxSwift
import RxCocoa

final class DetailViewCoordinator: NSObject, DetailViewCoordinatorProtocol {
    
    private(set) var navigationController: UINavigationController?
    private(set) var child: [CoordinatorProtocol] = []
    
    private var data: BehaviorRelay<Contact>
    private let parentCoordinator: MainCoordinatorProtocol
    private let diposeBag = DisposeBag()
    
    init(parentCoordinator: MainCoordinatorProtocol, data: Contact) {
        self.data = .init(value: data)
        self.parentCoordinator = parentCoordinator
        navigationController = parentCoordinator.navigationController
    }
    
    public func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else { return }
        view.viewModel = DetailViewViewModel(coordinator: self, contact: data.value)
        navigationController?.delegate = self
        navigationController?.pushViewController(view, animated: true)
        data.subscribe { data in
            view.viewModel.contact.accept(data)
        }.disposed(by: diposeBag)
    }
    
    public func finishDetailView() {
        parentCoordinator.finishDetailView(coordinator: self)
    }
    
    public func showEditView(data: Contact) {
        let coordinator = EditViewCoordinator(parentCoordinator: self, data: data)
        child.append(coordinator)
        coordinator.start()
    }
    
    public func finishEdit(data: Contact) {
        self.data.accept(data)
        parentCoordinator.updateData()
    }
    
    public func removeChild(coordinator: CoordinatorProtocol) {
        guard let index = child.firstIndex(where: { $0 === coordinator }) else { return }
        child.remove(at: index)
    }
    
}

extension DetailViewCoordinator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) { return }
        
        if fromVC is DetailViewController {
            parentCoordinator.finishDetailView(coordinator: self)
        }
    }
    
}
