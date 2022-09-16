//
//  DetailViewController.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    
    public var viewModel: DetailViewViewModelProtocol!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindings()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editBarButton(_ sender: UIBarButtonItem) {
        viewModel.openEditView()
    }
    
    private func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

}
//MARK: Bindings
extension DetailViewController {
    
    private func bindings() {
        viewModel.contact.map { "Name: \($0.name ?? "")" }
            .bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.contact.map { "Last Name: \($0.lastName ?? "")" }
            .bind(to: lastNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.contact.filter {$0.dateOfBirth != nil}
            .map { [unowned self] in "Birthday: \(self.dateFormatter(date: $0.dateOfBirth!))" }
            .bind(to: birthdayLabel.rx.text).disposed(by: disposeBag)
        viewModel.contact.map { "Phone: \($0.phoneNumber ?? "")"}
            .bind(to: phoneLabel.rx.text).disposed(by: disposeBag)
    }
    
}
