//
//  TextField.swift
//
// https://github.com/dillidon/alerts-and-pickers

import UIKit

open class TextField: UITextField {
    
    public typealias Config = (TextField) -> Swift.Void
    
    public func configure(configurate: Config?) {
        configurate?(self)
    }
    
    public typealias Action = (UITextField) -> Void
    
    fileprivate var actionEditingChanged: Action?
    
    // Provides left padding for images
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftViewPadding ?? 0
        return textRect
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
    }
    
    public var leftViewPadding: CGFloat?
    public var leftTextPadding: CGFloat?
    
    public func action(closure: @escaping Action) {
        if actionEditingChanged == nil {
            addTarget(self, action: #selector(TextField.textFieldDidChange), for: .editingChanged)
        }
        actionEditingChanged = closure
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        actionEditingChanged?(self)
    }
}
extension UIAlertController {
    
    /// Add a textField
    ///
    /// - Parameters:
    ///   - height: textField height
    ///   - hInset: right and left margins to AlertController border
    ///   - vInset: bottom margin to button
    ///   - configuration: textField
    
    func addOneTextField(configuration: TextField.Config?) {
        let textField = OneTextFieldViewController(vInset: preferredStyle == .alert ? 12 : 0, configuration: configuration)
        let height: CGFloat = OneTextFieldViewController.UIConfig.height + OneTextFieldViewController.UIConfig.vInset
        set(viewController: textField, height: height)
    }
}

final class OneTextFieldViewController: UIViewController {
    
    fileprivate lazy var textField: TextField = TextField()
    
    struct UIConfig {
        static let height: CGFloat = 44
        static let hInset: CGFloat = 12
        static var vInset: CGFloat = 12
    }
    
    init(vInset: CGFloat = 12, configuration: TextField.Config?) {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textField)
        UIConfig.vInset = vInset
        
        /// have to set textField frame width and height to apply cornerRadius
        textField.height = UIConfig.height
        textField.width = view.width
        
        configuration?(textField)
        
        preferredContentSize.height = UIConfig.height + UIConfig.vInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.width = view.width - UIConfig.hInset * 2
        textField.height = UIConfig.height
        textField.center.x = view.center.x
        textField.center.y = view.center.y - UIConfig.vInset / 2
    }
}
