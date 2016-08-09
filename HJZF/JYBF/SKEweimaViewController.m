//
//  SKEweimaViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/7.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "SKEweimaViewController.h"
#import "User.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "NSString+Extension.h"
#import "PostAsynClass.h"
@interface SKEweimaViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}
@end

@implementation SKEweimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self makeNavigation];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeNavigation
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"收账第二步" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];


}
-(void)makeUI
{
    User * user = [User currentUser];
    self.view.backgroundColor=[UIColor lightGrayColor];
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height)];
    [webview setScalesPageToFit:YES];
    
    webview.delegate=self;
    //网址字符串
    NSString *urlStr=[NSString stringWithFormat:@"http://121.41.118.80/mobile/ss%@?agentId=%@&merId=%@&loginId=%@&transAmt=%@&trfTitle=%@",url34,can,user.merid,user.phoneText,self.numString,self.textString];
    
    user.str=urlStr;
    NSString *urlString=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"shuchuwei%@",urlString);
    // NSString *urlStr=UIWebView.request.URL.absoluteString;
    //把字符串转成网址类
    NSURL *url = [NSURL URLWithString:urlString];
    
    //用网址创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [webview loadRequest:request];
    
    [self.view addSubview:webview];

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
