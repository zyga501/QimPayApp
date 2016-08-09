//
//  nextErweiViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/15.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextErweiViewController.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface nextErweiViewController ()
{
    NSString *shareUrl;
}
@end

@implementation nextErweiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    
    User * user = [User currentUser];
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setScalesPageToFit:YES];
    
    //网址字符串
    NSString *urlStr=user.url;
    NSLog(@"0000000000000000000000%@",urlStr);
    //把字符串转成网址类
    NSURL *url = [NSURL URLWithString:urlStr];
    //用网址创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载请求
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:self.string andClass:self andSEL:@selector(baClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setImage:[UIImage imageNamed:@"fenxiang@2x-1.png"] forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-35*screenWidth/320.0, 10*screenWidth/320.0, 30*screenWidth/320.0, 30*screenWidth/320.0);
    [jiluButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)navButtonClick:(UIButton *)btn
{
    User *user=[User currentUser];
    //图片路径
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享%@",user.name,user.url]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"QMpay2"
                                                  url:shareUrl
                                          description:@"QMpay2收款分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //设置短信内容
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享%@",user.name,user.url]];
    
    //            //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:btn arrowDirect:UIPopoverArrowDirectionUp];
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];

}
//-(void)navButtonClick:(UIButton *)btn
//{
//    User *user=[User currentUser];
//    //图片路径
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享%@",user.name,shareUrl]
//                                       defaultContent:@"默认分享内容，没内容时显示"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"QMpay2"
//                                                  url:shareUrl
//                                          description:@"QMpay2收款分享"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    //设置短信内容
//    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享",user.name]];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:btn arrowDirect:UIPopoverArrowDirectionUp];
//    
//    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"微信" icon:[UIImage imageNamed:@"lh_weixin1.png"] clickHandler:^{
//        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享%@",user.name,shareUrl] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"QMpay2" url:shareUrl description:@"QMpay2收款分享" mediaType:SSPublishContentMediaTypeNews];
//        
//        [ShareSDK shareContent:publishContent type:ShareTypeWeixiSession authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
//            if (state == SSPublishContentStateSuccess){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            else if (state == SSPublishContentStateFail){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];
//    }];
//    
//    //    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"二维码"
//    //                                                                           icon:[UIImage imageNamed:@"lh_erweima.png"] clickHandler:^{
//    //                                                                               //
//    //                                                                               //     fenXiangErWeimaViewController *fen=[[fenXiangErWeimaViewController alloc] init];
//    //                                                                               //                                                                       [self.navigationController pushViewController:fen animated:YES];
//    //                                                                               [self toastResult:@"暂未开通"];
//    //
//    //                                                                           }];
//    //
//    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"lh_duanxin.png"] clickHandler:^{
//        id<ISSContent> publishContent = [ShareSDK content:@"QMpay2" defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"QMpay2" url:shareUrl description:@"QMpay2收款分享" mediaType:SSPublishContentMediaTypeNews];
//        //设置短信内容
//        [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享QMpay2%@",user.name,shareUrl]];
//        [ShareSDK shareContent:publishContent type:ShareTypeSMS authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            if (state == SSPublishContentStateSuccess){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            else if (state == SSPublishContentStateFail){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];
//    }];
//    
//    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"lh_pengyouquan.png"] clickHandler:^{
//        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 QMpay2%@",user.name,shareUrl] defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"QMpay2" url:shareUrl description:@"QMpay2收款分享" mediaType:SSPublishContentMediaTypeNews];
//        [ShareSDK shareContent:publishContent type:ShareTypeWeixiTimeline authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            if (state == SSPublishContentStateSuccess){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            else if (state == SSPublishContentStateFail){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];
//    }];
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          item1,
//                          item2,
//                          item3,
//                          nil];
//    
//    //显示分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSPublishContentStateSuccess){
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
//                                }
//                                else if (state == SSPublishContentStateFail) {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]] delegate:self cancelButtonTitle:@"OK"
//                                                                          otherButtonTitles:nil, nil];
//                                    [alert show];
//                                }
//                            }];
//    
//    
//}

-(void)baClick:(UIButton*)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myData" object:nil];
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
