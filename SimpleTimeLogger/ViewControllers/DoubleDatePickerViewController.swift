//
//  DoubleDatePickerViewController.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func addDoubleDatePicker(mode: UIDatePickerMode, firstDate: Date?, secondDate: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DoubleDatePickerViewController.Action?) {
        let datePicker = DoubleDatePickerViewController(mode: mode, firstDate: firstDate, secondDate: secondDate, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        set(viewController: datePicker, height: 380)
    }
}

final class DoubleDatePickerViewController: UIViewController {
    
    public typealias Action = (Date, Date) -> Void
    
    fileprivate var action: Action?
    
    fileprivate lazy var datePickerView: UIView = UIView()
    
    fileprivate lazy var firstDatePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(DoubleDatePickerViewController.actionForDatePicker), for: .valueChanged)
        return $0
        }(UIDatePicker())
    fileprivate lazy var secondDatePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(DoubleDatePickerViewController.actionForDatePicker), for: .valueChanged)
        return $0
        }(UIDatePicker())
    
    required init(mode: UIDatePickerMode, firstDate: Date? = nil, secondDate: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        
        firstDatePicker.datePickerMode = mode
        firstDatePicker.date = firstDate ?? minimumDate ?? Date()
        firstDatePicker.minimumDate = minimumDate
        firstDatePicker.maximumDate = maximumDate
        
        secondDatePicker.datePickerMode = mode
        secondDatePicker.date = secondDate ?? maximumDate ?? Date()
        secondDatePicker.minimumDate = minimumDate
        secondDatePicker.maximumDate = maximumDate
        self.action = action
        
        view.addSubview(datePickerView)
        
        datePickerView.addSubview(firstDatePicker)
        datePickerView.addSubview(secondDatePicker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        datePickerView.width = view.width
        datePickerView.height = view.height
        datePickerView.center.x = view.center.x
        datePickerView.center.y = view.center.y
        
        firstDatePicker.center.x = datePickerView.width / 2
        firstDatePicker.center.y = datePickerView.height / 4
        
        secondDatePicker.center.x = datePickerView.width / 2
        secondDatePicker.center.y = datePickerView.height - datePickerView.height / 4
    }
    
    @objc func actionForDatePicker() {
        action?(firstDatePicker.date, secondDatePicker.date)
    }
}
