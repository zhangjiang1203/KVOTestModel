//
//  QDBaseSearchViewController.h
//  
//
//  Created by zhangjiang on 2020/7/9.
//

#import "ZJBaseViewController.h"
#import "QDSearchResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDBaseSearchViewController : ZJBaseViewController

//@property (nonatomic,assign) BOOL isSearchAll;
/// 如果有值 是二次搜索界面，
@property (nonatomic,strong) QDSearchResultModel *searchModel;

@end

NS_ASSUME_NONNULL_END
