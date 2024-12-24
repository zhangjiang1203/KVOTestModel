//
//  ZJShowEmptyCell.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/10/21.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import UIKit

class ZJShowEmptyCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
