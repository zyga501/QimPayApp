//
//  JinRongChaoShiViewController.m
//  QLTF
//
//  Created by 王健超 on 15/10/14.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "JinRongChaoShiViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "User.h"
@interface JinRongChaoShiViewController ()<UIWebViewDelegate>
{
    UIWebView *_webview;
}
@end

@implementation JinRongChaoShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-44*screenWidth/320)];
    [webView setScalesPageToFit:YES];
    
    User *user=[User currentUser];

    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url35 andKeyArr:@[@"agentId",@"merId",@"extSysId"]andValueArr:@[can,user.merid,@"0000"]];
    
    //加载请求
    [webView loadRequest:rever];
    
    [self.view addSubview:webView];
    
    
    [self makeNav];

}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"金融超市" andClass:self andSEL:@selector(bacClick:)];
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
