//
//  UIButton+myButton.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/6/9.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "UIButton+myButton.h"
#import "Header.h"
@implementation UIButton (myButton)
- (void)makeUI:(NSString*)name :(BOOL)select
{
    for (UIView *vie in self.subviews) {
        [vie removeFromSuperview];
    }
    
    
    
    UILabel *lab= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    lab.text = name;
    
    lab.textColor = [UIColor grayColor];
    
    //lab.backgroundColor=[UIColor yellowColor];
    lab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:lab];
    
    if (select) {
        lab.textColor = [UIColor redColor];
        
        UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
        v1.backgroundColor = [UIColor redColor];
        
        [self addSubview:v1];
    }

}

@end
