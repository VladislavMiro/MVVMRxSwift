//
//  EditViewController.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 20.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class EditViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var birthdayTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    public var viewModel: EditViewViewModelProtocol!
    
    private let datePicker = UIDatePicker()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker()
        dataBindings()
        textFieldBindings()
        buttonBindings()
        
        // Do any additional setup after loading the view.
    }
    
    private func fillTextFields(data: Contact) {
        nameTextField.text = data.name
        lastNameTextField.text = data.lastName
        birthdayTextField.text = dateFormatter(date: data.dateOfBirth!)
        phoneTextField.text = data.phoneNumber
    }
    
    private func dateFormatter(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: date) ?? nil
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
    
    private func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        toolBar.setItems([doneButton], animated: true)
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
        self.view.endEditing(true)
    }

}
//MARK: Bindings
extension EditViewController {
    
    private func dataBindings() {
        viewModel.name
            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lastName
            .bind(to: lastNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.birthday
            .map { [unowned self] date in self.dateFormatter(date: date) }
            .bind(to: birthdayTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func textFieldBindings() {
        nameTextField.rx.text
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text
            .withLatestFrom(lastNameTextField.rx.text.orEmpty)
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text
            .withLatestFrom(phoneTextField.rx.text.orEmpty)
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text
            .map{ self.formatPhone(with: "+X (XXX) XXX-XX-XX", phone: $0 ?? "") }
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .map { [unowned self] in dateFormatter(date: $0) }
            .bind(to:  birthdayTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
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
            guard !(self.phoneTextField.text ?? "").isEmpty else {
                self.showAlert(title: "Error", message: "Phone number is empty. Please enter the phone number.")
                return false
            }
            return true
        }.drive (onNext: { [unowned self] in
            self.viewModel.saveData()
                .subscribe(onError: { [unowned self] (error) in
                self.showAlert(title: "Error", message: error.localizedDescription)
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
    }
    
}
