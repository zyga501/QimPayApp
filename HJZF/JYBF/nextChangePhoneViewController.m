//
//  nextChangePhoneViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/8/3.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextChangePhoneViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "NSString+Extension.h"
#import "User.h"
@interface nextChangePhoneViewController ()
{
    UILabel *_nowPhoneNum;
    
    UITextField *_newPhone;
    
    
    UIAlertView * _alertView1;
    
    
}
@end

@implementation nextChangePhoneViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"输入新手机号" andClass:self andSEL:@selector(backClick:)];
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
    
    
    //横条
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (120+i*50)*screenWidth/320, self.view.frame.size.width-10, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    //竖条
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(90*screenWidth/320, (97+i*50)*screenWidth/320, 1, 15)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    
    
    NSArray *titArr=@[@"原手机号",@"新手机号"];
    for(int i=0;i<2;i++)
    {
        UILabel *lla=[[UILabel alloc] initWithFrame:CGRectMake(10, 90+i*50, 80, 30)];
        lla.text=titArr[i];
        lla.textColor=[UIColor grayColor];
        [self.view addSubview:lla];
    }
  
        User *user=[User currentUser];
       
            _nowPhoneNum =[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 84*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _nowPhoneNum.textColor=[UIColor grayColor];
            _nowPhoneNum.text=user.phoneText;
            [self.view addSubview:_nowPhoneNum];
 
            _newPhone =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _newPhone.delegate=self;
            _newPhone.text=@"";
           // [_newPhoneNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
            [self.view addSubview:_newPhone];
        
        
            NSLog(@"-=-=-=-=-=-=-=-=-%@",_newPhone.text);
   
   
          
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 240*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=btn.backgroundColor=[UIColor colorWithRed:56/255.0 green:58/255.0 blue:77/255.0 alpha:1];
    [btn addTarget:self action:@selector(btton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)btton:(UIButton*)btn
{
    NSString *phoneStr=_newPhone.text;
    BOOL phoneBool=[phoneStr isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }
    
    
    User *user=[User currentUser];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url31 andKeyArr:@[@"agentId",@"merId",@"loginId",@"smsCode"]andValueArr:@[can,user.merid,_newPhone.text,self.yanText]];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
  
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];

    
    NSLog(@"genggaishouji%@",dic);
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    else
    {
        _alertView1= [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码更改成功，请重新登陆" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [_alertView1 show];
        _alertView1.tag=1;
        user.phoneText=_newPhone.text;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_alertView1.tag==1) {
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
  }

-(void)pop
{
 
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
    
    [ _nowPhoneNum resignFirstResponder];
    
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
