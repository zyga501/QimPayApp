//
//  MyNavigationBar.m
//  XCarDemo
//
//  Created by Visitor on 14/12/23.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyNavigationBar.h"
#import "Header.h"
@implementation MyNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createMyNavigationBarWithBgImageName:(NSString *)bgImageName andLeftBBIIamgeNames:(NSArray *)leftBBIImageNames andRightBBIImages:(NSArray *)rightBBIImages andTitle:(NSString *)title andClass:(id)classObject andSEL:(SEL)sel
{
    // 背景
    if(bgImageName.length > 0)
        [self createBgImageViewWithBgImageName:bgImageName];
    else
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    // 按钮
    float x = 10.f;
    if(leftBBIImageNames.count > 0)
    {
        for(int i=0;i<leftBBIImageNames.count;i++)
        {
            float xSet = [self createBBIWithBBIImageName:[leftBBIImageNames objectAtIndex:i] andX:x andTag:i andClass:classObject andSEL:sel];
            x = x + xSet + 5.0f;
        }
    }
    if(rightBBIImages.count > 0)
    {
        float x = 310.f;
        for(int i=0;i<rightBBIImages.count;i++)
        {
            x -= [UIImage imageNamed:[rightBBIImages objectAtIndex:i]].size.width;
            [self createBBIWithBBIImageName:[rightBBIImages objectAtIndex:i] andX:x andTag:i+10 andClass:classObject andSEL:sel];
            x -= 5.f;
        }
    }
    // 标题
    if(title.length > 0)
        [self createTitleWithTitle:title withX:x];
}

- (void)createBgImageViewWithBgImageName:(NSString *)bgImageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgImageName]];
    imageView.userInteractionEnabled=YES;
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

- (CGFloat)createBBIWithBBIImageName:(NSString *)bbiImageName andX:(CGFloat)x andTag:(int)tag andClass:(id)classObject andSEL:(SEL)sel
{
    UIImage *image = [UIImage imageNamed:bbiImageName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.frame = CGRectMake(x, (self.bounds.size.height-image.size.height)/2, image.size.width, image.size.height);
    btn.frame=CGRectMake(0*screenWidth/320, 0*screenWidth/320, 100*screenWidth/320, 44*screenWidth/320);
    btn.imageEdgeInsets = UIEdgeInsetsMake(5*screenWidth/320,10*screenWidth/320,5*screenWidth/320,50*screenWidth/320);
    [btn setImage:image forState:UIControlStateNormal];
    btn.tag = tag;
   // btn.backgroundColor=[UIColor yellowColor];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    if([bbiImageName isEqualToString:@"title_back.png"])
    {
        btn.layer.masksToBounds = YES;
       //btn.layer.cornerRadius = 15.0;
    }
    [self addSubview:btn];

    return image.size.width;
}

- (void)createTitleWithTitle:(NSString *)title withX:(CGFloat)x
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled=YES;
    label.frame = CGRectMake(100*screenWidth/320, 7*screenWidth/320, 120*screenWidth/320, 30*screenWidth/320);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;

    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}





















@end
