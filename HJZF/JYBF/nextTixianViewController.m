//
//  nextTixianViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextTixianViewController.h"
#import "shimingViewController.h"

#import "MyNavigationBar.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyMD5.h"
#import "yinHangkaViewController.h"
#import "TXXQViewController.h"
#import "tiXianJiluViewController.h"
@interface nextTixianViewController ()
{
   ;
    
    
    UITextField *_num;
    
    UITextField *_money;
    
    UITextField *_secrect;
    
    
    UILabel *_lab;
    
    UILabel *_nameLab;
    
    UILabel *_kaLab;
    
    UILabel *_laa;
    NSString *sre;
    
     NSArray *_data;
}
@end

@implementation nextTixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    User *user=[User currentUser];
    if([user.sm isEqualToString:@"S"])
    {
        
        User *user=[User currentUser];
        
        _nameLab.text = user.kaname;
        NSString *str2 =user.jiekahao;
        NSLog(@"shchujiekahao%@",user.jiekahao);
        if(!([user.jiekahao isEqualToString:@""]||user.jiekahao==nil) )
        {
           
            NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
            
            [str1 appendFormat:@"%@",str2];
            
            NSInteger i = str1.length;
            if(i<=10)
            {
                _kaLab.text=user.jiekahao;
            }
            else
            {
                [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
                
                _kaLab.text = str1;
            }
            
        }
        double num=[user.KYyue doubleValue]-[user.totAmtT1 doubleValue];
        if(num<0)
            {
                _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为0.00元"];
            }
            else
            {
                _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为%@元",[NSString stringWithFormat:@"%.2f",num ]];
                NSLog(@"###########%@,%@,%f",user.KYyue,user.totAmtT1,num);
            }
    }

}
-(void)makeNav
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"提现" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"提现记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
}
#pragma mark  提现记录
-(void)navButtonClick
{
    tiXianJiluViewController *tvc=[[tiXianJiluViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    //须知
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20, 330*screenWidth/320, 50, 20)];
    lab.text=@"须知";
    lab.textColor=[UIColor blackColor];
    lab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:lab];

    //提示
    UILabel *labe=[[UILabel alloc] initWithFrame:CGRectMake(20, 360*screenWidth/320, self.view.frame.size.width-40, 20)];
    labe.text=@"●请在8:30-15:30时间段提现";
    labe.textColor=[UIColor grayColor];
    labe.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:labe];

    User *user=[User currentUser];
    
    
    if(![user.sm isEqualToString:@"S"])
    {

        if([user.sm isEqualToString:@"I"])
        {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以提现！" delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:nil,nil];
            [alert show];
            return;
        }
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以提现！" delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:@"我要绑定收款银行卡",nil];
        [alert show];
        //        _alert.tag=2;

        UIButton *btnn=[UIButton buttonWithType:UIButtonTypeSystem];
        btnn.frame=CGRectMake(100*screenWidth/320, 80*screenWidth/320, 230*screenWidth/320,40*screenWidth/320);
        [btnn addTarget:self action:@selector(btn1:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnn];
    }
    NSArray *arr=@[@"结算卡号",@"提现金额",@"交易密码"];
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
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (120+i*50)*screenWidth/320, self.view.frame.size.width-20, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
   
    for(int i=0;i<3;i++)
    {
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(90*screenWidth/320, (95+i*50)*screenWidth/320, 1*screenWidth/320, 15*screenWidth/320)];
        view1.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view1];
    }
    
    
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _money =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _money.delegate=self;
            double num=[user.KYyue doubleValue]-[user.totAmtT1 doubleValue];
            if([user.sm isEqualToString:@"S"])
            {
                if(num<0)
                {
                     _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为0.00元"];
                }
                else
                {
                    _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为%@元",[NSString stringWithFormat:@"%.2f",num ]];
                    NSLog(@"###########%@,%@,%f",user.KYyue,user.totAmtT1,num);
                }
           
            }
            //只输入数字和小数点键盘
            _money.keyboardType=UIKeyboardTypeDecimalPad;
            _money.font=[UIFont systemFontOfSize:14];
            [_money setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            NSLog(@"%@",user.KYyue);

            [self.view addSubview:_money];
        }
        if (i==1) {
            _secrect =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 184*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _secrect.delegate=self;
            _secrect.secureTextEntry=YES;
            //_ok.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview: _secrect];
        }
    }
    if([user.sm isEqualToString:@"S"])
    {
    
        //结算卡查询接口
        
        NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId",@"cardType"]andValueArr:@[user.merid,@"J"]];
        //
        NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
        
        NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
        
        NSData *ata3 = [NSData alloc];
        
        ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"shanghujiesuankachaxun%@",dic3);
        _data=[dic3 objectForKey:@"ordersInfo"];
        int i=0;
        for(NSDictionary *dicc in _data)
        {
            if(i==0)
            {
                user.jiekahao=[dicc objectForKey:@"openAcctId"];
                NSString *str2 =user.jiekahao;
                
                NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
                
                [str1 appendFormat:@"%@",str2];
                
                NSInteger num = str1.length;
                if(num>10)
                {
                   [str1 replaceCharactersInRange:NSMakeRange(num-10, 6) withString:@"******"];
                }
                user.jiekahao=str1;
                user.kaname=[dicc objectForKey:@"openBankName"];
                user.kaBian=[dicc objectForKey:@"liqCardId"];
 
            }
            i++;
        }

    //银行卡名字
    _nameLab =[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 88*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _nameLab.font=[UIFont systemFontOfSize:12];
      _nameLab.textColor=[UIColor lightGrayColor];
    _nameLab.text=user.kaname;
    NSLog(@"cccccccccccccccccccccccccccccccccccc%@",_nameLab.text);
    [self.view addSubview:_nameLab];

    //银行卡
    _kaLab =[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 100*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    _kaLab.font=[UIFont systemFontOfSize:12];
    _kaLab.textColor=[UIColor lightGrayColor];
    _kaLab.text=user.jiekahao;
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa%@",_kaLab.text);
   
    
    [self.view addSubview:_kaLab];
//
    }
 
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"xiangxixinxi%@",dic);
    NSString *many1 =[dic objectForKey:@"feeRateLiq1"];
    NSString *many2 =[dic objectForKey:@"feeRateLiq2"];
    UILabel *labManry=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 230*screenWidth/320, 300*screenWidth/320, 20*screenWidth/320)];
    labManry.font=[UIFont systemFontOfSize:12];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手续费五万以下%@元/笔,五万以上%@元/笔",many1,many2]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(7,many1.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(15+many1.length,many2.length)];
    
    labManry.attributedText = str1;
    labManry.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:labManry];
    

    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(270*screenWidth/320, 80*screenWidth/320,50*screenWidth/320, 50*screenWidth/320);
    [btn1 setImage:[UIImage imageNamed:@"lh_sanj.png"] forState:UIControlStateNormal];
    //btn1.backgroundColor=[UIColor yellowColor];
    [btn1 addTarget:self action:@selector(bttn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(10*screenWidth/320, 80*screenWidth/320,200*screenWidth/320, 50*screenWidth/320);
    
    [btn2 addTarget:self action:@selector(bttn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    //确认提现按钮
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 270*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"确认提现" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [btn addTarget:self action:@selector(btton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
//####################
-(void)bttn
{
    
    yinHangkaViewController *yin=[[yinHangkaViewController alloc] init];
    [self.navigationController pushViewController:yin animated:YES];
    
}
-(void)btn1:(UIButton*)btn
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入银行卡卡号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    
    [alter show];
    
}

//确认提现的点击事件
-(void)btton:(UIButton*)btn
{
    User *user=[User currentUser];

    //判断大小小于4
   
    if ([_money.text doubleValue]<=0.00) {
   
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"单笔金额不能为0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    //提现接口
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
   
    //自动添加小数点后两位
    NSString *text1=[NSString stringWithFormat:@"%.2f",[_money.text doubleValue]];
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url17 andKeyArr:@[@"merId",@"liqCardId",@"liqAmt",@"transPwd",@"clientModel",@"cardType"]andValueArr:@[user.merid,user.kaBian,text1,[MyMD5 md5:_secrect.text],[[UIDevice currentDevice] model],@"J"]];
    //
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    
     sre= [dic1 objectForKey:@"respDesc"];
    NSLog(@"tixian%@",dic1);
    
    
    if ([[dic1 objectForKey:@"respCode"] isEqualToString:@"000"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提现成功" message:@"你的提现申请已经成功，请注意银行资金账户变动" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
       
        [alter show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        return;
    }
    if ([dic1 objectForKey:@"respDesc"] ) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:sre delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
        return;
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
#pragma mark - 登陆失败之后显示的警示框
- (void)showFailAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark -触摸隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_num resignFirstResponder];
    [_money  resignFirstResponder];
    [_secrect resignFirstResponder];
    
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



//提示框的代理方法，可以监控到点击了提示框上哪个按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
        if (!buttonIndex) {
            UIViewController *tempVC = self.navigationController.viewControllers[1];
            //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
            //然后通过数组的下表确定我们想去的VC
            [self.navigationController popToViewController:tempVC animated:YES];
            } else {
        shimingViewController *shiming=[[shimingViewController alloc] init];
        [self.navigationController pushViewController:shiming animated:YES];
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
