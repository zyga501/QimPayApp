//
//  zhiFuViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/14.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "zhiFuViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
@interface zhiFuViewController ()

@end

@implementation zhiFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeNav];
    User * user = [User currentUser];
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:YES];
    
    
    //网址字符串
   NSString *urlStr=[NSString stringWithFormat:@"http://121.41.118.80/mobile/ss/doPay.do?merId=%@&transSeqId=%@&credNo=%@&paySrc=%@",user.merid,user.dingDan,user.pingZheng,@"nor"];
    
    user.str=urlStr;
    
   // NSString *urlStr=UIWebView.request.URL.absoluteString;
    //把字符串转成网址类
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //用网址创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [webView loadRequest:request];
    
    //        //从链接里读取内容
    //        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //        NSLog(@"dataStr = %@",dataStr);
    //        //直接加载到webView里
    //        [webView loadHTMLString:dataStr baseURL:nil];
    
    [self.view addSubview:webView];

    
    
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"收款" andClass:self andSEL:@selector(backlick)];
    [self.view addSubview:mnb];
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    //statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
}
-(void)backlick
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
