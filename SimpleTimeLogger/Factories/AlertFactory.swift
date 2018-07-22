//
//  AlertFactory.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import UIKit

public enum AlertType: String {
    case date
    case project
    case activity
    case hours
    case emptyHours
}

protocol AlertFactory {
    func createAlert(alertType: AlertType, viewController: EditTimeEntryViewController) -> SetParameterAction
}

public struct AlertActionFactory: AlertFactory {
    
    func createAlert(alertType: AlertType, viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        switch alertType {
            case .date: return createDatePickerAlertAction(viewController: viewController)
            case .project: return createProjectAlertAction(viewController: viewController)
            case .activity: return createActivityAlertAction(viewController: viewController)
            case .hours: return createHoursAlertAction(viewController: viewController)
            case .emptyHours: return createEmptyHoursAlertAction(viewController: viewController)
        }
    }
    
    private func createDatePickerAlertAction(viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        return { [weak viewController] in
            let alert = UIAlertController(style: .actionSheet, title: "Select Date", message: nil)
            alert.addDatePicker(mode: .date,
                                date: viewController?.viewModel.timeEntry.date,
                                minimumDate: nil,
                                maximumDate: Date()) { date in
                viewController?.viewModel.timeEntry.date = date
            }
            alert.addAction(title: "Done", style: .cancel)
            alert.show()
        }
    }
    
    private func createProjectAlertAction(viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        return { [weak viewController] in
            let alert = UIAlertController(style: .actionSheet, title: "Select Project", message: nil)
            let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
            viewController?.viewModel.timeEntry.project = projects[pickerViewSelectedValue.row]
            alert.addPickerView(values: [projects], initialSelection: pickerViewSelectedValue) { _, _, index, _ in
                viewController?.viewModel.timeEntry.project = projects[index.row]
            }
            alert.addAction(title: "Done", style: .cancel)
            alert.show()
        }
    }
    
    private func createActivityAlertAction(viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        return { [weak viewController] in
            let alert = UIAlertController(style: .actionSheet, title: "Select Action", message: nil)
            let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
            viewController?.viewModel.timeEntry.activity = activities[pickerViewSelectedValue.row]
            alert.addPickerView(values: [activities], initialSelection: pickerViewSelectedValue) { _, _, index, _ in
                viewController?.viewModel.timeEntry.activity = activities[index.row]
            }
            alert.addAction(title: "Done", style: .cancel)
            alert.show()
        }
    }
    
    private func createHoursAlertAction(viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        return { [weak viewController] in
            let alert = UIAlertController(style: .actionSheet, title: "Hours Entry", message: nil)
            let textField: TextField.Config = { textField in
                textField.leftViewPadding = 12
                textField.becomeFirstResponder()
                textField.borderWidth = 1
                textField.cornerRadius = 8
                textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
                textField.backgroundColor = nil
                textField.textColor = .black
                textField.placeholder = "Type hours"
                textField.keyboardAppearance = .default
                textField.keyboardType = .numbersAndPunctuation
                textField.isSecureTextEntry = false
                textField.returnKeyType = .done
                textField.text = viewController?.viewModel.timeEntry.hours
                textField.delegate = viewController
                textField.action { textField in
                    viewController?.viewModel.timeEntry.hours = textField.text
                }
            }
            alert.addOneTextField(configuration: textField)
            alert.addAction(title: "OK", style: .cancel)
            alert.show()
        }
    }
    
    private func createEmptyHoursAlertAction(viewController: EditTimeEntryViewController) -> SetParameterAction {
        
        return { [weak viewController] in
            let alert = UIAlertController(style: .alert, title: "Hours Entry", message: "Hours field can't be blank! Please fill it.")
            let textField: TextField.Config = { textField in
                textField.leftViewPadding = 12
                textField.becomeFirstResponder()
                textField.borderWidth = 1
                textField.cornerRadius = 8
                textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
                textField.backgroundColor = nil
                textField.textColor = .black
                textField.placeholder = "Type hours"
                textField.keyboardAppearance = .default
                textField.keyboardType = .numbersAndPunctuation
                textField.isSecureTextEntry = false
                textField.returnKeyType = .done
                textField.text = viewController?.viewModel.timeEntry.hours
                textField.delegate = viewController
                textField.action { textField in
                    viewController?.viewModel.timeEntry.hours = textField.text
                }
            }
            alert.addOneTextField(configuration: textField)
            alert.addAction(title: "OK", style: .cancel)
            alert.show()
        }
    }
    
}
