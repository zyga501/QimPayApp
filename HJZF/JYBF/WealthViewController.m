////
////  WealthViewController.m
////  JYBF
////
////  Created by 王健超 on 15/8/24.
////  Copyright (c) 2015年 wjc. All rights reserved.
////
//
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "WealthViewController.h"
#import "User.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "YuEViewController.h"
#import "fanyongViewController.h"
#import "trainCardViewController.h"
#import "shangchengViewController.h"
#import "ZhuanZhangViewController.h"
#import "nextZZViewController.h"
#import "PostAsynClass.h"
#import "ShouKViewController.h"
#import "saoYSViewController.h"
#import "NEXTsysViewController.h"
#import "JinRongChaoShiViewController.h"
#import "GuQuanZongChouViewController.h"
#import "paihangViewController.h"
#import "weixinErweimaViewController.h"
#import "XYKHKViewController.h"
#import "travelViewController.h"
#import "hotelViewController.h"
#import "customViewController.h"
#import "ZSFSKViewController.h"
@interface WealthViewController ()
{
    UIButton *imageButton;
    UIImageView *image;
    UIButton *button;
    
    UIScrollView *_scr;
    UIScrollView *scrollview;
    UIView *imageBackView;
    NSTimer *timer;
    
    UILabel *FYtext;
    UILabel *YEtext;
    UILabel *JFtext;
    NSString *type;
    NSArray *imageArray;
    UILabel *jifenLabel;
    
}
@end

@implementation WealthViewController
@synthesize pageControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self makeNav];
    [self reloadData];
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    [self reloadData];
    NSLog(@"&&&&&&&&&&&&&&%@",user.yu);
    FYtext.text=[NSString stringWithFormat:@"¥%@元",user.fanYong];
    YEtext.text=[NSString stringWithFormat:@"¥%@元",user.yu];
    jifenLabel.text=[NSString stringWithFormat:@"%@",user.jiFen];
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:nil andRightBBIImages:nil andTitle:@"财富" andClass:self andSEL:nil];
    [self.view addSubview:mnb];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)makeUI
{
    User *user=[User currentUser];//
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0-49)];
    scrollview.backgroundColor=[UIColor whiteColor];
    scrollview.bounces=NO;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.scrollEnabled=YES;
    scrollview.delegate=self;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80*screenWidth/320.0)];
    //63  97 140
    view.backgroundColor=[UIColor colorWithRed:63/255.0 green:97/255.0 blue:140/255.0 alpha:1.0];
    view.userInteractionEnabled=YES;
    [scrollview addSubview:view];
    
    NSArray *firstImageArray=@[@"CFYE",@"CFFY",@"CFJF"];
    NSArray *firstTitileArray=@[@"余额",@"返佣",@"积分"];
    CGFloat jiange=(self.view.frame.size.width/3-40*screenWidth/320.0)/2;
    for(int a=0;a<firstImageArray.count;a++)
    {
        UIImageView *firstImage=[[UIImageView alloc] initWithFrame:CGRectMake(jiange+self.view.frame.size.width/3*a, 5*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0)];
        firstImage.image=[UIImage imageNamed:firstImageArray[a]];
        [view addSubview:firstImage];
        
        UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*a, 45*screenWidth/320.0, self.view.frame.size.width/3, 20*screenWidth/320.0)];
        firstLabel.text=firstTitileArray[a];
        firstLabel.textAlignment=NSTextAlignmentCenter;
        firstLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
        firstLabel.adjustsFontSizeToFitWidth=YES;
        firstLabel.textColor=[UIColor whiteColor];
        [view addSubview:firstLabel];
        
        
        if(a==0)
        {
            YEtext=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*a, 65*screenWidth/320.0, self.view.frame.size.width/3, 15*screenWidth/320.0)];
            YEtext.text=[NSString stringWithFormat:@"¥%@元",user.yu];
            YEtext.textColor=[UIColor whiteColor];
            YEtext.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
            YEtext.textAlignment=NSTextAlignmentCenter;
            YEtext.adjustsFontSizeToFitWidth=YES;
            [view addSubview:YEtext];
        }
        if(a==1)
        {
            FYtext=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*a, 65*screenWidth/320.0, self.view.frame.size.width/3, 15*screenWidth/320.0)];
            FYtext.text=[NSString stringWithFormat:@"¥%@元",user.fanYong];
            FYtext.textColor=[UIColor whiteColor];
            FYtext.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
            FYtext.textAlignment=NSTextAlignmentCenter;
            FYtext.adjustsFontSizeToFitWidth=YES;
            [view addSubview:FYtext];
        }
        if(a==2)
        {
            JFtext=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*a, 65*screenWidth/320.0, self.view.frame.size.width/3, 15*screenWidth/320.0)];
            JFtext.text=user.jiFen;
            JFtext.textColor=[UIColor whiteColor];
            JFtext.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
            JFtext.textAlignment=NSTextAlignmentCenter;
            JFtext.adjustsFontSizeToFitWidth=YES;
            [view addSubview:JFtext];
        }
        UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame=CGRectMake(self.view.frame.size.width/3*a, 0,self.view.frame.size.width/3 , 80*screenWidth/320.0);
        firstButton.backgroundColor=[UIColor clearColor];
        [firstButton addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.tag=500+a;
        [view addSubview:firstButton];
        
    }
    
    int m=0;
    int n=0;
    NSArray*nineImageArray=@[@"WX1",@"WX0",@"pay",@"zsf",
                             @"ZZ",@"yyxy",@"kwgl",@"JRCS",
                             @"SC",@"wsxd",@"xykte",@"xyksq",
                             @"xykhk",@"qlqw",@"frdk",@"LLB"];
    NSArray *nineTitileArray=@[@"微信T1",@"微信T0",@"Apple Pay",@"攒善付收款",
                               @"转账",@"一元许愿",@"卡务管理",@"金融超市",
                               @"商城",@"网上小贷",@"信用卡提额",@"信用卡申请",
                               @"信用卡还款",@"圈里圈外",@"分润贷款",@"4G流量卡"];
    double w=(self.view.frame.size.width-3)/4;
    for(int j=0;j<nineImageArray.count;j++)
    {
        m=j/4;
        n=j%4;
        button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0+(w+1)*n,(view.frame.origin.y+view.frame.size.height+1)+m*(w+1) , w, w);
        [button addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=300+j;
        [scrollview addSubview:button];
        
        if(j==2||j==7)
        {
            UIImageView *newImage=[[UIImageView alloc] initWithFrame:CGRectMake(w/3*2, -1.7, w/3,w/3)];
            newImage.image=[UIImage imageNamed:@"NEW2"];
            [button addSubview:newImage];
        }
        UIImageView *allImage=[[UIImageView alloc] initWithFrame:CGRectMake(w/3, w/6, w/3, w/3)];
        allImage.image=[UIImage imageNamed:nineImageArray[j]];
        [button addSubview:allImage];
        
        UILabel *allLabel=[[UILabel alloc] init];
        allLabel.frame=CGRectMake(0, w/2, w, w/3);
        allLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
        allLabel.adjustsFontSizeToFitWidth=YES;
        allLabel.text=nineTitileArray[j];
        allLabel.textAlignment=NSTextAlignmentCenter;
        [button addSubview:allLabel];
        
    }
    //横线
    for(int a=0;a<3;a++)
    {
        UIView *Hview=[[UIView alloc] initWithFrame:CGRectMake(0,view.frame.origin.y+view.frame.size.height+(a+1)*w , self.view.frame.size.width, 1)];
        Hview.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.85];
        [scrollview addSubview:Hview];
    }
    //竖线
    for(int b=0;b<3;b++)
    {
        UIView *Sview=[[UIView alloc] initWithFrame:CGRectMake((w+1)*(b+1), view.frame.origin.y+view.frame.size.height, 1, self.view.frame.size.width)];
        Sview.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.85];
        [scrollview addSubview:Sview];
    }
    
    _scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 83*screenWidth/320.0+self.view.frame.size.width, self.view.frame.size.width, 120*screenWidth/320.0)];
    _scr.contentSize=CGSizeMake(self.view.frame.size.width*5, 120*screenWidth/320.0);
    _scr.bounces = NO;//设置是否反弹
    _scr.pagingEnabled = YES;
    _scr.scrollEnabled=YES;
    _scr.backgroundColor=[UIColor purpleColor];
    _scr.userInteractionEnabled=YES;
    _scr.showsHorizontalScrollIndicator=NO;//设置横向滑块的隐藏
    _scr.scrollsToTop = YES;
    _scr.delegate=self;
    [scrollview addSubview:_scr];
    imageArray=@[@"banner1",@"banner2.png",@"banner3.png"];
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 178*screenWidth/320.0+self.view.frame.size.width, 100, 18)];
    //选中的设置为红色
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    //没有选中的设置为黑色
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    //设置圆点的个数
    pageControl.numberOfPages = imageArray.count;
    //设置当前页
    pageControl.currentPage = 0;
    //触摸pagecontrol触发change这个方法事件
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [scrollview addSubview:pageControl];
    
    for(int i=0;i<imageArray.count;i++)
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        imageView.userInteractionEnabled=YES;
        //首页是第0页,默认从第1页开始的。所以+320。。。
        imageView.frame = CGRectMake( self.view.frame.size.width * (i + 1), 0, self.view.frame.size.width, 120*screenWidth/320.0);
        
        UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame=CGRectMake(0, 0, self.view.frame.size.width, 120*screenWidth/320.0);
        [bu addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
        bu.tag=100+i;
        [imageView addSubview:bu];
        [_scr addSubview:imageView];
        
    }
    //取数组最后一张图片放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:(imageArray.count-1)]]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 120*screenWidth/320.0); //添加最后1页在首页用于循环
    [_scr addSubview:imageView];
    
    //取数组第一张图片放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:0]]];
    imageView.frame = CGRectMake((self.view.frame.size.width * (imageArray.count + 1)) , 0,self.view.frame.size.width, 120*screenWidth/320.0); //添加第1页在最后用于循环
    [_scr addSubview:imageView];
    
    //加上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scr setContentSize:CGSizeMake(self.view.frame.size.width * (imageArray.count + 2), 120*screenWidth/320.0)];
    [_scr setContentOffset:CGPointMake(0, 0)];
    
    [_scr addSubview:imageBackView];
    timer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerDeal:) userInfo:nil repeats:YES];
    [_scr scrollRectToVisible:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,120*screenWidth/320.0) animated:NO];
    
    scrollview.contentSize=CGSizeMake(self.view.frame.size.width, _scr.frame.size.height+view.frame.size.height+button.frame.size.height*4);
    [self.view addSubview:scrollview];
    NSLog(@"gundonggaodu%f,%f",scrollview.contentSize.height,self.view.frame.size.height);
}
-(void)firstBtn:(UIButton *)first
{
    switch (first.tag) {
            //余额
        case 500:
        {
            YuEViewController *yvc=[[YuEViewController alloc] init];
            [self.navigationController pushViewController:yvc animated:YES];
           break;
        }
            //返佣
        case 501:
        {
            fanyongViewController *fvc=[[fanyongViewController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
            break;
        }
            //积分
        case 502:
        {
            paihangViewController *pvc=[[paihangViewController alloc] init];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark  九宫格点击
-(void)allBtnClick:(UIButton *)allBtn
{
    //int n=allBtn.tag-300;
    //NSLog(@"点击了第%d个按钮",allBtn.tag-300);
    switch (allBtn.tag)
    {
            //微信t1
        case 300:
        {
           type=@"T1";
            [self erweimashoukuan];
            break;
        }
            //微信t0
        case 301:
        {
             type=@"T0";
            [self erweimashoukuan];
            break;
        }
            //apple pay
        case 302:
        {
            [self toastResult:@"敬请期待"];
            break;
        }
            //攒善付收款
        case 303:
        {
            ZSFSKViewController *zvc=[[ZSFSKViewController alloc] init];
            [self.navigationController pushViewController:zvc animated:YES];
            break;
        }
            //转账
        case 304:
        {
            ZhuanZhangViewController *zzvc=[[ZhuanZhangViewController alloc] init];
            [self.navigationController pushViewController:zzvc animated:YES];
            break;
        }
            //一元许愿
        case 305:
        {
             [self toastResult:@"暂未开通"];           
            break;
        }
            //卡务管理
        case 306:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            //金融超市
        case 307:
        {
             JinRongChaoShiViewController *jvc=[[JinRongChaoShiViewController alloc] init];
            [self.navigationController pushViewController:jvc animated:YES];
            break;
        }
            //商城
        case 308:
        {
            shangchengViewController *svc=[[shangchengViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            //网上小贷
        case 309:
        {
            hotelViewController *hvc=[[hotelViewController alloc] init];
            [self.navigationController pushViewController:hvc animated:YES];
            break;
        }
            //信用卡提额
        case 310:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            //信用卡申请
        case 311:
        {
            trainCardViewController *tvc=[[trainCardViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        }
            //信用卡还款
        case 312:
        {
            XYKHKViewController *xvc=[[XYKHKViewController alloc] init];
            [self.navigationController pushViewController:xvc animated:YES];
            break;
        }
            //圈里圈外
        case 313:
        {
            travelViewController *tvc=[[travelViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        }
            //分润贷款
        case 314:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            //4G流量
        case 315:
        {
            GuQuanZongChouViewController *gvc=[[GuQuanZongChouViewController alloc] init];
            [self.navigationController pushViewController:gvc animated:YES];
           
            break;
        }
    }
    
    
}
-(void)erweimashoukuan
{
    weixinErweimaViewController *nvc=[[weixinErweimaViewController alloc] init];
    if([type isEqualToString:@"T1"])
    {
        nvc.string=@"微信T1";
        nvc.type=@"T1";
    }
    if([type isEqualToString:@"T0"])
    {
        nvc.string=@"微信D0";
        nvc.type=@"T0";
    }
    [self.navigationController pushViewController:nvc animated:YES];    
}

-(void)reloadData
{
    User *user=[User currentUser];
    
    //余额
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"PAY0"]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    
    user.yu=[dic objectForKey:@"acctBal"];
    user.KYyue=[dic objectForKey:@"avlBal"];
    NSLog(@"yu e%@",dic);
    
    
    //返佣
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"RATE"]];
    //
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    NSData *ata1 = [NSData alloc];
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic1 objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    
    user.fanYong=[dic1 objectForKey:@"avlBal"];
    NSLog(@"fanyong%@",dic1);
        //积分
        NSMutableURLRequest *rever2 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"JF00"]];
        //
        NSData *receive2 = [NSURLConnection sendSynchronousRequest:rever2 returningResponse:nil error:nil];
        NSStringEncoding enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString  *str2 = [[NSString alloc] initWithData:receive2 encoding:enc2];
        NSData *ata2 = [NSData alloc];
        ata2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:ata2 options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic2 objectForKey:@"respCode"] isEqualToString:@"008"])
        {
    
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            alertView.tag=2;
            return;
        }
    
        user.jiFen=[dic2 objectForKey:@"acctBal"];
        int a = [user.jiFen intValue];
        user.jiFen=[NSString stringWithFormat:@"%d",a];
        NSLog(@"jifen%@",dic2);
    //详情
    NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
    NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
    NSData *ata3 = [NSData alloc];
    ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *_dic3= [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
    user.totAmtT1=[_dic3 objectForKey:@"totAmtT1"];
     user.headImage=[_dic3 objectForKey:@"faceImgUrl"];

    NSLog(@"0-0-0-0-0-0-0-0-0-0-0-5%@,%@",_dic3,user.totAmtT1);
    
    user.sm=[_dic3 objectForKey:@"isAuthentication"];
    
    if ([[_dic3 objectForKey:@"isAuthentication"] isEqualToString:@"S"]) {
        user.sm1=@"已绑定";
    }
    else
    {
        
        if ([[_dic3 objectForKey:@"isAuthentication"] isEqualToString:@"I"])
        {
            user.sm1=@"审核中";
        }
        else
        {
            user.sm1=@"未绑定";
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex)
    {
        
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark  余额点击查看
-(void)yu_eBtn
{
    YuEViewController *yvc=[[YuEViewController alloc] init];
    [self.navigationController pushViewController:yvc animated:YES];
}
#pragma mark  返佣点击查看
-(void)fyBtn
{
    fanyongViewController *fvc=[[fanyongViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}
#pragma mark  循环滚动
-(void)timerDeal:(NSTimer *)time
{
    CGPoint newpoint=_scr.contentOffset;
    newpoint.x+=self.view.frame.size.width;
    if(newpoint.x>=self.view.frame.size.width*4)
    {
        //newpoint.origin.x=0;
        newpoint.x=self.view.frame.size.width;
    }
    // imageBackView.frame=newFrame;
    //NSLog(@"%f",_scr.contentOffset.x);
    _scr.contentOffset=newpoint;
    
    
}
//scrollview委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scr.frame.size.width;
    int page = floor((_scr.contentOffset.x - pagewidth/(imageArray.count+2))/pagewidth)+1;
    page--;  // 默认从第二页开始
    pageControl.currentPage = page;
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = _scr.frame.size.width;
    int currentPage = floor((_scr.contentOffset.x - pagewidth/ (imageArray.count+2))/pagewidth) + 1;
    if (currentPage == 0)
    {
        // 序号0 最后1页
        [_scr scrollRectToVisible:CGRectMake(320 * imageArray.count, 0, 320, 120) animated:NO];
    }
    else if (currentPage == (imageArray.count+1))
    {
        // 最后+1,循环第1页
        [_scr scrollRectToVisible:CGRectMake( self.view.frame.size.width, 0, self.view.frame.size.width, 120*screenWidth/320.0) animated:NO];
    }
}

//pagecontrol事件处理方法
- (void)turnPage
{
    //获取当前的page
    long page = pageControl.currentPage;
    //触摸pagecontroller那个圆点往后翻一页 +1
    [_scr scrollRectToVisible:CGRectMake(self.view.frame.size.width * (page + 1),0,self.view.frame.size.width,120*screenWidth/320.0) animated:NO];
}

#pragma mark  循环滚动点击
-(void)imageBtn:(UIButton *)button
{
    NSLog(@"点击了第%d张图片",button.tag-100);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  弹出框
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
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
