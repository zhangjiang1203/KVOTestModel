//
//  ZJBaseViewController.m
//  KVOTestModel
//
//  Created by zhangjiang on 2020/7/10.
//  Copyright © 2020 zhangjiang. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJBaseViewController ()

@end

@implementation ZJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    [self goToLookInView];
//}

//- (void)goToLookInView {
////    UINavigationController *navVC = CZ_GetCurNavController();
//    
//   UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"lookin功能" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
//   UIAlertAction *docAction = [UIAlertAction actionWithTitle:@"导出为LookIn文档" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"开始摇晃==Lookin_Export");
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
//   }];
//   UIAlertAction *action2D = [UIAlertAction actionWithTitle:@"2D视图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//       NSLog(@"开始摇晃==Lookin_2D");
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
//   }];
//   UIAlertAction *action3D = [UIAlertAction actionWithTitle:@"3D视图" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//       NSLog(@"开始摇晃==Lookin_3D");
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
//   }];
//   UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//       
//   }];
//   [controller addAction:docAction];
//   [controller addAction:action2D];
//   [controller addAction:action3D];
//   [controller addAction:cancelAc];
//    
//   [self presentViewController:controller animated:YES completion:^{}];
//}

@end
