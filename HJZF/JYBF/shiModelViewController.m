//
//  shiModelViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/23.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "shiModelViewController.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "Header.h"
@interface shiModelViewController ()
{
    UIScrollView *_scr;
}
@end

@implementation shiModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self makeNav];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"拍照模板" andClass:self andSEL:@selector(bacClick)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    _scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenWidth, 568)];
    
    _scr.contentSize = CGSizeMake(0, 1400);
    _scr.bounces = NO;//设置是否反弹
    _scr.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    [self.view addSubview:_scr];

    
    
    
    UILabel *heiLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    heiLab.text=@"身份证和银行卡正面照";
    heiLab.textColor=[UIColor blackColor];
    heiLab.font=[UIFont boldSystemFontOfSize:25];
    [_scr addSubview:heiLab];
    
    
    
    UILabel *twoLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 30)];
    twoLab.text=@"身份证正面照片文字信息必须清楚可辨";
    twoLab.textColor=[UIColor blackColor];
    twoLab.font=[UIFont boldSystemFontOfSize:12];
    [_scr addSubview:twoLab];
    
    
    
    UILabel *threeLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, 300, 30)];
    threeLab.text=@"注册填写的真实姓名身份证号码必须与身份证上的姓名身份证号码一致";
    threeLab.textColor=[UIColor blackColor];
    threeLab.numberOfLines=0;
    threeLab.font=[UIFont boldSystemFontOfSize:12];
    [_scr addSubview:threeLab];
    
    
    
    UIImageView *oneimag=[[UIImageView alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-20, 350)];
    oneimag.image=[UIImage imageNamed:@"img07.png"];
    [_scr addSubview:oneimag];

    
    
    UILabel *fourlab=[[UILabel alloc] initWithFrame:CGRectMake(0, 450, 300, 30)];
    fourlab.text=@"身份证和银行卡反面照";
    fourlab.textColor=[UIColor blackColor];
    fourlab.font=[UIFont boldSystemFontOfSize:25];
    [_scr addSubview:fourlab];
    
    
    
    UILabel *fiveLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 490, 300, 30)];
    fiveLab.text=@"照片中信息必须清晰可见";
    fiveLab.textColor=[UIColor blackColor];
    fiveLab.font=[UIFont boldSystemFontOfSize:12];
    [_scr addSubview:fiveLab];
    
    
    UIImageView *twoimag=[[UIImageView alloc] initWithFrame:CGRectMake(10, 520, self.view.frame.size.width-20, 350)];
    twoimag.image=[UIImage imageNamed:@"img08.png"];
    [_scr addSubview:twoimag];

    
    
    UILabel *sixLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 880, 300, 30)];
    sixLab.text=@"手持银行卡和身份证正面照";
    sixLab.textColor=[UIColor blackColor];
    sixLab.font=[UIFont boldSystemFontOfSize:25];
    [_scr addSubview:sixLab];
    
    
    UILabel *sevenLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 910, 300, 30)];
    sevenLab.text=@"本照片中必须包含用户本人正脸，银行卡，身份证三要素";
    sevenLab.textColor=[UIColor blackColor];
    sevenLab.font=[UIFont boldSystemFontOfSize:12];
    [_scr addSubview:sevenLab];
    
    
    
    UILabel *eightLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 940, 300, 30)];
    eightLab.text=@"持卡人必须和身份证是同一人";
    eightLab.textColor=[UIColor blackColor];
    eightLab.font=[UIFont boldSystemFontOfSize:12];
    [_scr addSubview:eightLab];
    
    
    UIImageView *threeimag=[[UIImageView alloc] initWithFrame:CGRectMake(10, 970, self.view.frame.size.width-20, 350)];
    threeimag.image=[UIImage imageNamed:@"img08.png"];
    [_scr addSubview:threeimag];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
