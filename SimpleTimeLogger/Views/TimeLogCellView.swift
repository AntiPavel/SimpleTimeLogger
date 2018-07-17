//
//  TimeLogCellView.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

import UIKit
import TinyConstraints

final class TimeLogCellView: UICollectionViewCell {
    
    static let identifier = String(describing: TimeLogCellView.self)
    
    private let topTextLabelFontSize: CGFloat = 20
    private let bottomTextLabelFontSize: CGFloat = 15
    
    private (set) public lazy var projectLabel: UILabel = {
        $0.font = .systemFont(ofSize: topTextLabelFontSize)
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private (set) public lazy var activityLabel: UILabel = {
        $0.font = .systemFont(ofSize: bottomTextLabelFontSize)
        $0.textColor = .gray
        $0.numberOfLines = 1
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private (set) public lazy var timeLabel: UILabel = {
        $0.font = .systemFont(ofSize: topTextLabelFontSize)
        $0.textColor = .gray
        $0.numberOfLines = 1
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private (set) public lazy var statusLabel: UILabel = {
        $0.font = .systemFont(ofSize: bottomTextLabelFontSize)
        $0.textColor = .gray
        $0.numberOfLines = 1
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public func configure(with viewModel: TimeLogCellViewModel) {
        projectLabel.text = viewModel.project
        activityLabel.text = viewModel.activity
        timeLabel.text = String(viewModel.hours)
        statusLabel.text = viewModel.status
    }
    
    fileprivate func setup() {
        backgroundColor = .white
        contentView.addSubview(projectLabel)
        contentView.addSubview(activityLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(statusLabel)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
        style(view: contentView)
    }
    
    func layout() {
        let verticalOffset: CGFloat = 8
        let horizontalOffset: CGFloat = 8
        let topTextLabelHeight: CGFloat = 25
        let bottomTextLabelHeight: CGFloat = 16
        
        projectLabel.leftToSuperview(offset: horizontalOffset)
        projectLabel.height(topTextLabelHeight)
        projectLabel.topToSuperview(offset: verticalOffset)
        
        activityLabel.leftToSuperview(offset: horizontalOffset)
        activityLabel.height(bottomTextLabelHeight)
        activityLabel.topToBottom(of: projectLabel, offset: verticalOffset)
        activityLabel.bottomToSuperview(offset: -verticalOffset)
        
        timeLabel.rightToSuperview(offset: horizontalOffset)
        timeLabel.leftToRight(of: projectLabel)
        timeLabel.height(topTextLabelHeight)
        timeLabel.sizeToFit()
        timeLabel.width(timeLabel.bounds.width)
        timeLabel.topToSuperview(offset: verticalOffset)
        
        statusLabel.rightToSuperview(offset: horizontalOffset)
        statusLabel.height(bottomTextLabelHeight)
        statusLabel.sizeToFit()
        statusLabel.width(statusLabel.bounds.width)
        statusLabel.leftToRight(of: activityLabel)
        statusLabel.topToBottom(of: timeLabel, offset: verticalOffset)
        statusLabel.bottomToSuperview(offset: -verticalOffset)
    }
    
    func style(view: UIView) {
        view.maskToBounds = false
        view.backgroundColor = .white
        view.cornerRadius = 14
        view.shadowColor = .black
        view.shadowOffset = CGSize(width: 1, height: 5)
        view.shadowRadius = 8
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                       byRoundingCorners: .allCorners,
                                       cornerRadii: CGSize(width: 14, height: 14)).cgPath
        view.shadowShouldRasterize = true
        view.shadowRasterizationScale = UIScreen.main.scale
    }
}
