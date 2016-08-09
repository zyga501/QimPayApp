//
//  ShareViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ShareViewController.h"
#import "User.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "PostAsynClass.h"
#import "tuiGuangViewController.h"
#import "fenXiangErWeimaViewController.h"
@interface ShareViewController ()
{
    UILabel *_numLabel;
    UIAlertView *mfAlertview;//定义一个弹出框
    NSString *_Urlstr;

}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:nil andRightBBIImages:nil andTitle:@"分享" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"分享记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];

}
-(void)navButtonClick
{
    tuiGuangViewController *tvc=[[tuiGuangViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}
-(void)makeUI
{ 
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    User *user=[User currentUser];
    
    //余额
    //post请求用NSMutableURLRequest,可变request的请求头
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"MER0"]];
    //开始post请求
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    //数据解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.Yue=[dic objectForKey:@"acctBal"];
    int a = [user.Yue intValue];
    user.Yue=[NSString stringWithFormat:@"%d",a];
    NSLog(@"yu e%@",dic);
    
    //剩余推广名额
    NSArray *arr=@[@"分享名额剩余:",@"分享须知"];
    for(int i=0;i<2;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, (80+i*70)*screenWidth/320, 100*screenWidth/320, 25*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor blackColor];
        [self.view addSubview:lab];
    }
    _numLabel=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 80*screenWidth/320, 50*screenWidth/320, 25*screenWidth/320)];
    
    
    _numLabel.text=[NSString stringWithFormat:@"%@个",user.Yue];
    
    _numLabel.font=[UIFont systemFontOfSize:14];
    _numLabel.textColor=[UIColor orangeColor];
    [self.view addSubview: _numLabel];
    
    
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 110*screenWidth/320, 300*screenWidth/320, 25*screenWidth/320)];
    lab1.text=@"分享一位好友，将增加100积分";
    lab1.font=[UIFont systemFontOfSize:14];
    lab1.textColor=[UIColor lightGrayColor];
    [self.view addSubview:lab1];
    
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(5*screenWidth/320, (145+i*140)*screenWidth/320, self.view.frame.size.width-10, 0.5*screenWidth/320)];
        view.backgroundColor=[UIColor grayColor];
        [self.view addSubview:view];
    }
    
    
    NSArray *arr1=@[@"1.  系统默认赠送10个分享名额",@"2. 您可以使用积分兑换分享名额",@"3.  每一千积分可兑换一个分享名额",@"4.  分享商户产生交易，您将实时获得返佣"];
    for(int i=0;i<4;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, (180+i*25)*screenWidth/320, 300*screenWidth/320, 25*screenWidth/320)];
        lab.text=arr1[i];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:lab];
    }

    NSArray*imageArr=@[@"weixinfenxiang@2x.png",@"duanxinfenxiang@2x.png",@"erweimafenxiang@2x.png",@"qqfenxiang@2x.png"];
    for(int i=0;i<4;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((15+i*80)*screenWidth/320,300*screenWidth/320, 50*screenWidth/320, 50*screenWidth/320);
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=400+i;
        [self.view addSubview:btn];
    }
    
    
    NSArray *titaleArr=@[@"微信",@"短信",@"二维码",@"QQ"];
    for(int i=0;i<4;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((5+i*80)*screenWidth/320, 350*screenWidth/320, 70*screenWidth/320, 25*screenWidth/320)];
        lab.text=titaleArr[i];
        
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor blackColor];
        [self.view addSubview:lab];
    }
}
-(void)btn:(UIButton*)btn
{
    
    switch (btn.tag) {
        case 400:
        {
            
            User *user=[User currentUser];
            _Urlstr=[NSString stringWithFormat:@"http://qimeng.pospt.cn/mobile/ss/doReg.do?agentId=%@&mobile=%@",can,user.phoneText];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 QMpay2 App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"QMpay2"
                                                          url:_Urlstr
                                                  description:@"QMpay2 App 下载注册"
                                                    mediaType:SSPublishContentMediaTypeNews];
            //设置短信内容
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 QMpay2App下载注册地址%@",user.name,_Urlstr]];
            
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

            break;
        }
        case 401:
        {
            
            
            User *user=[User currentUser];
            _Urlstr=[NSString stringWithFormat:@"http://qimeng.pospt.cn/mobile/ss/doReg.do?agentId=%@&mobile=%@",can,user.phoneText];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180"  ofType:@"png"];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 QMpay2 App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容测试，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"QMpay2"
                                                          url:_Urlstr
                                                  description:@"QMpay2"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            
            
            //设置短信内容
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 QMpay2 App下载注册地址%@",user.name,_Urlstr]];
            
            
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败");
                                        }
                                    }];
            
            
            
            break;
        }
        case 402:
        {
            fenXiangErWeimaViewController *fen=[[fenXiangErWeimaViewController alloc] init];
            [self.navigationController pushViewController:fen animated:YES];
            break;
        }
        case 403:
        {
            //[self toastResult:@"暂未开通"];ShareTypeQQ
            User *user=[User currentUser];
            _Urlstr=[NSString stringWithFormat:@"http://qimeng.pospt.cn/mobile/ss/doReg.do?agentId=%@&mobile=%@",can,user.phoneText];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"180"  ofType:@"png"];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 QMpay2 App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容测试，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"QMpay2"
                                                          url:_Urlstr
                                                  description:@"QMpay2"
                                                    mediaType:SSPublishContentMediaTypeNews];
            //设置qq内容
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 QMpay2 App下载注册地址%@",user.name,_Urlstr]];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                                
                            }];
            
            break;
        }
        default:
            break;
    }
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
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
