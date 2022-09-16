//
//  AddContactViewController.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class AddContactViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var birthdayTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    
    public var viewModel: AddContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        dataBindings()
        buttonBindings()
        // Do any additional setup after loading the view.
    }
    
    private func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func formatPhone(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        
        return result
    }
    
    private func configureDatePicker() {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: true)
        
        datePicker.locale = .autoupdatingCurrent
        datePicker.datePickerMode = .date
        birthdayTextField.inputView = datePicker
        birthdayTextField.inputAccessoryView = toolBar
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        self.birthdayTextField.resignFirstResponder()
    }

}
//MARK: Bindings
extension AddContactViewController {
    
    private func buttonBindings() {
        saveButton.rx.tap.asDriver().filter { [unowned self] in
            guard !(self.nameTextField.text ?? "").isEmpty else {
                self.showAlert(title: "Error", message: "Name is empty. Please enter the name.")
                return false
            }
            guard !(self.lastNameTextField.text ?? "").isEmpty else {
                self.showAlert(title: "Error", message: "Last name is empty. Please enter the last name.")
                return false
            }
            guard !(self.birthdayTextField.text ?? "").isEmpty else {
                self.showAlert(title: "Error", message: "Birthday is empty. Please enter the birthday.")
                return false
            }
            guard !(self.phoneNumberTextField.text ?? "").isEmpty else {
                self.showAlert(title: "Error", message: "Phone number is empty. Please enter the phone number.")
                return false
            }
            return true
        }.drive (onNext: { [unowned self] in
            self.viewModel.saveContact().subscribe { [unowned self] in
                self.viewModel.dismiss()
            } onError: { (error) in
                showAlert(title: "Error", message: error.localizedDescription)
            }.disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
    }
    
    private func dataBindings() {
        nameTextField.rx.text
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text
            .withLatestFrom(lastNameTextField.rx.text.orEmpty)
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text
            .withLatestFrom(phoneNumberTextField.rx.text.orEmpty)
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text
            .map{ self.formatPhone(with: "+X (XXX) XXX-XX-XX", phone: $0 ?? "") }
            .bind(to: phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .map { [unowned self] in dateFormatter(date: $0) }
            .bind(to:  birthdayTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
}
