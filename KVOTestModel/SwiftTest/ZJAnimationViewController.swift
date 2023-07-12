//
//  ZJAnimationViewController.swift
//  KVOTestModel
//
//  Created by zhangjiang on 2023/5/24.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

import UIKit

class ZJAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "showName"
        setUpAnimationUI()
    }
    
    func setUpAnimationUI() {
        
        let view = ZJShowDrawView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.name = "大家好"
            
        view.showTest()
        
    }


}
