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
    
    var viewModel: EditTimeEntryViewModel {
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
    
    fileprivate lazy var alertFactory: AlertFactory = AlertActionFactory()
    
    fileprivate lazy var dateCell = TimeEntryParameterCell(title: AlertType.date.rawValue,
                                                           label: viewModel.timeEntry.date.toString(),
                                                           action: alertFactory.createAlert(alertType: .date, viewController: self))
    fileprivate lazy var projectCell = TimeEntryParameterCell(title: AlertType.project.rawValue,
                                                              label: viewModel.timeEntry.project ?? "",
                                                              action:  alertFactory.createAlert(alertType: .project, viewController: self))
    fileprivate lazy var activityCell = TimeEntryParameterCell(title: AlertType.activity.rawValue,
                                                               label: viewModel.timeEntry.activity ?? "",
                                                               action:  alertFactory.createAlert(alertType: .activity, viewController: self))
    fileprivate lazy var hoursCell = TimeEntryParameterCell(title: AlertType.hours.rawValue,
                                                            label: viewModel.timeEntry.hours ?? "",
                                                            action:  alertFactory.createAlert(alertType: .hours, viewController: self))
    fileprivate lazy var commentCell = CommentCell(comments: viewModel.timeEntry.comments ?? "")
    
    private func updateCells() {
        dateCell.label.text = viewModel.timeEntry.date.toString()
        projectCell.label.text = viewModel.timeEntry.project ?? ""
        activityCell.label.text = viewModel.timeEntry.activity ?? ""
        hoursCell.label.text = viewModel.timeEntry.hours ?? ""
    }
    
    private func emptyHoursField() {
        alertFactory.createAlert(alertType: .emptyHours, viewController: self)()
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
