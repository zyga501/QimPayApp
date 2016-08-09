//
//  MyTabbar.h
//  MyTabbar
//
//  Created by Visitor on 14/11/28.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabbar : UIView
- (void)createMyTabbarWithTabbarPlist:(NSString *)plistPath andClass:(id)classObject andSEL:(SEL)sel;
- (void)selectWithIndex:(int)index;
@end










