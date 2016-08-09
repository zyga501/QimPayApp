//
//  duanXinViewController.h
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/7.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
@interface duanXinViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
//t1和t0文字选择
@property (nonatomic,retain)NSString * txuan;
//储蓄卡借记卡选择
@property (nonatomic,retain)NSString * kaxuan;
//收款原因
@property (nonatomic,retain)NSString * reason;
//收款金额
@property (nonatomic,retain)NSString * sum;
//收款通道
@property (nonatomic,retain)NSString * payway;
//经纬度
@property(nonatomic,retain)NSString *jing;
@property(nonatomic,retain)NSString *wei;
@end
