//
//  TimeEntryParameterCell.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import TinyConstraints

public typealias SetParameterAction = () -> Void

final class TimeEntryParameterCell: UITableViewCell {
    
    static let identifier = String(describing: TimeEntryParameterCell.self)
    
    public var action: SetParameterAction?
    
    private let textLabelFontSize: CGFloat = 20
    
    public lazy var title: UILabel = {
        $0.font = .systemFont(ofSize: textLabelFontSize)
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    public lazy var label: UILabel = {
        $0.font = .systemFont(ofSize: textLabelFontSize)
        $0.textColor = .gray
        $0.numberOfLines = 1
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    convenience init(title: String, label: String, action: @escaping SetParameterAction) {
        self.init(frame: .zero)
        setup()
        self.title.text = title
        self.label.text = label
        self.action = action
    }
    
    fileprivate func setup() {
        backgroundColor = .white
        contentView.addSubview(title)
        contentView.addSubview(label)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
        style(view: contentView)
    }
    
    func layout() {
        
        let horizontalOffset: CGFloat = 8
        let labelHeight: CGFloat = 22
        
        title.centerYToSuperview()
        title.leftToSuperview(offset: horizontalOffset)
        title.height(labelHeight)
        title.sizeToFit()
        title.width(title.bounds.width)
        
        label.rightToSuperview(offset: horizontalOffset)
        label.centerYToSuperview()
        label.leftToRight(of: title)
        label.height(labelHeight)
    }
    
    func style(view: UIView) {
        view.backgroundColor = .white
    }
}
