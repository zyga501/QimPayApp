//
//  MyTabbar.m
//  MyTabbar
//
//  Created by Visitor on 14/11/28.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyTabbar.h"
#import "Header.h"
@implementation MyTabbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)createMyTabbarWithTabbarPlist:(NSString *)plistPath andClass:(id)classObject andSEL:(SEL)sel
{
    // 1.读取plist
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //    // 背景图名称
    NSString *bgImageName = [plistDict objectForKey:@"bgimagename"];
    
    // item数组
    NSArray *itemArray = [plistDict objectForKey:@"item"];
    // 2.创建背景图
    [self createBgImageViewWithImageName:bgImageName];
    // 3.创建对应个数的item
    for(int i=0;i<itemArray.count;i++)
    {
        [self createItemWithItemDict:[itemArray objectAtIndex:i] andIndex:i andCount:itemArray.count andClass:classObject andSEL:sel];
    }
}

- (void)createBgImageViewWithImageName:(NSString *)bgImageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgImageName]];
    imageView.frame = CGRectMake(0, self.frame.size.height-49*screenWidth/320.0, self.frame.size.width, 49*screenWidth/320.0);
    imageView.userInteractionEnabled=YES;
    //图片填充
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
}

- (void)createItemWithItemDict:(NSDictionary *)dict andIndex:(int)index andCount:(int)count andClass:(id)classObject andSEL:(SEL)sel
{
    // NSString *title = [dict objectForKey:@"title"];
    NSString *imageName = [dict objectForKey:@"imagename"];
    NSString *imageName_select = [dict objectForKey:@"imagename_select"];
    // 容器
    UIView *baseView = [[UIView alloc] init];
    //tabbar背景颜色
    baseView.backgroundColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    baseView.userInteractionEnabled=YES;
    baseView.frame = CGRectMake(index*self.bounds.size.width/count, 0, self.bounds.size.width/count, self.bounds.size.height);
    
    [self addSubview:baseView];
    
    // 按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0*screenWidth/320, baseView.bounds.size.width, 49*screenWidth/320);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName_select] forState:UIControlStateSelected];
    //按钮图片大小设置
    btn.imageEdgeInsets = UIEdgeInsetsMake(5*screenWidth/320,22*screenWidth/320,9.5*screenWidth/320,22*screenWidth/320);
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [baseView addSubview:btn];
    
    
    
}


- (void)selectWithIndex:(int)index
{
    for(UIView *view in self.subviews)
    {
        // 背景ImageView + baseView 5个
        if(![view isKindOfClass:[UIImageView class]])
        {
            // 5个baseView
            UIButton *btn = [view.subviews objectAtIndex:0];
            if(btn.tag == index )
            {
                // 变蓝色
                btn.selected = YES;
                
            }
            else
            {
                // 变黑色
                
                btn.selected = NO;
            }
        }
    }
}











@end
