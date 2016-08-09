//
//  nextChangeViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/3/27.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextChangeViewController.h"
#import "changeViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "User.h"
@interface nextChangeViewController ()
{
    UITextField *_newPhone;
    
    UITextField *_newReg;
}
@end

@implementation nextChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createN];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

    // Do any additional setup after loading the view.
}
-(void)createN
{
    //导航
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"找回密码" andClass:self andSEL:@selector(backClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

}
-(void)makeUI
{
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _newPhone=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _newPhone.delegate=self;
            _newPhone.font=[UIFont systemFontOfSize:16];
            _newPhone.secureTextEntry=YES;
            _newPhone.placeholder=@"输入新的登录密码";
            [_newPhone setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
            [self.view addSubview:_newPhone];
        }
        if (i==1) {
            _newReg=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320,170*screenWidth/320, 150*screenWidth/320, 50*screenWidth/320) ];
            _newReg.delegate=self;
            _newReg.secureTextEntry=YES;
            _newReg.placeholder=@"确认新的登录密码";
            _newReg.font=[UIFont systemFontOfSize:16];
            [_newReg setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
           _newReg.autocapitalizationType=UITextAutocapitalizationTypeNone;
            
            [self.view addSubview: _newReg];
        }
    }
    
    _newPhone.tag=1;
    _newReg.tag=2;
    
    
    
    //灰色的线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (140+i*70)*screenWidth/320, 280*screenWidth/320, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    
    
    //提交
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30*screenWidth/320, 270*screenWidth/320,screenWidth-60*screenWidth/320,40*screenWidth/320);
    //[button setBackgroundImage:[UIImage imageNamed:@"lh_dengl.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:buttonImageselected forState:UIControlStateHighlighted];
    button.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1.0];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    
    //提示
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320, 230*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"密码由6位的数字或字母组成";
    lab.font=[UIFont systemFontOfSize:12];
    lab.textColor=[UIColor lightGrayColor];
    [self.view addSubview:lab];

}
//返回上一界面
-(void)backClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交点击事件
-(void)okClick
{
    //校验密码
        if (_newPhone.text == nil||[@"" isEqual:_newPhone.text]) {
            [self toastResult:@"新密码不能为空"];
            return;
        }
    if (_newReg.text == nil||[@"" isEqual:_newReg.text]) {
        [self toastResult:@"确认密码不能为空"];
        return;
    }

        if ([_newReg.text length]!=6||[_newPhone.text length]!=6) {
            [self toastResult:@"密码为6位数字或字母组成"];
            return;
        }
        if (![_newReg.text isEqual:_newPhone.text]) {
        [self toastResult:@"两次密码输入不一致"];
        return;
    }

    //[self.navigationController popToRootViewControllerAnimated:YES];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url7 andKeyArr:@[@"agentId",@"loginId",@"smsCode",@"newPwd"]andValueArr:@[can,_ptext,_ytext,[MyMD5 md5:_newPhone.text]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    User *user=[User currentUser];
    if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        UIAlertView *_alertView1= [[UIAlertView alloc]initWithTitle:@"密码更新成功" message:@"密码更新成功,请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [_alertView1 show];
        _alertView1.tag=1;
        user.yuanText=_newPhone.text;
    }
    else
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
        return;
        
    }

    NSLog(@"denglu%@",dic);
    
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
    [_newReg resignFirstResponder];
    [_newPhone resignFirstResponder];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if(alertView.tag==1)
    {
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
