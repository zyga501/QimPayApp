//
//  agreeViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/16.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "agreeViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
@interface agreeViewController ()

@end

@implementation agreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
       [self makeUI];
      self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"用户协议" andClass:self andSEL:@selector(bacClick)];
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
    
    
    
    //创建一个网页视图。
   _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:_webView];
    
    //使webView的尺寸适应于viewController的大小
   // [_webView setScalesPageToFit:YES];
    
    //让webview滚动到边界不显示背景
  //  [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:YES];
    
    //调用
    [self loadDocument:@"xieyi.html" inView:_webView];
    
   }
#pragma mark - 在webView上加载文件
-(void)loadDocument:(NSString *)documentName inView:(UIWebView*)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    
    NSLog(@"%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
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
