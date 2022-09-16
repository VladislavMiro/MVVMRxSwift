import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: UITableViewController {

    public var viewModel: MainViewViewModelProtocol!
    
    private var selectedIndex: Int = 0
    private var searchController = UISearchController()
    private let disposeBag = DisposeBag()
    
    private var dataSource = RxTableViewSectionedAnimatedDataSource<SectionModel> { (section, tableView, indexPath, item) in
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            cell.viewModel = TableViewCellViewModel(name: item.name ?? "", lastName: item.lastName ?? "")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindTableView()
        configureDataSource()
        bindSearchController()
        bindData()
        
    }

    @IBAction private func addButton(_ sender: UIBarButtonItem) {
        viewModel.openAddContactView()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
//MARK: Confogure TableView
extension MainViewController {
    
    private func configureTableView() {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.backgroundView?.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
    }
    
    private func configureDataSource() {
        dataSource.animationConfiguration = AnimationConfiguration(
            insertAnimation: .right,
            reloadAnimation: .bottom,
            deleteAnimation: .left
        )
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }

        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }

        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
            return false
        }
    }
    
}
//MARK: Bindings
extension MainViewController {
    
    private func bindData() {
        viewModel.contacts
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.preloadDataFromStorage().subscribe(onError: { [unowned self] (error) in
            self.showAlert(description: error.localizedDescription)
        }).disposed(by: disposeBag)


    }
    
    private func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Contact.self).asDriver().drive(onNext: { [unowned self] contact in
            self.viewModel.didSelectRow(data: contact)
        }).disposed(by: disposeBag)

        tableView.rx.itemDeleted.asDriver().drive { [unowned self] (indexPath) in
            self.viewModel.deleteData(atIndex: indexPath.row).subscribe {
                
            } onError: { (error) in
                showAlert(description: error.localizedDescription)
            }.disposed(by: disposeBag)

        }.disposed(by: disposeBag)
    }
    
    private func bindSearchController() {
        searchController.searchBar.rx.text
            .subscribe(onNext: { [unowned self] (predicate) in
                guard let predicate = predicate else { return }
                
                if predicate.isEmpty {
                    self.viewModel.preloadDataFromStorage().subscribe( onError: { error in
                        showAlert(description: error.localizedDescription)
                    }).disposed(by: disposeBag)
                } else {
                    self.viewModel.fetchData(with: predicate)
                }
            }).disposed(by: disposeBag)
    }
    
    private func showAlert(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
