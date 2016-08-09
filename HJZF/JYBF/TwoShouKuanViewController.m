//
//  TwoShouKuanViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/6.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "TwoShouKuanViewController.h"
#import "MyNavigationBar.h"
#import "zhiFuViewController.h"
#import "nextErweiViewController.h"
#import "duanXinViewController.h"
#import "PostAsynClass.h"
#import "Header.h"
#import "User.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+CZ.h"
@interface TwoShouKuanViewController ()<CLLocationManagerDelegate,UIActionSheetDelegate>
{
    UIImageView *_image;
    //货款
    UITextField *_textField;
    //收款方式按钮
    UIButton *_bbt;
    
    //收款方式背景
    UIButton *_buto;
    
    //收款方式背景图
    UIImageView *iv;
    
    UIButton *_btn;
    
    UIButton *_btn1;
    
    UILabel *_shouLab;
    UILabel *_shouLab1;
    
    UILabel *_feiLab;
    
    UILabel *_slab;
    
    NSDictionary *_dic;
    
    NSDictionary *dic;
    
    //收款方式选择按钮
    UIButton *shouKuan;
    //收款定义
    NSString *_f;
    
    BOOL _bool;
    NSString *_t;
    NSString *_ka;
    
    //收款金额背景
    UIView *_topView;
    
    UIView *whiteView;
    
    UIView *whiteView1;
    UIView *view;
    NSString *_numt;//判断选则的谁
    NSString *_cardSelect;//判断选择的卡
    NSString *_t0Select;  //t0状态
    NSString *_t1Select;  //t1状态
    NSString *_selectName; //实名的状态
    NSString *_debitFeeRateT0;//借记卡t0数据
    NSString *_debitFeeRateT1;//借记卡t1数据
    NSString *_feeRateT0;//信用卡t0数据
    NSString *_feeRateT1;//信用卡t1数据
    UIButton *_btnT1;//t1的按钮
    UIButton *_btnT0;//t0的按钮
    
    
    //scrollerView布局
    UIScrollView *_scr;
    //当前系统时间
    NSString *_datestr;
    
    // 声明成员变量
    CLLocationManager *_manager;
    // 反编码，获取地名
    CLGeocoder *_coder;
    
    double latitude;
    double longitude;
    
    
    NSString *ch;
    NSString *ch1;
    
    UILabel *TDlabel;
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
    NSMutableArray *arr5;
    NSMutableArray *arrT1;
    NSMutableArray *arrD0;
    UIActionSheet *_al;
    int num;
    
    NSString *feetString;
    NSString *paywayString;


    
}

@end

@implementation TwoShouKuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr5= [[NSMutableArray alloc] init];
    arrT1= [[NSMutableArray alloc] init];
    arrD0= [[NSMutableArray alloc] init];
    arr4= [[NSMutableArray alloc] init];
    arr3= [[NSMutableArray alloc] init];
    arr2= [[NSMutableArray alloc] init];
    arr1= [[NSMutableArray alloc] init];
    _al.delegate=self;

    [self makeNav];
    [self feilvchaxun];

    [self loadData];
    [self setLocation];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
}
- (void)setLocation
{
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    if ([CLLocationManager locationServicesEnabled] )
    {
        // 1、实例化
        _manager = [[CLLocationManager alloc] init];
        // 2、设置精度类型
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 3、设置代理
        _manager.delegate = self;
        // 点击开始定位
        //        // 如果是iOS8以上的话，得添加上两句话
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        //        {
        //            [_manager requestWhenInUseAuthorization];
        //            //[_manager requestAlwaysAuthorization];
        //        }
        // 4、开始进行定位
        
        
        [_manager startUpdatingLocation];
        
    }else {
        NSLog(@"GPS没有开启");
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *oneLocation in locations) {
        // 获取当前的经纬度
        NSLog(@"获取经纬度为%f，%f",oneLocation.coordinate.longitude,oneLocation.coordinate.latitude);
        [self doLocation:oneLocation];
        [_manager stopUpdatingLocation];
    }
}

-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"收款" andClass:self andSEL:@selector(baclick:)];
    [self.view addSubview:mnb];
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)baclick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark   费率查询接口，获得费率信息
-(void)feilvchaxun
{
    User *user=[User currentUser];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url37 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSArray *array = [dictionary objectForKey:@"merFeeInfo"];
    for(NSDictionary *dict in array)
    {
        //NSLog(@"输出通道名字为%@",[dict objectForKey:@"gateName"]);
        //        [arr1 addObject:[dict objectForKey:@"feeRateT0"]];   //t0信息
        //        [arr2 addObject:[dict objectForKey:@"feeRateT1"]];   //t1信息
        //        [arr3 addObject:[dict objectForKey:@"gateId"]];      //费率网关信息
        //        [arr4 addObject:[dict objectForKey:@"gateName"]];    //通道名称信息
        
        
        if([[dict objectForKey:@"t0Stat"]isEqualToString:@"Y"])
        {
            [arr4 addObject:@"D0"];
            [arr3 addObject:[dict objectForKey:@"gateId"]];
            [arr2 addObject:[dict objectForKey:@"feeRateT0"]];
            [arr5 addObject:[dict objectForKey:@"gateName"]];
        }
        if([[dict objectForKey:@"t1Stat"]isEqualToString:@"Y"])
        {
            [arr4 addObject:@"T1"];
            [arr3 addObject:[dict objectForKey:@"gateId"]];
            [arr2 addObject:[dict objectForKey:@"feeRateT1"]];
            [arr5 addObject:[dict objectForKey:@"gateName"]];
        }
        
    }
    NSLog(@"feilv--------------------------------%@---%@",arr3,array);
    
}

-(void)makeUI
{
    //获取当前时间
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
   // NSArray *zonearr=[NSTimeZone knownTimeZoneNames];
    //NSLog(@"%@",zonearr);
    
    _datestr=[formatter stringFromDate:date];
    
    NSLog(@"0000000----------           %@",_datestr);
    
    //如果为选择，费率直接默认为第一个
    if([feetString isEqual:nil]||feetString==NULL)
    {
        feetString=arr2[0];
    }
    //如果为选择，网关直接默认为第一个
    if([paywayString isEqual:nil]||paywayString==NULL)
    {
        paywayString=arr3[0];
    }
    if([_t isEqual:nil]||_t==NULL)
    {
        _t=arr4[0];
    }
    if ([_t isEqualToString:@"D0"])
    {
        _t=@"T0";
    }

    
    //scrolView布局
    _scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0)];
    
    _scr.contentSize = CGSizeMake(0, 500);
    _scr.bounces = NO;//设置是否反弹
    _scr.delegate=self;
    _scr.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    [self.view addSubview:_scr];
 
    //收款说明
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 10*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"收款说明";
    lab.font=[UIFont systemFontOfSize:16];
    lab.textColor=[UIColor blackColor];
    [_scr addSubview:lab];
    
    //收款说明
    _topView=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, 30*screenWidth/320, self.view.frame.size.width-40*screenWidth/320, 30*screenWidth/320)];
    _topView.backgroundColor=[UIColor whiteColor];
    _topView.layer.masksToBounds = YES;
    _topView.layer.cornerRadius = 3.0;
    _topView.layer.borderWidth = 0.5;
    [_scr addSubview:_topView];
    
    _textField=[[UITextField alloc] initWithFrame:CGRectMake(10*screenWidth/320, 5*screenWidth/320, 200*screenWidth/320,20*screenWidth/320)];
    _textField.text=@"货款";
    _textField.delegate=self;
    _textField.font=[UIFont systemFontOfSize:15];
    [_topView addSubview:_textField];
    
    
    
    //请选择充值通道
    UILabel *lab3=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 70*screenWidth/320, self.view.frame.size.width-40*screenWidth/320, 20*screenWidth/320)];
    lab3.text=@"收款通道";
    lab3.textColor=[UIColor blackColor];
    lab3.font=[UIFont systemFontOfSize:15];
    [_scr addSubview:lab3];
    
    
    //收款方式
    UILabel *lab4=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 140*screenWidth/320, self.view.frame.size.width-40*screenWidth/320, 20*screenWidth/320)];
    lab4.text=@"收款方式";
    lab4.textColor=[UIColor blackColor];
    lab4.font=[UIFont systemFontOfSize:15];
    [_scr addSubview:lab4];
    
    //收款方式背景图
    NSArray *ary=@[@"普通收款",@"短信收款",@"二维码收款"];
    NSArray *imAry=@[@"bj_putongshoukuan.png",@"bj_duanxinshoukuan.png",@"bj_erweimashoukuan.png"];
    NSArray *arrBtn =@[@"bj_xuankuang.png",@"bj_xuankuang.png",@"bj_xuankuang.png"];
    NSArray *arrb=@[@"bj_xuanzhong.png",@"bj_xuanzhong.png",@"bj_xuanzhong.png"];
    for(int i=0;i<3;i++)
        
    {
        UIView *imgView=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, (170+(i*30))*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320, 30*screenWidth/320.0)];
        imgView.userInteractionEnabled=YES;
        imgView.backgroundColor=[UIColor whiteColor];
        imgView.layer.cornerRadius = 3.0;
        imgView.layer.borderWidth = 0.5;
        [_scr addSubview:imgView];

        //左边图
        UIImageView *imag=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,35*screenWidth/320.0, 30*screenWidth/320.0)];
        imag.userInteractionEnabled=YES;
        imag.image=[UIImage imageNamed:imAry[i]];
        [imgView addSubview:imag];
        
        
        UILabel *lla=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 0, 100*screenWidth/320.0, 35*screenWidth/320.0)];
        lla.text=ary[i];
        lla.userInteractionEnabled=YES;
        lla.adjustsFontSizeToFitWidth=YES;
        lla.font=[UIFont systemFontOfSize:14];
        [imgView addSubview:lla];
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.frame = CGRectMake(0*screenWidth/320,0,280*screenWidth/320, 30*screenWidth/320);
        
        [bt setImage:[UIImage imageNamed:arrBtn[i]] forState:UIControlStateNormal];
        bt.imageEdgeInsets = UIEdgeInsetsMake(3*screenWidth/320,245*screenWidth/320,3*screenWidth/320,10*screenWidth/320);
        [bt addTarget:self action:@selector(shoukuan:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = 10+i;
        
        if (i==0) {
            [bt setImage:[UIImage imageNamed:arrb[i]] forState:UIControlStateNormal];
            _f = @"1";
        }
        
        [imgView addSubview:bt];

    }
    
    //收款类型白色背景
    view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, 100*screenWidth/320, self.view.frame.size.width-40*screenWidth/320, 30*screenWidth/320)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3.0;
    view.layer.borderWidth = 0.5;
    [_scr addSubview:view];
    
    TDlabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 5*screenWidth/320, view.frame.size.width-100*screenWidth/320, 20*screenWidth/320)];
    TDlabel.text=[NSString stringWithFormat:@"%@  %@",arr5[0],arr4[0]];
    TDlabel.font=[UIFont systemFontOfSize:13];
    TDlabel.textAlignment=NSTextAlignmentLeft;
    TDlabel.textColor=[UIColor blackColor];
    [view addSubview:TDlabel];
    
    //手续费
    _slab =[[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-80*screenWidth/320, 5*screenWidth/320, 30*screenWidth/320, 20*screenWidth/320)];
    _slab.textColor=[UIColor blueColor];
    _slab.textAlignment=NSTextAlignmentRight;
    _slab.text=feetString;
    _slab.font=[UIFont systemFontOfSize:13];
    [view addSubview:_slab];
    
    _shouLab1=[[UILabel alloc] initWithFrame:CGRectMake(_slab.frame.origin.x+_slab.frame.size.width, 5*screenWidth/320, 30*screenWidth/320, 20*screenWidth/320)];
    _shouLab1.text=@"%";
    _shouLab1.textAlignment=NSTextAlignmentLeft;
    _shouLab1.textColor=[UIColor grayColor];
    _shouLab1.font=[UIFont systemFontOfSize:13];
    [view addSubview:_shouLab1];

    
    UIImageView *xialajiantou=[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-30*screenWidth/320.0, 7*screenWidth/320.0, 18*screenWidth/320.0, 15*screenWidth/320.0)];
    xialajiantou.image=[UIImage imageNamed:@"xialajiantou@2x.png"];
    [view addSubview:xialajiantou];
    
    UIButton *buttonSelect=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonSelect.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    buttonSelect.backgroundColor=[UIColor clearColor];
    [buttonSelect addTarget:self action:@selector(btnSelect) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSelect];


    _shouLab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 265*screenWidth/320, 240*screenWidth/320, 20*screenWidth/320)];
    
    _shouLab.text=@"单笔限额20000,单日限额50000";
    _shouLab.textAlignment= NSTextAlignmentLeft;
    _shouLab.textColor=[UIColor grayColor];
    _shouLab.font=[UIFont systemFontOfSize:13];
    [_scr addSubview:_shouLab];

    
    //发起收款
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40*screenWidth/320, 380*screenWidth/320,screenWidth-80*screenWidth/320,40*screenWidth/320);
    [button setBackgroundImage:[UIImage imageNamed:@"bj_shoukuanqueding.png"] forState:UIControlStateNormal];
    [button setTitle:@"发起收款" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:button];
}
-(void)btnSelect
{
    _al = [[UIActionSheet alloc]initWithTitle:@"请选择收款通道" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for(int i=0;i<arr5.count;i++)
    {
        [arrD0 addObject:[NSString stringWithFormat:@"%@  %@",arr5[i],arr4[i]]];
    }
    for(int j=0;j<arr5.count;j++)
    {
        [_al addButtonWithTitle:arrD0[j]];
    }
    [_al showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    //
    NSLog(@"shuchuxians %ld",(long)buttonIndex);
    if(buttonIndex==0)
    {
        return;
    }
    else
    {
        TDlabel.text=arrD0[buttonIndex-1];
        _slab.text=arr2[buttonIndex-1];
        paywayString=arr3[buttonIndex-1];
        _t=arr4[buttonIndex-1];
        if([_t isEqualToString:@"D0"])
        {
            _t=@"T0";
        }
    }
}
//收款按钮点击事件
-(void)shoukuan:(UIButton*)btn
{
    
   
    NSArray *arrBtn =@[@"bj_xuankuang.png",@"bj_xuankuang.png",@"bj_xuankuang.png"];
    NSArray *arrb=@[@"bj_xuanzhong.png",@"bj_xuanzhong.png",@"bj_xuanzhong.png"];
    for (int i  = 0; i <3;i++) {
       UIButton *btnNav = (UIButton*)[self.view viewWithTag:10+i];
        
       [btnNav setImage:[UIImage imageNamed:arrBtn[i]] forState:UIControlStateNormal];
        
    }
    
    
   [ btn setImage:[UIImage imageNamed:arrb[btn.tag-10]] forState:UIControlStateNormal];

    switch (btn.tag) {
        case 10:
        {
            _f=@"1";
            
        }
            break;
        case 11:
        {
            _f=@"2";
            
        }
            break;

        case 12:
        {
            _f=@"3";
            
        }
            break;

            
        default:
            break;
    }
    
    
}

- (void)doLocation:(CLLocation *)oneLocation
{
    latitude = oneLocation.coordinate.latitude;  //纬度
    longitude = oneLocation.coordinate.longitude; // 经度
    //speed = oneLocation.speed;   // 速度
    //altitude = oneLocation.altitude; // 海拔
    // 使用 Baidu 进行地址反编码
    NSString *location = [self getBaiduAddress:oneLocation];
    
    NSLog(@"＋＋＋＋＋%@",location);
    
    // 使用Apple进行反编码
    [self getAppleAddress:oneLocation];
    
}
//
//#pragma mark- 地址反编码...
//// 百度的反编码
- (NSString *) getBaiduAddress:(CLLocation *)location
{
    latitude = location.coordinate.latitude;  //纬度
    longitude = location.coordinate.longitude; // 经度
    NSString *urlstr = [NSString stringWithFormat:
                        @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60",
                        latitude, longitude];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    NSLog(@"==========2222-----------222222%f",latitude);
    
    // 这里是同步请求
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return str;
}

#pragma mark- Apple 的反编码，异步请求
- (NSString *)getAppleAddress:(CLLocation *)location
{
    // CLGeocoder自带的反编码和地理编码
    _coder = [[CLGeocoder alloc] init];
    latitude = location.coordinate.latitude;  //纬度
    longitude = location.coordinate.longitude; // 经度
    // 这个函数是向APPle的服务器发送请求，然后取得相应的结果
    [_coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *mark in placemarks) {
            NSLog(@"^^^^%@",mark);
            NSLog(@"==========444-----------222222%f",latitude);
        }
    }];
    return nil;
}


#pragma mark 点击收款的事件
-(void)resClick:(UIButton*)btn
{
    User * user = [User currentUser];
    if(user.jing==NULL||user.jing==nil)
    {
        user.jing=@"";
    }
    if(user.wei==NULL||user.wei==nil)
    {
        user.wei=@"";
    }

    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([paywayString isEqualToString:@"weixin"]||[paywayString isEqualToString:@"alipay"])
        {
            NSLog(@"选择的是微信或者支付宝收款");
            [self erweimashoukuan];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else
        {
        if ([_f isEqualToString:@"1"]) {
            //对应普通的收款网络请求  成功后跳到普通收款对你供应页面
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            //截取字符串后六位
            NSString *a=_datestr;
            NSString *b=[a substringFromIndex:8];
            NSString *str1 = [_textField.text stringByAddingPercentEscapesUsingEncoding:enc];
            //自动添加小数点后两位
            NSString *text1=[NSString stringWithFormat:@"%.2f",[_kuan doubleValue]];
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b,text1,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            user.dingDan=[dic objectForKey:@"transSeqId"];
            user.pingZheng=[dic objectForKey:@"credNo"];
            user.shouxu=[dic objectForKey:@"transFee"];
            
            NSString *sre = [dic objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            NSLog(@"putongshoukuan%@",dic);
            
            if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                [self toastResult:sre];
            }
            
            if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                
                
                NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url16 andKeyArr:@[@"merId",@"transSeqId",@"credNo",@"paySrc"]andValueArr:@[user.merid,user.dingDan,user.pingZheng,@"nor"]];
                //
                NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
                
                NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                
                //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
                
                NSData *ata1 = [NSData alloc];
                
                ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"xiaofeiyemian%@",dic1);
                
                
                zhiFuViewController *zhifu=[[zhiFuViewController alloc] init];
                [self.navigationController pushViewController:zhifu animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
            
            
        }
        else if ([_f isEqualToString:@"2"]) {
            
            //对应短信的收款网络请求  成功后跳到短信收款对你供应页面
            duanXinViewController *duan=[[duanXinViewController alloc] init];
            duan.txuan=_t;
            duan.kaxuan=@"X";
            duan.payway=paywayString;
            duan.reason=_textField.text;
            duan.sum=_kuan;
            duan.jing=user.jing;
            duan.wei=user.wei;
            [self.navigationController pushViewController:duan animated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }
        else
        {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            //截取字符串后六位
            NSString *a1=_datestr;
            NSString *b1=[a1 substringFromIndex:8];
            
            NSString *str1 = [_textField.text stringByAddingPercentEscapesUsingEncoding:enc];
            //自动添加小数点后两位
            NSString *text=[NSString stringWithFormat:@"%.2f",[_kuan doubleValue]];
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
            
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *di = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            user.xia=[di objectForKey:@"transSeqId"];
            //NSLog(@"erweimashoukuan%@",di);
            NSString *sre = [di objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            //NSLog(@"putongshoukuan%@",di);
            
            if(![[di objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                [self toastResult:sre];
            }
            if([[di objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                
                NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                
                //截取字符串后六位
                NSString *b=_datestr;
                NSString *c=[b substringFromIndex:8];
                
                NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url15 andKeyArr:@[@"merId",@"transSeqId",@"credNo"]andValueArr:@[user.merid,user.xia,c]];
                //
                NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
 
                NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
                
                NSData *ata1 = [NSData alloc];
                
                ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
                user.url=[dic1 objectForKey:@"qrCodeUrl"];
                NSString *sre1 = [dic1 objectForKey:@"respDesc"];
                
                if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    [self toastResult:sre1];
                }
                
                nextErweiViewController *next1=[[nextErweiViewController alloc] init];
                next1.string=@"收款";
                next1.type=_t;
                [self.navigationController pushViewController:next1 animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                
            }
        }
        }

    });
   
}

-(void)erweimashoukuan
{
    //对应二维码收款
    User * user = [User currentUser];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    //截取字符串后六位
    NSString *a1=_datestr;
    NSString *b1=[a1 substringFromIndex:8];
    
    NSString *str1 = [_textField.text stringByAddingPercentEscapesUsingEncoding:enc];
    //自动添加小数点后两位
    NSString *text=[NSString stringWithFormat:@"%.2f",[_kuan doubleValue]];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *di = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.xia=[di objectForKey:@"transSeqId"];
    NSLog(@"erweimashoukuan%@",di);
    NSString *sre = [di objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"putongshoukuan%@",di);
    
    if(![[di objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    
    if([[di objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        
        NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        //截取字符串后六位
        NSString *b=_datestr;
        NSString *c=[b substringFromIndex:8];
        
        NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url15 andKeyArr:@[@"merId",@"transSeqId",@"credNo"]andValueArr:@[user.merid,user.xia,c]];
        //
        NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
        
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
        
        NSData *ata1 = [NSData alloc];
        
        ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
        user.url=[dic1 objectForKey:@"qrCodeUrl"];
        NSLog(@"erweimashoukuan2%@",dic1);
        NSString *sre1 = [dic1 objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre1);
        NSLog(@"putongshoukuan%@",dic1);
        
        if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [self toastResult:sre1];
        }
        else
        {
            nextErweiViewController *next1=[[nextErweiViewController alloc] init];            

            if([paywayString isEqualToString:@"weixin"])
            {
                next1.string=@"微信收款";
            }
            if([paywayString isEqualToString:@"alipay"])
            {
                next1.string=@"支付宝收款";

            }
            next1.type=_t;
            [self.navigationController pushViewController:next1 animated:YES];
        }
        
        
    }
    
}

#pragma mark 网络请求
-(void)loadData
{
    User *user=[User currentUser];
    
    NSMutableURLRequest *rever5 = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive5 = [NSURLConnection sendSynchronousRequest:rever5 returningResponse:nil error:nil];
    
    NSStringEncoding enc5 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str5 = [[NSString alloc] initWithData:receive5 encoding:enc5];
    
    NSData *ata5 = [NSData alloc];
    
    ata5 = [str5 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary*dic5= [NSJSONSerialization JSONObjectWithData:ata5 options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre = [dic5 objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"%@",dic5);
    
    _t0Select = [dic5 objectForKey:@"t0Stat"];
    _t1Select = [dic5 objectForKey:@"t1Stat"];
    _selectName = [dic5 objectForKey:@"isAuthentication"];
    _debitFeeRateT0 = [dic5 objectForKey:@"debitFeeRateT0"];
    _debitFeeRateT1 = [dic5 objectForKey:@"debitFeeRateT1"];
    _feeRateT0 = [dic5 objectForKey:@"feeRateT0"];
    _feeRateT1 = [dic5 objectForKey:@"feeRateT1"];
    if ([ _t0Select isEqualToString:@"N"]) {
        if ([_t1Select isEqualToString:@"N"]) {
            
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的收款功能未开通" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }
    
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//用户未输入任何信息提示
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}
#pragma mark - 登陆失败之后显示的警示框
- (void)showFailAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark -触摸隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    [_textField resignFirstResponder];
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
