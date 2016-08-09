//
//  nextregisterViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/3/26.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextregisterViewController.h"
#import "Header.h"
#import "registerViewController.h"
#import "MyNavigationBar.h"
#import "LoginViewController.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "User.h"

@interface nextregisterViewController ()

@end
@implementation nextregisterViewController
{
    
    
    UIImageView *_image;
    
    UIScrollView *_scro;
    
    UITextField *_name;
    
    UITextField *_nameId;
    
    UITextField *_regiNum;
    
    UITextField *_oKreg;
    
    UITextField *_deal;
    
    UITextField *_oKdeal;
    
    UITextField *_phonenum;
    
    BOOL isClicked;
    BOOL isclicked;
    UIButton *dealButton;
    UIImageView *dealimage;
    UIImageView *regimage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self makeNav];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//当使用了scrollView及其子视图控件时，如果不用自动布局要把这个设置为NO，否则会有下移
  
    // Do any additional setup after loading the view.
}

-(void)makeNav
{
    //导航
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"注册第二步" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    [self makeUI];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    isClicked=NO;
    isclicked=NO;
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    //整体大的scroler，上下动
    _scro=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320, 320*screenWidth/320, self.view.frame.size.height-64)];
    _scro.contentSize=CGSizeMake(320*screenWidth/320, 420*screenWidth/320);
    _scro.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    _scro.bounces = NO;//设置是否反弹
    _scro.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    [self.view addSubview:_scro];
    
    
    
    
    UILabel *tiLab=[[UILabel alloc] initWithFrame:CGRectMake(50*screenWidth/320, 360*screenWidth/320, 220*screenWidth/320,30*screenWidth/320)];
    tiLab.text=@"登录密码和交易密码为6位数字组成";
    tiLab.font=[UIFont systemFontOfSize:14];
    tiLab.textColor=[UIColor grayColor];
    [_scro addSubview:tiLab];
    
    
//    //白条
//    for(int i=0;i<6;i++)
//    {
//        _image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (10+i*50)*screenWidth/320, 280*screenWidth/320, 50*screenWidth/320)];
//        _image.image=[UIImage imageNamed:@"caifu_13.png"];
//        [_scro addSubview:_image];
//        
//    }
    //白条
    for(int i=0;i<4;i++)
    {
        _image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (10+i*50)*screenWidth/320, 280*screenWidth/320, 50*screenWidth/320)];
        _image.image=[UIImage imageNamed:@"caifu_13.png"];
        [_scro addSubview:_image];
        
    }

    
    
    //注册
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40*screenWidth/320, 280*screenWidth/320,screenWidth-80*screenWidth/320,40*screenWidth/320);
    [button setBackgroundImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    [button setTitle:@"注 册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(regClick) forControlEvents:UIControlEventTouchUpInside];
    [_scro addSubview:button];
    
    
    
    //文字
//    NSArray *arr=@[@"真实姓名",@"登录密码",@"密码确认",@"交易密码",@"密码确认",@"推荐手机"];
//    for(int i=0;i<6;i++)
//    {
//        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320, (27+i*50)*screenWidth/320, 80*screenWidth/320, 30*screenWidth/320)];
//        lab.text=arr[i];
//        lab.font=[UIFont systemFontOfSize:15];
//        lab.textColor=[UIColor lightGrayColor];
//        [_scro addSubview:lab];
//    }
//    
//    //竖灰条
//    for(int i=0;i<6;i++)
//    {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(95*screenWidth/320, (35+i*50)*screenWidth/320, 1, 15*screenWidth/320)];
//        view.backgroundColor=[UIColor grayColor];
//        [_scro addSubview:view];
//        
//    }
//    //textfield
//    for(int i=0;i<6;i++)
//    {
//        // User *user=[User currentUser];
//        if (i==0) {
//            _name=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320, 17*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
//            _name.delegate=self;
//            _name.font=[UIFont systemFontOfSize:14];
//            _name.placeholder=@"请输入真实姓名";
//            [ _name setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            [_scro addSubview: _name];
//        }
//        //        if (i==1) {
//        //            _nameId=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,67*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//        //            _nameId.delegate=self;
//        //            _nameId.placeholder=@"请输入身份证号码";
//        //
//        //            _nameId.font=[UIFont systemFontOfSize:14];
//        //            [_nameId setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//        //          //  _nameId.keyboardType = UIKeyboardTypeNumberPad;
//        //            [_scro addSubview:_nameId];
//        
//        // }
//        if (i==1) {
//            _regiNum=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,67*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//            _regiNum.delegate=self;
//            _regiNum.placeholder=@"登录密码";
//              _regiNum.keyboardType = UIKeyboardTypeNumberPad;
//            _regiNum.secureTextEntry=YES;
//            _regiNum.font=[UIFont systemFontOfSize:14];
//            [_regiNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            _regiNum.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            [_scro addSubview:_regiNum];
//        }
//        if (i==2) {
//            _oKreg=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,117*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//            _oKreg.delegate=self;
//            _oKreg.placeholder=@"确认登录密码";
//            _oKreg.secureTextEntry=YES;
//              _oKreg.keyboardType = UIKeyboardTypeNumberPad;
//            _oKreg.font=[UIFont systemFontOfSize:14];
//            [_oKreg setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            _oKreg.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            [_scro addSubview:_oKreg];
//        }
//        if (i==3) {
//            _deal=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,167*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//            _deal.delegate=self;
//            //  _deal.placeholder=@"交易密码";
//            _deal.secureTextEntry=YES;
//            _deal.placeholder=@"交易密码";
//             _deal.keyboardType = UIKeyboardTypeNumberPad;
//            _deal.font=[UIFont systemFontOfSize:14];
//            [_deal setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            _deal.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            [_scro addSubview:_deal];
//        }
//        if (i==4) {
//            _oKdeal=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,217*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//            _oKdeal.delegate=self;
//            _oKdeal.placeholder=@"确认交易密码";
//            // _oKdeal.placeholder=@"确认登录密码";
//            _oKdeal.secureTextEntry=YES;
//             _oKdeal.keyboardType = UIKeyboardTypeNumberPad;
//            _oKdeal.font=[UIFont systemFontOfSize:14];
//            [_oKdeal setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            _oKdeal.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            [_scro addSubview:_oKdeal];
//        }
//        if (i==5) {
//            _phonenum=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,267*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
//            _phonenum.delegate=self;
//            
//            _phonenum.placeholder=@"请输入推荐人的手机号";
//            _phonenum.font=[UIFont systemFontOfSize:14];
//            [_phonenum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//            _phonenum.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            
//            [_scro addSubview:_phonenum];
//        }
//        
//    }
    NSArray *arr=@[@"真实姓名",@"登录密码",@"交易密码",@"推荐手机"];
    for(int i=0;i<4;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320, (27+i*50)*screenWidth/320, 80*screenWidth/320, 30*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:15];
        lab.textColor=[UIColor lightGrayColor];
        [_scro addSubview:lab];
    }
    
    //竖灰条
    for(int i=0;i<4;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(95*screenWidth/320, (35+i*50)*screenWidth/320, 1, 15*screenWidth/320)];
        view.backgroundColor=[UIColor grayColor];
        [_scro addSubview:view];
        
    }
    //textfield
    for(int i=0;i<4;i++)
    {
        // User *user=[User currentUser];
        if (i==0) {
            _name=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320, 17*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _name.delegate=self;
            _name.font=[UIFont systemFontOfSize:14];
            _name.placeholder=@"请输入真实姓名";
            [ _name setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [_scro addSubview: _name];
        }
        if (i==1) {
            _regiNum=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,67*screenWidth/320, 185*screenWidth/320, 50*screenWidth/320) ];
            _regiNum.delegate=self;
            _regiNum.placeholder=@"登录密码";
            _regiNum.font=[UIFont systemFontOfSize:14];
            [_regiNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _regiNum.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            //UIImageView *leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            //leftView.image=[UIImage imageNamed:@""]
            
            regimage=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 20*screenWidth/320, 20*screenWidth/320)];
            regimage.image=[UIImage imageNamed:@"xianshi2@3x(1).png"];
            regimage.userInteractionEnabled=YES;
            _regiNum.rightView=regimage;
            _regiNum.rightViewMode=UITextFieldViewModeAlways;
            [_scro addSubview:_regiNum];
            
//            regimage=[[UIImageView alloc] initWithFrame:CGRectMake(280*screenWidth/320,75*screenWidth/320, 30*screenWidth/320, 30*screenWidth/320)];
//            regimage.image=[UIImage imageNamed:@"xianshi2@3x(1).png"];
//            regimage.userInteractionEnabled=YES;
            //[_scro addSubview:regimage];
            
            UIButton *paswButton=[UIButton buttonWithType:UIButtonTypeCustom];
            paswButton.frame=CGRectMake(280*screenWidth/320,75*screenWidth/320, 30*screenWidth/320, 30*screenWidth/320);
            [paswButton addTarget:self action:@selector(paswBtn) forControlEvents:UIControlEventTouchUpInside];
            [_scro addSubview:paswButton];

        }
        if (i==2) {
            _deal=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,117*screenWidth/320, 185*screenWidth/320, 50*screenWidth/320) ];
            _deal.delegate=self;
           // _deal.secureTextEntry=YES;
            _deal.placeholder=@"交易密码";
            _deal.font=[UIFont systemFontOfSize:14];
            _deal.userInteractionEnabled=YES;
            [_deal setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _deal.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            dealimage=[[UIImageView alloc] initWithFrame:CGRectMake(0*screenWidth/320,0*screenWidth/320, 20*screenWidth/320, 20*screenWidth/320)];
            dealimage.image=[UIImage imageNamed:@"xianshi2@3x(1)"];
            _deal.rightView=dealimage;
            _deal.rightViewMode=UITextFieldViewModeAlways;
            dealimage.userInteractionEnabled=YES;
            //[_scro addSubview:dealimage];
            [_scro addSubview:_deal];

            
            dealButton=[UIButton buttonWithType:UIButtonTypeCustom];
            dealButton.frame=CGRectMake(280*screenWidth/320,125*screenWidth/320, 40*screenWidth/320, 30*screenWidth/320);
            [dealButton addTarget:self action:@selector(dealBtn) forControlEvents:UIControlEventTouchUpInside];
            [_scro addSubview:dealButton];
        }
        if (i==3) {
            _phonenum=[[UITextField alloc] initWithFrame:CGRectMake(110*screenWidth/320,167*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320) ];
            _phonenum.delegate=self;
            
            _phonenum.placeholder=@"请输入推荐人的手机号";
            _phonenum.font=[UIFont systemFontOfSize:14];
            [_phonenum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _phonenum.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            [_scro addSubview:_phonenum];
        }
        
    }
}

-(void)paswBtn
{
    if(isClicked==NO)
    {
        _regiNum.secureTextEntry=YES;
        regimage.image=[UIImage imageNamed:@"xianshi@3x.png"];
        isClicked=YES;
    }
    else
    {
        _regiNum.secureTextEntry=NO;
        regimage.image=[UIImage imageNamed:@"xianshi2@3x(1).png"];
        isClicked=NO;
    }
}
-(void)dealBtn
{
    if(isclicked==NO)
    {
        _deal.secureTextEntry=YES;
        dealimage.image=[UIImage imageNamed:@"xianshi@3x.png.png"];
        isclicked=YES;
    }
    else
    {
        _deal.secureTextEntry=NO;
        dealimage.image=[UIImage imageNamed:@"xianshi2@3x(1).png"];
        isclicked=NO;
    }
}

//注册点击事件
-(void)regClick
{
    
    
    //    //校验手机号
    if (_name.text == nil||[@"" isEqual:_name.text]) {
        [self toastResult:@"请输入真实姓名"];
        return;
    }
       
    if (_regiNum.text ==nil||[@"" isEqual:_regiNum.text]) {
        [self toastResult:@"请输入登陆密码"];
        return;
    }
    if (_regiNum.text.length !=6){
        [self toastResult:@"登陆密码为6位数字组成"];
        return;
    }
    
//    if (_oKreg.text ==nil||[@"" isEqual:_oKreg.text]) {
//        [self toastResult:@"请输入确认登陆密码"];
//        return;
//    }
    if (_deal.text ==nil||[@"" isEqual:_deal.text]) {
        [self toastResult:@"请输入交易密码"];
        return;
    }
    if(_deal.text.length !=6){
        [self toastResult:@"密码为6位数字组成"];
        return;
    }
//    if (_oKdeal.text ==nil||[@"" isEqual:_oKdeal.text]) {
//        [self toastResult:@"请输入确认交易密码"];
//        return;
//    }
    if (_phonenum.text ==nil||[@"" isEqual:_phonenum.text]) {
        [self toastResult:@"请输入推荐人手机号"];
        return;
    }
    if (_deal.text.length>0&&_regiNum.text.length>0&& [_deal.text isEqualToString:_regiNum.text]) {
        [self toastResult:@"登录密码和交易密码不允许一样"];
        return;
    }
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSString *str1 = [_name.text stringByAddingPercentEscapesUsingEncoding:enc];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url3 andKeyArr:@[@"agentId",@"loginId",@"merName",@"certId",@"smsCode",@"chnlId",@"loginPwd",@"transPwd"]andValueArr:@[can,self.text,str1,@" ",self.yan,_phonenum.text,[MyMD5 md5:_regiNum.text],[MyMD5 md5:_deal.text]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    //    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"zhuce%@",dic);
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"zhuce%@",dic);
    
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    
    if ([[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        User *user=[User currentUser];
        user.yuanText=_regiNum.text;
        user.yanText=_deal.text;
        
    }
    [_name resignFirstResponder];
    
    [_nameId resignFirstResponder];
    
    [_regiNum resignFirstResponder];
    
    [_oKreg resignFirstResponder];
    
    [_deal resignFirstResponder];
    
    [_oKdeal resignFirstResponder];
    
    [_phonenum resignFirstResponder];
    
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
    [_name resignFirstResponder];
    
    [_nameId resignFirstResponder];
    
    [_regiNum resignFirstResponder];
    
    [_oKreg resignFirstResponder];
    
    [_deal resignFirstResponder];
    
    [_oKdeal resignFirstResponder];
    
    [_phonenum resignFirstResponder];
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
