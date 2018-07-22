//
//  EditTimeEntryViewController.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import TinyConstraints

final class EditTimeEntryViewController: UIViewController {
    
    fileprivate var timeEntryParameterCells: [TimeEntryParameterCell] {
        return [dateCell, projectCell, activityCell, hoursCell]
    }
    
    fileprivate var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    fileprivate var viewModel: EditTimeEntryViewModel {
        didSet {
            updateCells()
        }
    }
    
    private func setSaveButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func setCancelButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc private func save() {
        guard let hours = viewModel.timeEntry.hours, Double(hours) != nil, Double(hours) != 0 else {
            emptyHoursField()
            return
        }
        if hours.last == "." {
            viewModel.timeEntry.hours = hours + "0"
        }
        viewModel.timeEntry.comments = commentCell.textView.text
        viewModel.saveLog()
        close()
    }
    
    @objc private func close() {
        self.navigationController?.popViewController(animated: false)
    }
    
    required init(viewModel: EditTimeEntryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Time Entry"
        addAndConfigureTableView()
        setSaveButton()
        setCancelButton()
    }
    
    private func addAndConfigureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.edgesToSuperview()
        tableView.register(TimeEntryParameterCell.self,
                           forCellReuseIdentifier: TimeEntryParameterCell.identifier)
        tableView.register(CommentCell.self,
                           forCellReuseIdentifier: CommentCell.identifier)
    }
    
    fileprivate lazy var dateCell = TimeEntryParameterCell(title: "date",
                                                           label: viewModel.timeEntry.date.toString(),
                                                           action: setDate)
    fileprivate lazy var projectCell = TimeEntryParameterCell(title: "project",
                                                              label: viewModel.timeEntry.project ?? "",
                                                              action: setProject)
    fileprivate lazy var activityCell = TimeEntryParameterCell(title: "activity",
                                                               label: viewModel.timeEntry.activity ?? "",
                                                               action: setActivity)
    fileprivate lazy var hoursCell = TimeEntryParameterCell(title: "hours",
                                                            label: viewModel.timeEntry.hours ?? "",
                                                            action: setHours)
    fileprivate lazy var commentCell = CommentCell(comments: viewModel.timeEntry.comments ?? "")
    
    private func updateCells() {
        dateCell.label.text = viewModel.timeEntry.date.toString()
        projectCell.label.text = viewModel.timeEntry.project ?? ""
        activityCell.label.text = viewModel.timeEntry.activity ?? ""
        hoursCell.label.text = viewModel.timeEntry.hours ?? ""
    }
    
    fileprivate lazy var setDate: SetParameterAction = { [unowned self] in
        let alert = UIAlertController(style: .actionSheet, title: "Select Date", message: nil)
        self.viewModel.timeEntry.date = Date()
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) { date in
            self.viewModel.timeEntry.date = date
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    fileprivate lazy var setProject: SetParameterAction = { [unowned self] in
        let alert = UIAlertController(style: .actionSheet, title: "Select Project", message: nil)
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        self.viewModel.timeEntry.project = projects[pickerViewSelectedValue.row]
        alert.addPickerView(values: [projects], initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.viewModel.timeEntry.project = projects[index.row]
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    fileprivate lazy var setActivity: SetParameterAction = { [unowned self] in
        let alert = UIAlertController(style: .actionSheet, title: "Select Action", message: nil)
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        self.viewModel.timeEntry.activity = activities[pickerViewSelectedValue.row]
        alert.addPickerView(values: [activities], initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.viewModel.timeEntry.activity = activities[index.row]
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    fileprivate lazy var setHours: SetParameterAction = { [unowned self] in
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
            textField.text = self.viewModel.timeEntry.hours
            textField.delegate = self
            textField.action { textField in
                self.viewModel.timeEntry.hours = textField.text
            }
        }
        alert.addOneTextField(configuration: textField)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    private func emptyHoursField() {
        let alert = UIAlertController(style: .alert, title: "Hours Entry", message: "Hours field can't be blank! Please fill it.")
        let textField: TextField.Config = {[unowned self] textField in
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
            textField.text = self.viewModel.timeEntry.hours
            textField.delegate = self
            textField.action { textField in
                self.viewModel.timeEntry.hours = textField.text
            }
        }
        alert.addOneTextField(configuration: textField)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
}

extension EditTimeEntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location < textField.text?.count ?? 1 {
            return true
        }
        
        let currentString = textField.text ?? ""
        guard Int(string) != nil || (string == "." && !currentString.contains(".") && currentString.count > 0) else {
            return false
        }
        return true
    }
}

extension EditTimeEntryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        timeEntryParameterCells[indexPath.row].action?()
        commentCell.textView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else { return nil }
        return "Description"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 1 else { return nil }
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 120
    }
}

extension EditTimeEntryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? timeEntryParameterCells.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0: return timeEntryParameterCells[indexPath.row]
            case 1: return commentCell
            default: return UITableViewCell(frame: .zero)
        }
    }
}
