//
//  ZJEmptyPageView.swift
//  ShowNameTest
//
//  Created by 张江 on 2024/5/17.
//

import UIKit
import ObjectiveC.runtime
import SnapKit

protocol ZJEmptyPageProtocol {
    var emptyView: UIView? { get set}
    
    /// 数据是否为空
    func isEmpty() -> Bool
    
    func zj_reloadData()
}


struct SwizzingMethod {
    /// 交换方法
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

private struct AssociatedKeys {
    
    static var tableViewAssociatedObject: UInt8 = 0
    
    static var collectionViewAssociatedObject: UInt8 = 0

}

extension UITableView: ZJEmptyPageProtocol{
    
    var emptyView: UIView? {
        get {  return objc_getAssociatedObject(self, &AssociatedKeys.tableViewAssociatedObject) as? UIView }
        set {
            //开始交换方法
            SwizzingMethod.swizzing(originalSel: #selector(UITableView.reloadData), swizzleSel: #selector(UITableView.zj_reloadData), classType: UITableView.self)
            objc_setAssociatedObject(self, &AssociatedKeys.tableViewAssociatedObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 数据是否为空
    func isEmpty() -> Bool {
        
        if let dataSource = self.dataSource, let count = self.dataSource?.numberOfSections?(in: self), count > 0 {
            return (0..<count).contains(where: { dataSource.tableView(self, numberOfRowsInSection: $0) > 0 || hasHeaderOrFooter(in: $0 )}) == false
        } else if self.numberOfSections > 0 {
            return (0..<self.numberOfSections).contains(where: { self.numberOfRows(inSection: $0) > 0 || hasHeaderOrFooter(in: $0) }) == false
        }
        
        return true
    }
    
    /// 是否有头尾
    func hasHeaderOrFooter(in section: Int) -> Bool {
        guard let delegate = self.delegate else {
            return false
        }
        
        if delegate.tableView?(self, viewForHeaderInSection: section) != nil,
           (delegate.tableView?(self, heightForHeaderInSection: section) ?? self.sectionHeaderHeight) > 0 {
            return true
        }
        
        if delegate.tableView?(self, viewForFooterInSection: section) != nil,
           (delegate.tableView?(self, heightForFooterInSection: section) ?? self.sectionFooterHeight) > 0 {
            return true
        }
        
        return false
    }
    
    @objc func zj_reloadData() {
        //设置展示数据
        if isEmpty(),let emptyView = emptyView {
            //添加视图
            self.addSubview(emptyView)
        } else {
            //移除视图
            emptyView?.removeFromSuperview()
        }
        
        self.zj_reloadData();
    }
}

extension UICollectionView: ZJEmptyPageProtocol {
    
    var emptyView: UIView? {
        get {  return objc_getAssociatedObject(self, &AssociatedKeys.collectionViewAssociatedObject) as? UIView }
        set {
            //开始交换方法
            SwizzingMethod.swizzing(originalSel: #selector(UICollectionView.reloadData), swizzleSel: #selector(UICollectionView.zj_reloadData), classType: UICollectionView.self)
            objc_setAssociatedObject(self, &AssociatedKeys.collectionViewAssociatedObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 数据是否为空
    func isEmpty() -> Bool {
        
        if let count = self.dataSource?.numberOfSections?(in: self), count > 0 {
            return (0..<count).contains(where: { (self.dataSource?.collectionView(self, numberOfItemsInSection: $0) ?? 0) > 0 || hasHeaderOrFooter(in: $0 )}) == false
        } else if self.numberOfSections > 0 {
            return (0..<self.numberOfSections).contains(where: { self.numberOfItems(inSection: $0) > 0 || hasHeaderOrFooter(in: $0) }) == false
        }
        
        return true
    }
    
    /// 是否有头尾
    func hasHeaderOrFooter(in section: Int) -> Bool {
        
        guard let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
              let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return false
        }
        
        if let size = delegate.collectionView?(self, layout: layout, referenceSizeForHeaderInSection: section), min(size.width, size.height) > 0 {
            return true
        }
        
        if let size = delegate.collectionView?(self, layout: layout, referenceSizeForFooterInSection: section), min(size.width, size.height) > 0 {
            return true
        }

        return false
        
    }
    
    @objc func zj_reloadData() {
        //设置展示数据
        if isEmpty(),let emptyView = emptyView {
            //添加视图
            self.addSubview(emptyView)
        } else {
            //移除视图
            emptyView?.removeFromSuperview()
        }
        
        self.zj_reloadData();
    }
}

enum DYEmptyOrFailType {
    case common //通用无数据提示
    case search
    
    //MARK: 设置各个类型中 标题 标题颜色 图片和按钮对应的标题、颜色和背景色
    var title: String {
        switch self {
        case .common:
            return "暂无数据"
        case .search:
            return "搜索目标为空"
        }
    }
    
    var titleColor: UIColor {
        return .black
    }
    
    var subTitle: String {
        switch self {
        case .common:
            return "暂无数据"
        case .search:
            return "搜索目标为空"
        }
    }
    
    var subTitleColor: UIColor {
        return .gray
    }
    
    var emptyImage: UIImage {
        return UIImage(named: "header2")!
    }
    
    var actionTitle: String {
        switch self {
        case .common:
            return "暂无数据"
        case .search:
            return "搜索目标为空"
        }
    }
    
    var actionTitleColor: UIColor {
        return .white
    }
    
    var actionBGColor: UIColor {
        return .blue
    }
    
}

/// 定义一个泛型的闭包
public typealias GenericityClosure<T> = (T) -> ()

class DYEmptyOrFailView: UIView {
    //设置大标题 小标题 图片 和 操作按钮
    var titleLabel: UILabel!
    
    var subTitleLabel: UILabel!
    
    var emptyImageView: UIImageView!
    
    var actionBtn: UIButton!
    
    var emptyType: DYEmptyOrFailType = .common
    /// 按钮点击事件
    var actionClosure: GenericityClosure<Void>?
    
    init(frame: CGRect, emptyType: DYEmptyOrFailType) {
        super.init(frame: frame)
        self.emptyType = emptyType
        
        setupEmptyUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEmptyUI() {
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = emptyType.title
        titleLabel.textColor = emptyType.titleColor
        addSubview(titleLabel)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = .systemFont(ofSize: 13)
        subTitleLabel.text = emptyType.subTitle
        subTitleLabel.textColor = emptyType.subTitleColor
        addSubview(subTitleLabel)
        
        emptyImageView = UIImageView()
        emptyImageView.image = emptyType.emptyImage
        addSubview(emptyImageView)
        
        actionBtn = UIButton()
        actionBtn.layer.cornerRadius = 15
        actionBtn.layer.masksToBounds = true
        actionBtn.setTitle(emptyType.actionTitle, for: .normal)
        actionBtn.setTitleColor(emptyType.actionTitleColor, for: .normal)
        addSubview(actionBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        actionBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        
    }
    
}

