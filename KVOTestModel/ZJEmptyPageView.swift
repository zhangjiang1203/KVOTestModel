//
//  ZJEmptyPageView.swift
//  ShowNameTest
//
//  Created by 张江 on 2024/5/17.
//

import UIKit
import ObjectiveC.runtime

var kEmptyView: Void?

extension UIScrollView {
    var emptyView: UIView? {
        get {  return objc_getAssociatedObject(self, &kEmptyView) as? UIView }
        set {
            //开始交换方法
            SwizzingMethod.swizzing(originalSel: #selector(UITableView.reloadData), swizzleSel: #selector(UITableView.zj_reloadData), classType: UITableView.self)
            objc_setAssociatedObject(self, &kEmptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    @objc func zj_reloadData() {
        print("开始调用更新了====哈哈哈哈")
        //设置展示数据
//        self.numberOfSections
        
        self.zj_reloadData();
    }
}

struct SwizzingMethod {
    
    /// 交换方法
    ///
    /// - Parameters:
    ///   - originalSel: 原方法
    ///   - swizzleSel: 用于交换的方法
    ///   - classType: 所属类型
    static func swizzing(originalSel: Selector, swizzleSel: Selector, classType: AnyClass) {

        guard let originalMethod = class_getInstanceMethod(classType, originalSel) else {
            assertionFailure("can't find method: " + originalSel.description)
            return
        }
        
        guard let swizzleMethod = class_getInstanceMethod(classType, swizzleSel) else {
            assertionFailure("can't find method: " + swizzleSel.description)
            return
        }
        
        let didAddMethod = class_addMethod(classType,
                                           originalSel,
                                           method_getImplementation(swizzleMethod),
                                           method_getTypeEncoding(swizzleMethod))
        if didAddMethod {
            class_replaceMethod(classType,
                                swizzleSel,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzleMethod)
        }
    }
    
}
