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
        table.emptyView = DYEmptyOrFailView(frame: self.view.bounds, emptyType: .common)
        self.view.addSubview(table)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试空白页面"
        showTestScrollView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell")!
        cell.textLabel?.text = "我就是我==\(indexPath.row)"
        return cell
    }
}
