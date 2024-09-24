//
//  SwiftUITestPage.swift
//  KVOTestModel
//
//  Created by 张江 on 2024/7/23.
//  Copyright © 2024 zhangjiang. All rights reserved.
//

import SwiftUI

struct SwiftTestModel {
    var title: String
    var textColor: Color
}

struct SwiftUITestPage: View {
    
    var testModel: SwiftTestModel
    /// 点击回调方法
    var onSubmit: (() -> ())?
    
    ///设置初始化函数展示
    init(testModel: SwiftTestModel, onSubmit: (() -> Void)? = nil) {
        self.testModel = testModel
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack{
            Text(testModel.title)
                .font(.system(size: 14))
                .foregroundStyle(testModel.textColor)
                .padding()
            
            Button {
                print("按钮开始点击了")
                onSubmit?()
            } label: {
                Text("我是一个按钮")
                    .padding()
                    .font(.system(size: 14))
                    .foregroundStyle(testModel.textColor)
                    .frame(width: 150,height: 40)
                    .background(.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius:20).strokeBorder(.blue, style: StrokeStyle(lineWidth:1))
                    }
            }

        }
    }
}

#Preview {
    SwiftUITestPage(testModel: SwiftTestModel(title: "哈哈哈", textColor: .red)) {
        
    }
}
