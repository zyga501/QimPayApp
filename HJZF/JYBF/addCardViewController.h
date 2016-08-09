//
//  addCardViewController.h
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/13.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCardViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,retain)NSMutableArray *dataArr;
@end
