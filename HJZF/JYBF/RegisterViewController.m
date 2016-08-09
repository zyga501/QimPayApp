//
//  RegisterViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "Header.h"
#import "nextregisterViewController.h"
#import "MyMD5.h"
#import "PostAsynClass.h"
#import "PostAsynClass.h"
#import "NSString+Extension.h"
#import "MyNavigationBar.h"
#import "agreeViewController.h"
@interface RegisterViewController ()
{
    UITextField *_phoneNum;
    
    UITextField *_phoneYan;
    
    UIButton *_yanBtn;
    
    UIButton *_bottn;
    
    UIButton *_agreeBtn;
    
    BOOL _btnBool;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self createNav];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _phoneNum.delegate=self;
            _phoneNum.font=[UIFont systemFontOfSize:16];
            _phoneNum.placeholder=@"手机号码";
            [_phoneNum setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
            _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview:_phoneNum];
        }
        if (i==1) {
            _phoneYan=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320,170*screenWidth/320, 150*screenWidth/320, 50*screenWidth/320) ];
            _phoneYan.delegate=self;
            _phoneYan.placeholder=@"验证码";
            _phoneYan.font=[UIFont systemFontOfSize:16];
            [_phoneYan setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
            _phoneYan.keyboardType = UIKeyboardTypeNumberPad;
            _phoneYan.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            [self.view addSubview:_phoneYan];
        }
    }
    _phoneNum.tag=1;
    _phoneYan.tag=2;
    
    
    
    _yanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _yanBtn.frame=CGRectMake(210*screenWidth/320, 170*screenWidth/320, 97*screenWidth/320, 50*screenWidth/320);
    [_yanBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_yanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _yanBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [ _yanBtn addTarget:self action:@selector(yanBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _yanBtn];
    
    
    
    
    //灰色的线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (140+i*70)*screenWidth/320, 280*screenWidth/320, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    
    //联系
    UILabel *telLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 223*screenWidth/320, 220*screenWidth/320, 30*screenWidth/320)];
    telLabel.text=@"如果收不到短信，请联系客服:";
    telLabel.textColor=[UIColor lightGrayColor];
    telLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:telLabel];
    
    //客服电话
    UIButton *telButton=[UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame=CGRectMake(210*screenWidth/320, 215*screenWidth/320, 97*screenWidth/320, 50*screenWidth/320);
    [telButton setTitle:@"400-711-5170" forState:UIControlStateNormal];
    telButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [telButton addTarget:self action:@selector(telBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [telButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:telButton];
    //复选框
    _bottn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bottn.frame=CGRectMake(0*screenWidth/320,250*screenWidth/320,50*screenWidth/320, 50*screenWidth/320);
    _bottn.imageEdgeInsets = UIEdgeInsetsMake(15*screenWidth/320,15*screenWidth/320,15*screenWidth/320,15*screenWidth/320);
    
    [ _bottn setImage:[UIImage imageNamed:@"bj_jizhumima.png"] forState:UIControlStateNormal];
    [ _bottn addTarget:self action:@selector(chBtn) forControlEvents:UIControlEventTouchUpInside];
    _btnBool = NO;
    
    [ _bottn setImage:[UIImage imageNamed:@"bj_jizhumimawaikuang.png"] forState:UIControlStateNormal];
    
    _btnBool = YES;
    
    [self.view addSubview: _bottn];
    
    
    //同意
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(50*screenWidth/320, 263*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"同意";
    lab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:lab];
    
    //服务协议
    _agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame=CGRectMake(80*screenWidth/320,260*screenWidth/320,80*screenWidth/320, 25*screenWidth/320);
    [_agreeBtn setTitle:@"服务协议" forState:UIControlStateNormal];
    _agreeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_agreeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(agreeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _agreeBtn];
    
    //注册
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30*screenWidth/320, 310*screenWidth/320,screenWidth-60*screenWidth/320,40*screenWidth/320);
    [button setBackgroundImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:buttonImageselected forState:UIControlStateHighlighted];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}
#pragma mark  拨号
-(void)telBtnClick
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:400-711-5170"]];
}
-(void)yanBtn
{
  
    NSString *phoneStr=_phoneNum.text;
    BOOL phoneBool=[phoneStr isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }
 
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    //网络请求
    [paStr appendFormat:@"%@%@%@%@%@",can,_phoneNum.text,@"00",@"",@"1234567890"];
    
    NSLog(@"%@",paStr);
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url4 andKeyArr:@[@"agentId",@"loginId",@"smsType",@"smsCon",@"chkValue"]andValueArr:@[can,_phoneNum.text,@"00",@"",[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"yanzhengma---------------------------------%@",dic);
    
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_yanBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                _yanBtn.userInteractionEnabled = YES;
                _yanBtn.enabled=YES;
                
            });
        }else{
            // int minutes = timeout / 60;
            int seconds = timeout % 91;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_yanBtn setTitle:[NSString stringWithFormat:@"%@秒倒计时",strTime] forState:UIControlStateNormal];
                _yanBtn.enabled=NO;
                // [_yanBtn setBackgroundImage:[UIImage imageNamed:@"获取倒计时灰.png"] forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
//复选框点击事件

-(void)chBtn
{
    _btnBool=!_btnBool;
    
    if (_btnBool) {
        [ _bottn setImage:[UIImage imageNamed:@"bj_jizhumimawaikuang.png.png"] forState:UIControlStateNormal];
    }
    else
    {
        [ _bottn setImage:[UIImage imageNamed:@"bj_jizhumima.png.png"] forState:UIControlStateNormal];
    }
    
}
-(void)agreeBtn
{
    agreeViewController *ager=[[agreeViewController alloc] init];
    [self.navigationController pushViewController:ager animated:YES];
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
    [_phoneYan resignFirstResponder];
    
}

-(void)createNav
{  //导航
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, self.view.frame.size.width, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"账号注册" andClass:self andSEL:@selector(bbiClick:)];
    [self.view addSubview:mnb];
}
//返回上一界面
-(void)bbiClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


//注册点击事件
-(void)resClick
{
    
    //校验手机号
    if (_btnBool == YES) {
        [self toastResult:@"请勾选同意服务协议"];
        return;
    }
 
    //手机号网络请求
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    
    [paStr appendFormat:@"%@%@%@",can,_phoneNum.text,@"1234567890"];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url6 andKeyArr:@[@"agentId",@"loginId",@"chkValue"]andValueArr:@[can,_phoneNum.text,[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre1 = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre1);
    
    
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre1];
    }
    
    if ([[dic objectForKey:@"isExist"] isEqualToString:@"Y"])
    {
        
        
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"改手机号已注册成功，请更换手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSLog(@"shoujihao%@",dic);
    
    //验证码网络请求
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url5 andKeyArr:@[@"agentId",@"loginId",@"smsCode"]andValueArr:@[can,_phoneNum.text,_phoneYan.text]];
    
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre = [dic1 objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"yanzhengma%@",dic1);
    
    if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    
    
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"N"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"Y"]) {
        
        nextregisterViewController *next=[[nextregisterViewController alloc] init];
        next.text=_phoneNum.text;
        next.yan=_phoneYan.text;
        [self.navigationController pushViewController:next animated:YES];
    }
    
    [_phoneNum resignFirstResponder];
    [_phoneYan resignFirstResponder];
    
    
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
