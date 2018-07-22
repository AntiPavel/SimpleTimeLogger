//
//  TimeRegistrationListViewController.swift
//  SimpleTimeLogger
//
//  Created by Antonov, Pavel on 7/17/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import RealmSwift

class TimeRegistrationListViewController: UIViewController {
    
    private var viewModel: TimeRegistrationListViewModel
    private var notificationToken: NotificationToken?
    private var startDate: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())! {
        didSet {
            setFilter()
        }
    }

    private var endDate: Date = Date() {
        didSet {
            setFilter()
        }
    }
    
    struct UIConfig {
        static let itemHeight: CGFloat = 65
        static let lineSpacing: CGFloat = 20
        static let xInset: CGFloat = 20
        static let topInset: CGFloat = 28
    }
    
    required init(viewModel: TimeRegistrationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        setFilterTitle()
    }
    
    private func setFilter() {
        if endDate < startDate {
            endDate = startDate
        }
        viewModel.updateLogsWithDates(startDate: startDate, endDate: endDate)
        bindViewModel()
        setFilterTitle()
    }
    
    private func setFilterTitle() {
        title = "\(startDate.toString()) - \(endDate.toString())"
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        setAddButton()
        setFilterButton()
    }
    
    private func setAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func setFilterButton() {
        let leftButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(setFilterDates))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func add() {
        guard let realm = try? Realm() else { return }
        let editViewController = EditTimeEntryViewController(viewModel: EditTimeEntryViewModelImplementation(writer: RealmStorageService(realm: realm), log: nil))
        self.navigationController?.pushViewController(editViewController, animated: false)
    }
    
    @objc private func setFilterDates() {
        let alert = UIAlertController(style: .actionSheet, title: "Select Dates", message: "set period of time")
        let minimumDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        alert.addDoubleDatePicker(mode: .date, firstDate: startDate, secondDate: endDate, minimumDate: minimumDate, maximumDate: Date()) { [unowned self] (firstDate, secondDate) in
            self.startDate = firstDate
            self.endDate = secondDate
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    private func bindViewModel() {
        notificationToken = viewModel.logs.observe { [weak self] (changes) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update:
                collectionView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.register(TimeLogCellView.self, forCellWithReuseIdentifier: TimeLogCellView.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = UIScrollViewDecelerationRateFast
        $0.bounces = true
        $0.backgroundColor = .white
        $0.contentInset.bottom = UIConfig.itemHeight
        return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    
    fileprivate lazy var layout: VerticalScrollFlowLayout = {
        $0.minimumLineSpacing = UIConfig.lineSpacing
        $0.sectionInset = UIEdgeInsets(top: UIConfig.topInset, left: 0, bottom: 0, right: 0)
        $0.itemSize = itemSize
        
        return $0
    }(VerticalScrollFlowLayout())
    
    fileprivate var itemSize: CGSize {
        let width = UIScreen.main.bounds.width - 2 * UIConfig.xInset
        return CGSize(width: width, height: UIConfig.itemHeight)
    }
}

extension TimeRegistrationListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let realm = try? Realm() else { return }
        let editViewController = EditTimeEntryViewController(viewModel:
            EditTimeEntryViewModelImplementation(writer:
                RealmStorageService(realm: realm),
                                    log: viewModel.logs[indexPath.row]))
        self.navigationController?.pushViewController(editViewController, animated: false)
    }
}

extension TimeRegistrationListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.logs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: TimeLogCellView.identifier, for: indexPath) as? TimeLogCellView else { return UICollectionViewCell() }
        
        item.configure(with: TimeLogCellViewModelImplementation(log: Array(viewModel.logs)[indexPath.row]))
        return item
    }
}
