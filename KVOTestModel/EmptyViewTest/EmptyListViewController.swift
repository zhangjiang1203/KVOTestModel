//
//  EmptyListViewController.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/5/24.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import UIKit

class EmptyListViewController: UIViewController {
    
    var showData: [String] = []
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds)
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "systemCell")
        table.register(ZJShowEmptyCell.self, forCellReuseIdentifier: "ZJShowEmptyCell")
        let emptyView = DYEmptyOrFailView(frame: self.view.bounds, emptyType: .common)
        emptyView.actionClosure = {
            print("按钮被点击")
        }
        table.emptyView = emptyView
        self.view.addSubview(table)
        
        return table
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ZJShowEmptyCollectionViewCell.self, forCellWithReuseIdentifier: "ZJShowEmptyCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.view.addSubview(collectionView);
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试空白页面"
//        showTestScrollView()
//        testModel()
//        self.showData = ["123","4543","23432","23423"]
//        self.tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        self.showData = ["123","4543","23432","23423"]
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 模型解析
    func testModel() {
    }
    
    func showTestScrollView() {
        self.tableView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            print("开始刷新1111")
            self.showData = ["123","4543","23432","23423"]
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){
            print("开始刷新2222")
            self.showData = []
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15){
            print("开始刷新2222")
            self.showData = ["你好"]
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 18){
            print("开始刷新2222")
            self.showData = []
            self.tableView.reloadData()
        }
    }
}


extension EmptyListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "systemCell", for: indexPath)
        if(cell != nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ZJShowEmptyCell", for: indexPath)
            
            
        }
        cell.textLabel?.text = "我就是我==\(indexPath.row)"
        return cell
    }
}

extension EmptyListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        if (cell != nil) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZJShowEmptyCollectionViewCell", for: indexPath)
        }
        //展示数据
        return cell
    }
}
