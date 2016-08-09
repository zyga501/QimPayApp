//
//  SaoMiaoViewController.m
//  JYBF
//
//  Created by 王健超 on 15/10/9.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "SaoMiaoViewController.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
@interface SaoMiaoViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation SaoMiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"扫描二维码" andClass:self andSEL:@selector(backBtn)];
    [self.view addSubview:mnb];
}
-(void)makeUI
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0)];
    webView.delegate=self;
    NSURL *url=[NSURL URLWithString:self.string];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];

}
-(void)backBtn
{
//    UIViewController *tempVC = self.navigationController.viewControllers[1];
//    //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
//    //然后通过数组的下表确定我们想去的VC
//    [self.navigationController popToViewController:tempVC animated:YES];
//    //将当前VC与想去的VC之间的所有VC执行出栈操作，最后把想去的VC显示出来
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stepIntoCamera" object:nil];

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
