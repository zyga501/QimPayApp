//
//  fenXiangErWeimaViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/29.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "fenXiangErWeimaViewController.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
@interface fenXiangErWeimaViewController ()

@end

@implementation fenXiangErWeimaViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"扫描二维码" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
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
    
////    
//    UIImage *img = [UIImage imageNamed:@"share_qrcode.png"];
//    //加载图片
//    UIImageView *imag=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-180)/2, 130*screenWidth/320, 180*screenWidth/320, 180*screenWidth/320)];
//    //给图片赋值
//    imag.image = img;
//    [self.view addSubview:imag];
//    
//    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, 330*screenWidth/320, 220*screenWidth/320, 20*screenWidth/320)];
//    lab.text=@"请让对方使用扫码工具扫一扫";
//    lab.font=[UIFont systemFontOfSize:16];
//    lab.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:lab];
  
    
    User * user = [User currentUser];
    self.view.backgroundColor=[UIColor lightGrayColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:YES];
    
    
    //网址字符串
    NSString *urlStr=[NSString stringWithFormat:@"http://121.41.118.80/mobile/ss/createTgQrCode.do?agentId=%@&merId=%@&loginId=%@",can,user.merid,user.phoneText];
    
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
