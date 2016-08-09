//
//  LoginViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Header.h"
#import "User.h"
#import "MyMD5.h"
#import "MyNavigationBar.h"
#import "MyTabbar.h"
#import "PostAsynClass.h"
#import "shimingViewController.h"
#import "customViewController.h"
#import "nextregisterViewController.h"
#import "changeViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "APService.h"
@interface LoginViewController ()<CLLocationManagerDelegate>
{
    UIImageView *_image;
    
    UIImageView *_littleImage;
    
    UITextField *_phoneNum;
    
    UITextField *_password;
    
    BOOL _btnBool;
    
    UIButton *_bottn;
    
    UIButton *_remember;
    
    UIButton *_foreget;
    
    UIButton *_btn;
    
    UIAlertView *_alert;
    
    UIImageView *_backgImage;
    
    // 声明成员变量
    CLLocationManager *_manager;
    // 反编码，获取地名
    CLGeocoder *_coder;
    
    double latitude;
    double longitude;
}
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //隐藏导航条
    self.navigationController.navigationBarHidden = YES;
    
    // 设置状态栏风格
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self makeUI];
    [self setLocation];
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
    User *user=[User currentUser];
    latitude = location.coordinate.latitude;  //纬度
    longitude = location.coordinate.longitude; // 经度
    NSString *urlstr = [NSString stringWithFormat:
                        @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60",
                        latitude, longitude];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    user.jing=[NSString stringWithFormat:@"%f",longitude];
    user.wei=[NSString stringWithFormat:@"%f",latitude];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    _password.text = @"";
}
-(void)makeUI
{
    //背景
    _backgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0*screenWidth/320, 0*screenWidth/320, screenWidth, screenHeight)];
    _backgImage.image=[UIImage imageNamed:@"denglu_bg.png"];
    _backgImage.userInteractionEnabled=YES;
    [self.view addSubview:_backgImage];
    
   //文字图片
    UIImageView *write=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 50, 80, 80)];
    write.image=[UIImage imageNamed:@"180.png"];
    [_backgImage addSubview:write];
    
    //文字
    UILabel *labwrite=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 160, 250, 20)];
    labwrite.text=@"随心付   享生活";
    labwrite.textAlignment=NSTextAlignmentCenter;
    labwrite.font=[UIFont systemFontOfSize:15];
    labwrite.textColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [_backgImage addSubview:labwrite];
    
    //账号密码图
    NSArray *arr=@[@"bj_denglu.png",@"bj_mima.png"];
    for(int i=0;i<arr.count;i++)
    {
        _littleImage=[[UIImageView alloc] initWithFrame:CGRectMake(25*screenWidth/320, (200+i*50)*screenWidth/320, 20*screenWidth/320, 20*screenWidth/320)];
        
        _littleImage.image=[UIImage imageNamed:arr[i]];
        [_backgImage addSubview:_littleImage];
    }
    
    
    //账号
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(55*screenWidth/320, 185*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _phoneNum.delegate=self;
            _phoneNum.font=[UIFont systemFontOfSize:18];
            _phoneNum.placeholder=@"请输入账号/手机号";
            _phoneNum.textColor=[UIColor blackColor];
            [_phoneNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            
            // _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
            _phoneNum.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginId"];
            [_backgImage addSubview:_phoneNum];
        }
        if (i==1) {
            _password=[[UITextField alloc] initWithFrame:CGRectMake(55*screenWidth/320,235*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
            _password.delegate=self;
            _password.textColor=[UIColor blackColor];
            _password.placeholder=@"登录密码";
            //输入框删除按钮
            // _password.keyboardType = UIKeyboardTypeNumberPad;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password.secureTextEntry=YES;
            _password.font=[UIFont systemFontOfSize:18];
            [_password setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _password.autocapitalizationType=UITextAutocapitalizationTypeNone;
            [_backgImage addSubview:_password];
        }
    }
    
    _phoneNum.tag=1;
    _password.tag=2;
    
    //白线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (225+i*50)*screenWidth/320, 280*screenWidth/320, 1*screenWidth/320)];
        view.backgroundColor=[UIColor grayColor];
        [_backgImage addSubview:view];
    }

    UILabel *rem=[[UILabel alloc] initWithFrame:CGRectMake(50*screenWidth/320, 298*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    rem.text=@"记住账号";
    rem.font=[UIFont systemFontOfSize:15];
    rem.textColor=[UIColor lightGrayColor];
    [_backgImage addSubview:rem];
    
    //忘记密码
    _foreget=[UIButton buttonWithType:UIButtonTypeSystem];
    _foreget.frame=CGRectMake(220*screenWidth/320, 298*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320);
    [_foreget setTitle:@"忘记密码" forState:UIControlStateNormal];
    _foreget.titleLabel.font = [UIFont systemFontOfSize:15];
    [_foreget setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_foreget addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [_backgImage addSubview:_foreget];
    
    //复选框
    _bottn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bottn.frame=CGRectMake(25*screenWidth/320,300*screenWidth/320,20*screenWidth/320, 20*screenWidth/320);
    [ _bottn setBackgroundImage:[UIImage imageNamed:@"bj_jizhumimawaikuang.png"] forState:UIControlStateNormal];
    [ _bottn addTarget:self action:@selector(chBtn) forControlEvents:UIControlEventTouchUpInside];
    _btnBool = NO;
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"loginId"] isEqualToString:@""]) {
        [ _bottn setBackgroundImage:[UIImage imageNamed:@"bj_jizhumima.png"] forState:UIControlStateNormal];
        
        _btnBool = YES;
    }
    [_backgImage addSubview: _bottn];
    
    //登陆
    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame=CGRectMake(10*screenWidth/320, 340*screenWidth/320, 300*screenWidth/320,40*screenWidth/320);
    [_btn setBackgroundImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_backgImage addSubview:_btn];
    
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((300-40)/2*screenWidth/320, 10*screenWidth/320, 40*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"登录";
    lab.textColor=[UIColor whiteColor];
    [_btn addSubview:lab];
    
    //注册
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((self.view.frame.size.width-60*screenWidth/320)/2,self.view.frame.size.height-100, 60*screenWidth/320, 50*screenWidth/320);
    [btn setImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    [_backgImage addSubview:btn];
    
    UILabel *laa=[[UILabel alloc] initWithFrame:CGRectMake((60-40)/2*screenWidth/320, 15*screenWidth/320, 40*screenWidth/320, 20*screenWidth/320)];
    laa.text=@"注册";
    laa.textColor=[UIColor whiteColor];
    [btn addSubview:laa];
    

    //服务热线
    UILabel *fu=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, self.view.frame.size.height-50, 200, 30)];
    fu.text=@"7*24小时客服:400-711-5170";
    fu.font=[UIFont systemFontOfSize:14];
    fu.textColor=[UIColor grayColor];
    [_backgImage addSubview:fu];
    
}
-(void)login
{
    User *user=[User currentUser];
    //校验手机号
    if (_phoneNum.text == nil||[@"" isEqual:_phoneNum.text]) {
        [self toastResult:@"请输入登陆手机"];
        return;
    }
    if (_password.text == nil ||[@"" isEqual:_password.text]) {
        [self toastResult:@"请输入登录密码"];
        return;
    }

    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url2 andKeyArr:@[@"agentId",@"loginId",@"loginPwd",@"clientModel"]andValueArr:@[can,_phoneNum.text,[MyMD5 md5:_password.text],[[UIDevice currentDevice] model]]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    if(_btnBool)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:_phoneNum.text forKey:@"loginId"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginId"];
        
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"denglu%@",dic);
    
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"]) {
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //上次登录时间
        user.phoneText=_phoneNum.text;
        user.yuanText=_password.text;
        
        user.date=[dic objectForKey:@"lastLoginDate"];
        
        user.name=[dic objectForKey:@"merName"];
        user.merid=[dic objectForKey:@"merId"];
        user.sm=[dic objectForKey:@"isAuthentication"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlias) name:@"setAlias" object:nil];
        _appDelegate.IDstring=user.merid;
        
        [APService setAlias:user.merid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
        if ([[dic objectForKey:@"isAuthentication"] isEqualToString:@"S"])
        {
            user.sm1=@"已绑定";
        }
        else
        {
            
            if ([[dic objectForKey:@"isAuthentication"] isEqualToString:@"I"])
            {
                user.sm1=@"审核中";
            }
            else
            {
                user.sm1=@"未绑定";
            }
        }
//        NSString *merid=user.merid;
//        NSLog(@"%@",merid);
//        _block(merid);
        customViewController *cust=[[customViewController alloc] init];
        [self.navigationController pushViewController:cust animated:YES];
        // //没有实名弹出alert
        if(![[dic objectForKey:@"isAuthentication"]isEqualToString:@"S"])
        {
            if([[dic objectForKey:@"isAuthentication"]isEqualToString:@"I"])
            {     return;
            }
            _alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，是否立即绑定收款银行卡！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我要绑定收款银行卡",nil];
            [_alert show];
            _alert.tag=2;
        }
        
    }
    else
    {
        [self toastResult:@"您输入的手机号或密码错误"];
        
    }
    [_phoneNum resignFirstResponder];
    [_password resignFirstResponder];
    
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)setAlias
{
    User *user=[User currentUser];
    [[NSUserDefaults standardUserDefaults] setObject:user.merid forKey:@"Alias"];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    
    if(alertView.tag==2)
    {
        shimingViewController *shi=[[shimingViewController alloc] init];
        [self.navigationController pushViewController:shi animated:YES];

    }
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
}
//注册点击界面
-(void)registe
{
    RegisterViewController *res=[[RegisterViewController alloc]  init];
    //nextregisterViewController *res=[[nextregisterViewController alloc] init];
    [self.navigationController pushViewController:res animated:YES];
    
}
#pragma mark  忘记密码
-(void)forget
{
    changeViewController *change=[[changeViewController alloc] init];
    change.string=_phoneNum.text;
    [self.navigationController pushViewController:change animated:YES];
}
//复选框点击事件

-(void)chBtn
{
    _btnBool=!_btnBool;
    
    if (_btnBool) {
        [ _bottn setBackgroundImage:[UIImage imageNamed:@"bj_jizhumima.png"] forState:UIControlStateNormal];
    }
    else
    {
        [ _bottn setBackgroundImage:[UIImage imageNamed:@"bj_jizhumimawaikuang.png"] forState:UIControlStateNormal];
    }
    
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
    [_phoneNum resignFirstResponder];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [_password resignFirstResponder];
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
