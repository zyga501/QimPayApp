//
//  nextChangeJiaoyiViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextChangeJiaoyiViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "User.h"
@interface nextChangeJiaoyiViewController ()
{
    UITextField *_nowNum;
    
    UITextField *_newNum;
    
    
    UIAlertView * _alertView1;
}
@end

@implementation nextChangeJiaoyiViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"输入新密码" andClass:self andSEL:@selector(backClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)backClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    //横条竖条
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (120+i*50)*screenWidth/320, self.view.frame.size.width-10, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    
    
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _nowNum =[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320, 84*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _nowNum.delegate=self;
            _nowNum.secureTextEntry = YES;
            _nowNum.keyboardType = UIKeyboardTypeNumberPad;

            [_nowNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _nowNum.placeholder=@"输入新的交易密码";
            
           
            [self.view addSubview:_nowNum];
        }
        if (i==1) {
            _newNum =[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _newNum.delegate=self;
            _newNum.secureTextEntry = YES;
            _newNum.keyboardType = UIKeyboardTypeNumberPad;

            [_newNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _newNum.placeholder=@"确认新的交易密码";
            [self.view addSubview:_newNum];
        }
        
        
    }
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 200*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"密码由6位的数字组成";
    lab.textColor=[UIColor grayColor];
    lab.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:lab];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 240*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [btn addTarget:self action:@selector(btton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)btton:(UIButton*)btn
{
    User *user=[User currentUser];
    
    //校验手机号
    if (_nowNum.text == nil||[@"" isEqual:_nowNum.text]) {
        [self toastResult:@"请输入新密码"];
        return;
    }
    if (_nowNum.text.length !=6) {
        [self toastResult:@"密码为6位数字组成"];
        return;
    }
    
    if (_newNum.text == nil ||[@"" isEqual:_newNum.text]) {
        [self toastResult:@"请输入确认密码"];
        return;
    }
    if (![_nowNum.text isEqual:_newNum.text]) {
        [self toastResult:@"两次密码不一样"];
        return;
    }
         else
    {
        
        NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url8 andKeyArr:@[@"agentId",@"loginId",@"smsCode",@"newPwd"]andValueArr:@[can,self.phoneJText,  self.yanJText,[MyMD5 md5:_nowNum.text]]];
        NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
        
        NSData *ata = [NSData alloc];
        
        ata = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"genggaijiaoyi%@",dic);
        if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            _alertView1= [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码更新成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [_alertView1 show];
            _alertView1.tag=1;
            user.yanText=_newNum.text;
        }
        else
        {
            [self toastResult:@"请重新更改密码"];
            return;

        }

    }

    [_nowNum resignFirstResponder];
    [_newNum resignFirstResponder];
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
        if (_alertView1.tag==1) {
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
    [_newNum resignFirstResponder];
    [_nowNum resignFirstResponder];
    
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
