//
//  changeLoginViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "changeLoginViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "MyMD5.h"
#import "PostAsynClass.h"
#import "User.h"
@interface changeLoginViewController ()

{
    UITextField *_number;
    
    UITextField *_log;
    
    UITextField *_ok;
    
}

@end

@implementation changeLoginViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"更改登录密码" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    NSArray *arr=@[@"当前密码",@"登录密码",@"确认密码"];
    for(int i=0;i<3;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (94+i*50)*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:lab];
        
    }

    //横条竖条
    for(int i=0;i<3;i++)
    {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (120+i*50)*screenWidth/320, self.view.frame.size.width-10, 1*screenWidth/320)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    }
    
    
    for(int i=0;i<3;i++)
    {
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(95*screenWidth/320, (93+i*50)*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
        view1.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view1];
    }

    
    for(int i=0;i<3;i++)
    {
        if (i==0) {
            _number =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 84*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _number.delegate=self;
           _number.secureTextEntry = YES;
            _number.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview:_number];
        }
        if (i==1) {
            _log =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _log.secureTextEntry=YES;
            _log.delegate=self;
            _log.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview:_log];
        }
        if (i==2) {
            _ok =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 184*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
             _ok.delegate=self;
             _ok.secureTextEntry=YES;
            _ok.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview: _ok];
        }

    
    }
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 230*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"密码由6位的数字组成";
    lab.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:lab];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 270*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"确认更改" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:56/255.0 green:58/255.0 blue:77/255.0 alpha:1];
    [btn addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
-(void)button:(UIButton*)btn
{
    
    //校验密码
    User *user=[User currentUser];
    NSLog(@"密码为%@",user.yuanText);
        if (_number.text == nil||[@"" isEqual:_number.text])
        {
            [self toastResult:@"请输入当前密码"];
            return;
        }
        if(_number.text.length !=6)
        {
        [self toastResult:@"密码长度必须6位"];
        return;
        
    }
//    if(_number.text!=nil&&_number.text.length==6&&![_number.text isEqualToString:user.yuanText])
//    {
//        [self toastResult:@"请输入当前正确密码"];
//        return;
//
//    }
        if (_log.text == nil ||[@"" isEqual:_log.text]) {
            [self toastResult:@"请输入新密码"];
            return;
        }
     if(_log.text.length !=6||_ok.text.length!=6){
        [self toastResult:@"密码长度必须6位"];
        return;
         
    }
    if (![(_log.text) isEqual:(_ok.text)]) {
        [self toastResult:@"两次密码输入不一致"];
        return;
    }
    else
    {
        //更改登录密码
        NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url7 andKeyArr:@[@"agentId",@"loginId",@"oldPwd",@"newPwd"]andValueArr:@[can,user.phoneText,[MyMD5 md5:user.yuanText],[MyMD5 md5:_log.text]]];
        
        NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
        
        NSData *ata = [NSData alloc];
        
        ata = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"genggaidenglu%@",dic);
        if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            alertView.tag=1;
            user.yuanText=_log.text;
        }
        else
        {
            [self toastResult:@"请重新更改密码"];
            return;
        }
        

    }
     //User * user = [User currentUser];

        [_number resignFirstResponder];
        [_log resignFirstResponder];
        [_ok resignFirstResponder];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==1) {
        //防止返回到上一页闪退
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.25];    }
}
-(void)pop
{
    
    UIViewController *tempVC = self.navigationController.viewControllers[1];
    //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
    //然后通过数组的下表确定我们想去的VC
    [self.navigationController popToViewController:tempVC animated:YES];
    //将当前VC与想去的VC之间的所有VC执行出栈操作，最后把想去的VC显示出来
    
    
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
    [_number resignFirstResponder];
    [_log resignFirstResponder];
    [_ok resignFirstResponder];
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
