//
//  AppDelegate.h
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic)BOOL isLaunchedByNotification;
@property(retain,nonatomic)NSArray *vcArr;
@property (nonatomic, strong) NSString *IDstring;
@end

