//
//  caozuoGuideViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/27.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "caozuoGuideViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
@interface caozuoGuideViewController ()

@end

@implementation caozuoGuideViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"操作手册" andClass:self andSEL:@selector(bacClick:)];
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
    //创建一个网页视图。
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64)];
    [_webView setScalesPageToFit:YES];
    //网址字符串
    _webView.delegate=self;
    NSString *urlStr = @"http://qimeng.pospt.cn:9999/manual";
    
    //把字符串转成网址类
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //用网址创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [_webView loadRequest:request];

    [self.view addSubview:_webView];

    //调用
    //[self loadDocument:@"manual2000000055.html" inView:_webView];
}
#pragma mark - 在webView上加载文件
//-(void)loadDocument:(NSString *)documentName inView:(UIWebView*)webView
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
//    
//    NSLog(@"%@",path);
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
//}

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
