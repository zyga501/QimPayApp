//
//  nextZZViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/6.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "nextZZViewController.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "MyNavigationBar.h"
#import "MBProgressHUD+CZ.h"
@interface nextZZViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UITextField *_textView;
    UITextField *numTextField;
    UITextField *transPWD;
}
@end

@implementation nextZZViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"转账第二步" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)makeUI
{
   
    
    //基本信息
//    User *user=[User currentUser];
//    
//    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,self.phoneString]];
//    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
//    
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    
//    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
//    
//    NSData *ata = [NSData alloc];
//    
//    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"用户基本信息为%@",dic);

    //收款人姓名
    NSArray *titileArray=@[@"收款人姓名",@"收款人手机号",@"转账金额",@"转账说明",@"交易密码"];
    for(int i=0;i<titileArray.count;i++)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(25*screenWidth/320.0, (82+i*45)*screenWidth/320, 100*screenWidth/320.0, 40*screenWidth/320.0)];
        label.text=titileArray[i];
        label.textAlignment=NSTextAlignmentRight;
        label.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, (79.2+(i+1)*45)*screenWidth/320, self.view.frame.size.width-40*screenWidth/320.0, 0.5*screenWidth/320.0)];
        view.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view];
        
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(130.3*screenWidth/320.0, (86.5+i*45)*screenWidth/320, 0.5*screenWidth/320.0, 35*screenWidth/320.0)];
        view1.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view1];
        
    }
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(145*screenWidth/320.0, 85*screenWidth/320.0, 120*screenWidth/320.0, 35*screenWidth/320.0)];
    //nameLabel.text=[dic objectForKey:@"merName"];
    nameLabel.text=self.nameString;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font= [UIFont systemFontOfSize:14];
    [self.view addSubview:nameLabel];
    //收款人手机号
    phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(145*screenWidth/320.0, 130*screenWidth/320.0, 120*screenWidth/320.0, 35*screenWidth/320.0)];
    phoneLabel.text=self.phoneString;
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font= [UIFont systemFontOfSize:14];
    [self.view addSubview:phoneLabel];
    //收款金额
    numTextField=[[UITextField alloc] initWithFrame:CGRectMake(145*screenWidth/320.0, 175*screenWidth/320.0, 120*screenWidth/320.0, 35*screenWidth/320.0)];
    numTextField.delegate=self;
    numTextField.textAlignment=NSTextAlignmentLeft;
    numTextField.font=[UIFont systemFontOfSize:14];
    numTextField.placeholder=@"请输入转账金额";
    numTextField.keyboardType=UIKeyboardTypeDecimalPad;
    [self.view addSubview:numTextField];
    //收款说明
    _textView=[[UITextField alloc] initWithFrame:CGRectMake(145*screenWidth/320, 220*screenWidth/320, 120*screenWidth/320.0, 35*screenWidth/320)];
    _textView.font= [UIFont fontWithName:@"Arial"size:14.0];
    _textView.placeholder=@"请输入转账说明";
    _textView.text=@"货款";
    _textView.delegate=self;
    _textView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];
    
    //交易密码
    
    transPWD=[[UITextField alloc] initWithFrame:CGRectMake(145*screenWidth/320.0, 265*screenWidth/320.0, 120*screenWidth/320.0, 35*screenWidth/320.0)];
    transPWD.delegate=self;
    transPWD.textAlignment=NSTextAlignmentLeft;
    transPWD.font=[UIFont systemFontOfSize:14];
    transPWD.secureTextEntry=YES;
    transPWD.placeholder=@"请输入交易密码";
    [self.view addSubview:transPWD];
    
    //确认转账
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(20*screenWidth/320.0, 350*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 30*screenWidth/320.0);
    [nextButton setTitle:@"确认转账" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.borderWidth=0.5;
    nextButton.layer.cornerRadius=4;
    nextButton.clipsToBounds=YES;
    nextButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:nextButton];
     
}
-(void)nextBtn
{
    //[[UIDevice currentDevice] model]
   // double i=[numTextField.text floatValue];
    //User *user=[User currentUser];
    if(numTextField.text==nil)
    {
        [self toastResult:@"金额不能为空"];
        return;
    }
    if(transPWD.text==nil||transPWD.text.length!=6)
    {
        [self toastResult:@"请重新输入交易密码" ];
        return;
    }
    if(_textView.text==nil||_textView.text.length>=20)
    {
        [self toastResult:@"转账说明在1~20个字符内" ];
        return;
    }
    else
    {
        [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *string=[NSString stringWithFormat:@"%.2f",[numTextField.text doubleValue]];
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url33 andKeyArr:@[@"agentId",@"merId",@"mobile",@"trfTitle",@"transAmt",@"transPwd",@"clientModel"]andValueArr:@[can,self.merIdString,self.phoneString,_textView.text,string,[MyMD5 md5:transPWD.text],[[UIDevice currentDevice] model]]];
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"交易信息为%@",dic);
            NSString *sre1 = [dic objectForKey:@"respDesc"];
            if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"交易成功成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                alertView.tag=1;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }else
            {
                [self toastResult:sre1];
            }

        });
        
    }
    [numTextField resignFirstResponder];
    [_textView resignFirstResponder];
    [transPWD resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numTextField resignFirstResponder];
    [_textView resignFirstResponder];
    [transPWD resignFirstResponder];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)bacClick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
