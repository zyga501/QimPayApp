//
//  xiangqingViewController.m
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/30.
//  Copyright © 2015年 铂金数据. All rights reserved.
//

#import "xiangqingViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
@interface xiangqingViewController ()<UIWebViewDelegate>

{
    MyNavigationBar *mnb;
    UIWebView *webview;
}

@end

@implementation xiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self makeNav];
    [self makeUI];
}
-(void)makeUI
{
//    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64.5*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64.5*screenWidth/320.0)];
//    image.image=[UIImage imageNamed:@"huodong"];
//    [self.view addSubview:image];
    
    webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64.5*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64.5*screenWidth/320.0)];
    webview.delegate=self;
    
    NSURL *url=[NSURL URLWithString:@"http://121.41.118.80:9999/forward.html"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"活动详情" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    //  UIView *
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
