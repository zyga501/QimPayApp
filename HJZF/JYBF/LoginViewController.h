//
//  LoginViewController.h
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)void (^block)(NSString *merid);

@end
