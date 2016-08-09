//
//  changeViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/3/26.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "changeViewController.h"
#import "Header.h"
#import "nextChangeViewController.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "User.h"
#import "NSString+Extension.h"


@interface changeViewController ()

@end

@implementation changeViewController
{
    UITextField *_phoneNUm;
    
    UITextField *_yanNum;
    
    UIButton *_yanBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self makeUI];
     self.view.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)createNav
{
    //导航
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"找回密码" andClass:self andSEL:@selector(bbiClick:)];
    [self.view addSubview:mnb];
    
    
}


//返回上一界面
-(void)bbiClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    
    //User *user=[User currentUser];
    //NSLog(@"忘记密码输出%@,%@",user.phoneText,self.string);
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _phoneNUm=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _phoneNUm.delegate=self;
            _phoneNUm.font=[UIFont systemFontOfSize:16];
            _phoneNUm.placeholder=@"手机号码";
            [_phoneNUm setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
            _phoneNUm.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview:_phoneNUm];
        }
        if (i==1) {
            _yanNum=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320,170*screenWidth/320, 150*screenWidth/320, 50*screenWidth/320) ];
             _yanNum.delegate=self;
             _yanNum.placeholder=@"验证码";
             _yanNum.font=[UIFont systemFontOfSize:16];
            [ _yanNum setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
             _yanNum.keyboardType = UIKeyboardTypeNumberPad;
             _yanNum.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            [self.view addSubview: _yanNum];
        }
    }
   

    _phoneNUm.tag=1;
     _yanNum.tag=2;
    
    
    
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
    
    
    //注册
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30*screenWidth/320, 270*screenWidth/320,screenWidth-60*screenWidth/320,40*screenWidth/320);
    //[button setBackgroundImage:[UIImage imageNamed:@"lh_dengl.png"] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1.0];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(res1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}


-(void)yanBtn
{
    
    NSString *phoneStr=_phoneNUm.text;
    BOOL phoneBool=[phoneStr isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }
    //短信发送接口
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    //网络请求
    [paStr appendFormat:@"%@%@%@%@%@",can,_phoneNUm.text,@"01",@"",@"1234567890"];
    
    NSLog(@"%@",paStr);
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url4 andKeyArr:@[@"agentId",@"loginId",@"smsType",@"smsCon",@"chkValue"]andValueArr:@[can,_phoneNUm.text,@"01",@"",[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"yanzhengma%@",dic);


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
               // _yanBtn.userInteractionEnabled = YES;
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
-(void)res1Click
{

    //手机号网络请求
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    
    [paStr appendFormat:@"%@%@%@",can,_phoneNUm.text,@"1234567890"];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url6 andKeyArr:@[@"agentId",@"loginId",@"chkValue"]andValueArr:@[can,_phoneNUm.text,[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
   
    NSLog(@"shoujihao%@",dic);

    NSString *sre1 = [dic objectForKey:@"respDesc"];

    NSLog(@"shoujihao%@",dic);
    
    
     if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
     {
    
    //验证码网络请求
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url5 andKeyArr:@[@"agentId",@"loginId",@"smsCode"]andValueArr:@[can,_phoneNUm.text,_yanNum.text]];
    
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic1 objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
    }
    NSLog(@"yanzhengma%@",dic1);
    
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"N"])
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    
    [_phoneNUm resignFirstResponder];
    [_yanNum resignFirstResponder];
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"Y"])
    {
        
        nextChangeViewController *next=[[nextChangeViewController alloc] init];
        
        next.ptext=_phoneNUm.text;
        next.ytext=_yanNum.text;
        NSLog(@"-------000000000%@",next.ytext);
        [self.navigationController pushViewController:next animated:YES];
        
        
        [_phoneNUm resignFirstResponder];
        [_yanNum resignFirstResponder];

    }
    
     }
    else
    {
        if([[dic objectForKey:@"respCode"]isEqualToString:@"008"])
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            alertView.tag=2;
            
        }
        else
        {
            [self toastResult:sre1];
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
    [_phoneNUm resignFirstResponder];
    [_yanNum resignFirstResponder];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
        
        
    } else {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
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
