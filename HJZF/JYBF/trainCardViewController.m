//
//  trainCardViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/26.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "trainCardViewController.h"
#import "Header.h"
#import "User.h"
#import "MyNavigationBar.h"
@interface trainCardViewController ()
{
    
    UIWebView *webview;
    
}
@end

@implementation trainCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNav];
    [self makeUI];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"信用卡申请" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURL *url=[NSURL URLWithString:@"http://m.51credit.com/mp/cc.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
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
