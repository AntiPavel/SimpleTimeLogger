//
//  CommentCell.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/22/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import TinyConstraints

final class CommentCell: UITableViewCell {
    
    static let identifier = String(describing: CommentCell.self)
    
    private let fontSize: CGFloat = 20
    
    public lazy var textView: UITextView = {
        $0.font = .systemFont(ofSize: fontSize)
        $0.textColor = .gray
        return $0
    }(UITextView())
    
    convenience init(comments: String) {
        self.init(frame: .zero)
        setup()
        textView.text = comments
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func setup() {
        backgroundColor = .white
        contentView.addSubview(textView)
    }
    
    func layout() {
        textView.leftToSuperview()
        textView.rightToSuperview()
        textView.topToSuperview()
        textView.bottomToSuperview()
    }
}
