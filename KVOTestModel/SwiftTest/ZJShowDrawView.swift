//
//  ZJShowDrawView.swift
//  KVOTestModel
//
//  Created by zhangjiang on 2023/5/24.
//  Copyright © 2023 zhangjiang. All rights reserved.
//

import UIKit

class ZJShowDrawView: UIView {
    
    var name: String = ""
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        print("我就是")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showTest() {
        print("\(name)")
    }
    
    
    

}
