//
//  nextDuanXinViewController.h
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/7.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface nextDuanXinViewController : UIViewController<UITextViewDelegate,MFMessageComposeViewControllerDelegate>



@property (nonatomic,retain)NSString * shouNUm;
@property (nonatomic,retain)NSString * shou;
@property (nonatomic,retain)NSString * yuanYin;


@property (nonatomic,retain)NSString * ding;
@property (nonatomic,retain)NSString * ping;

@property (nonatomic,retain)NSString * phone;




@end
