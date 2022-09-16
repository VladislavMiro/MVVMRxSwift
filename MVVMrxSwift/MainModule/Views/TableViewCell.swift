//
//  TableViewCell.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 18.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var view: UIView!
    
    public var viewModel: TableViewCellViewModelProtocol! {
        didSet {
            bindings()
        }
    }
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        view.layer.cornerRadius = 5
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func bindings() {
        viewModel.fullName
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
