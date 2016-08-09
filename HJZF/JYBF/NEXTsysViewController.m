//
//  NEXTsysViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/7.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "NEXTsysViewController.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
#import "MyMD5.h"
#import "MBProgressHUD+CZ.h"
@interface NEXTsysViewController ()<UITextFieldDelegate>
{
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UILabel *numLabel;
    UILabel *textLabel;
    UILabel *ZHYElabel;
    UILabel *KYYElabel;
    UITextField *transPWd;
    
    NSArray *dateArray;
}
@end

@implementation NEXTsysViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"确认付款" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
}
-(void)makeUI
{
    User *user=[User currentUser];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    NSArray *titileArray=@[@"收款人姓名 ",@"收款人手机号 ",@"付款金额 ",@"付款说明 ",@"账户余额 ",@"可用余额 ",@"交易密码 "];
    for(int i=0;i<titileArray.count;i++)
    {
        UILabel *label=[[UILabel alloc] init];
        label.text=titileArray[i];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentRight;
        
        UIView *view1=[[UIView alloc] init];
        view1.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view1];
//        if(i==4)
//        {
//            label.frame=CGRectMake(30*screenWidth/320.0, (80+5*40)*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0);
//            view1.frame=CGRectMake(label.frame.origin.x+label.frame.size.width+0.5*screenWidth/320.0, (81+5*40)*screenWidth/320, 0.5*screenWidth/320.0, 34*screenWidth/320.0);
//            
//        }
////        }
//        else
//        {
            label.frame=CGRectMake(30*screenWidth/320.0, (80+i*40)*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0);
             view1.frame=CGRectMake(label.frame.origin.x+label.frame.size.width+8.5*screenWidth/320.0, (81+i*40)*screenWidth/320, 0.5*screenWidth/320.0, 34*screenWidth/320.0);
        //}
        [self.view addSubview:label];
        
    }
    
    
    for(int n=0;n<7;n++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, (119+n*40)*screenWidth/320, self.view.frame.size.width-60*screenWidth/320.0, 0.5*screenWidth/320.0)];
        view.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view];

    }
    //二维码扫描内容
   dateArray = [self.string componentsSeparatedByString:@"^"];
    NSLog(@"shuchuwei%@",dateArray);
    
//    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url32 andKeyArr:@[@"agentId",@"mobile"]andValueArr:@[[dateArray objectAtIndex:0],[dateArray objectAtIndex:3]]];
//    
//    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
//    
 //   NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    
//    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
//    
//    NSData *ata = [NSData alloc];
//    
//    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];

    //姓名
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 80*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0)];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont systemFontOfSize:14];
//    nameLabel.text=[dic objectForKey:@"merName"];
//    nameLabel.text=[dateArray objectAtIndex:2];
    nameLabel.text=self.namestring;
    [self.view addSubview:nameLabel];
    
    //手机号
    phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 120*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0)];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:14];
//    phoneLabel.text=[dateArray objectAtIndex:3];
    phoneLabel.text=self.phonenumstring;
    [self.view addSubview:phoneLabel];
    
    //付款金额
    numLabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 160*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0)];
    numLabel.textAlignment=NSTextAlignmentLeft;
    numLabel.font=[UIFont systemFontOfSize:14];
//    numLabel.text=[dateArray objectAtIndex:4];
    numLabel.text = self.numstring;
    [self.view addSubview:numLabel];
    
    //付款说明
    textLabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 200*screenWidth/320, 90*screenWidth/320.0, 35*screenWidth/320.0)];
    textLabel.textAlignment=NSTextAlignmentLeft;
    textLabel.font=[UIFont systemFontOfSize:14];
//    textLabel.text=[dateArray objectAtIndex:5];
    textLabel.text = self.textstring;
    [self.view addSubview:textLabel];

    //可用余额
    KYYElabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 280*screenWidth/320, self.view.frame.size.width-60*screenWidth/320.0, 35*screenWidth/320.0)];
    KYYElabel.textAlignment=NSTextAlignmentLeft;
    KYYElabel.font=[UIFont systemFontOfSize:13];
    NSLog(@"yuewei%f,%f",[user.KYyue doubleValue],[user.totAmtT1 doubleValue]);
    double num=[user.KYyue doubleValue]-[user.totAmtT1 doubleValue];
    if (num<0) {
        KYYElabel.text=@"0.00元";
    }
    else
    {
        KYYElabel.text=[NSString stringWithFormat:@"%.2f元",num];
    }
    [self.view addSubview:KYYElabel];
    
    //账户余额
    ZHYElabel=[[UILabel alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 240*screenWidth/320, 65*screenWidth/320.0, 35*screenWidth/320.0)];
    ZHYElabel.textAlignment=NSTextAlignmentLeft;
    ZHYElabel.font=[UIFont systemFontOfSize:13];
    ZHYElabel.text=[NSString stringWithFormat:@"%@元",user.yu];
    [self.view addSubview:ZHYElabel];

    //交易密码
    transPWd=[[UITextField alloc] initWithFrame:CGRectMake(134*screenWidth/320.0, 320*screenWidth/320, 120*screenWidth/320.0, 35*screenWidth/320.0)];
    transPWd.secureTextEntry=YES;
    transPWd.delegate=self;
    transPWd.placeholder=@"请输入交易密码";
    transPWd.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:transPWd];
    
    //确认付款按钮
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(30*screenWidth/320.0, 380*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 35*screenWidth/320.0);
    [button setTitle:@"确认付账" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
//    button.layer.borderWidth=0.5;
//    button.layer.cornerRadius=4;
//    button.clipsToBounds=YES;
    button.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:button];
}
#pragma mark  确认付款
-(void)nextBtn
{
    if(transPWd.text==nil)
    {
       [self toastResult:@"交易密码不能为空"]; 
    }
    else
    {
        [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url33 andKeyArr:@[@"agentId",@"merId",@"mobile",@"trfTitle",@"transAmt",@"transPwd",@"clientModel"]andValueArr:@[can,[dateArray objectAtIndex:1],[dateArray objectAtIndex:3],[dateArray objectAtIndex:2],[dateArray objectAtIndex:4],[MyMD5 md5:transPWd.text],[[UIDevice currentDevice] model]]];
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"交易信息为%@",dic);
            NSString *sre = [dic objectForKey:@"respDesc"];
            //NSString *sre1 = [dic objectForKey:@"respDesc"];
            if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                alertView.tag=1;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
            else if([[dic objectForKey:@"respCode"]isEqualToString:@"008"])
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                alertView.tag=2;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
            else
            {
                [self toastResult:sre];
            }
        });
        
    }
    [transPWd resignFirstResponder];
   
}
#pragma mark   返回上一界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==1)
    {
        //防止返回到上一页闪退
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.25];
    }
    if(alertView.tag==2)
    {
        if(!buttonIndex)
        {
            
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
-(void)pop
{
    
    UIViewController *tempVC = self.navigationController.viewControllers[1];
    //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
    //然后通过数组的下表确定我们想去的VC
    [self.navigationController popToViewController:tempVC animated:YES];
    //将当前VC与想去的VC之间的所有VC执行出栈操作，最后把想去的VC显示出来
    
    
}
//弹出框
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
//返回按钮
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stepIntoCamera" object:nil];
}
#pragma mark  键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [transPWd resignFirstResponder];
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
