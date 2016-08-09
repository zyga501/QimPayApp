//
//  fanyongViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/26.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "fanyongViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "fanYongJiLuViewController.h"
#import "nextFanyongViewController.h"
@interface fanyongViewController ()

@end

@implementation fanyongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.9];
    [self makeUI];
    [self makeNav];

    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"返佣" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"返佣记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
}
#pragma mark  返佣记录
-(void)navButtonClick
{
    fanYongJiLuViewController *fvc=[[fanYongJiLuViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}
#pragma mark  返回键
-(void)bacClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    User *user=[User currentUser];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(110.0*(screenWidth/320.0), 140*screenWidth/320.0, 120*screenWidth/320.0, 120*screenWidth/320.0)];
    image.image=[UIImage imageNamed:@"fanyontu@3x"];
    [self.view addSubview:image];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(120*screenWidth/320.0, 270*screenWidth/320.0, 80*screenWidth/320.0, 30*screenWidth/320.0)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"返佣";
    label.font=[UIFont boldSystemFontOfSize:28];
    [self.view addSubview:label];
    
    UILabel *FYlabel=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 320*screenWidth/320.0, 160*screenWidth/320.0, 30*screenWidth/320.0)];
    FYlabel.text=[NSString stringWithFormat:@"¥%@元",user.fanYong];
    FYlabel.textAlignment=NSTextAlignmentCenter;
    FYlabel.font=[UIFont boldSystemFontOfSize:28];
    [self.view addSubview:FYlabel];
    
    UIButton *FYbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    FYbutton.frame=CGRectMake(30, 388*screenWidth/320.0, self.view.frame.size.width-60, 40);
    [FYbutton setTitle:@"返佣转出" forState:UIControlStateNormal];
    FYbutton.layer.cornerRadius=4;
    FYbutton.clipsToBounds=YES;
    [FYbutton addTarget:self action:@selector(FYZCbtn) forControlEvents:UIControlEventTouchUpInside];
    FYbutton.backgroundColor=[UIColor colorWithRed:0.17 green:0.72 blue:0.18 alpha:1.0];
    [self.view addSubview:FYbutton];
}
-(void)FYZCbtn
{
    NSLog(@"被点击了");
    nextFanyongViewController *nvc=[[nextFanyongViewController alloc] init];
    [self.navigationController pushViewController:nvc animated:YES];
    
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
