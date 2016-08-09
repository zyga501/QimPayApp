//
//  nextFanyongViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextFanyongViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
@interface nextFanyongViewController ()
{
    UITextField *_num;
    
    UITextField *_sect;
    
    UILabel *_labOne;
}
@end

@implementation nextFanyongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"返佣资金转出" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)makeUI
{
    
    NSArray *arr=@[@"转出金额",@"交易密码"];
    for(int i=0;i<2;i++)
    {
        UILabel *leftLab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (100+i*60)*screenWidth/320, 100*screenWidth/320, 50*screenWidth/320)];
        leftLab.text=arr[i];
        leftLab.font=[UIFont systemFontOfSize:15];
        leftLab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:leftLab];
        
    }
    
    //纵向灰线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(95*screenWidth/320, (114+i*61)*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    //横向灰色的线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (140+i*60)*screenWidth/320, 280*screenWidth/320, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    

    
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _num=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _num.delegate=self;
            _num.font=[UIFont systemFontOfSize:16];
            _num.placeholder=@"请输入转出金额";
            //只输入数字和小数点键盘
            _num.keyboardType= UIKeyboardTypeDecimalPad;

            [_num setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
          
            [self.view addSubview:_num];
        }
        if (i==1) {
            _sect=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320,160*screenWidth/320, 150*screenWidth/320, 50*screenWidth/320) ];
           _sect.delegate=self;
            _sect.font=[UIFont systemFontOfSize:16];
            _sect.placeholder=@"请输入交易密码";
            _sect.secureTextEntry=YES;
            [_sect setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _sect.autocapitalizationType=UITextAutocapitalizationTypeNone;
//            _sect.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview:_sect];
        }
    }

//    
//    _labOne=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 208*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
//    _labOne.text =@"返佣账户余额";
//    _labOne.textAlignment=NSTextAlignmentRight;
//    _labOne.font=[UIFont systemFontOfSize:13];
//    _labOne.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:_labOne];
//    
//    
//    UILabel *la1=[[UILabel alloc] initWithFrame:CGRectMake(130*screenWidth/320, 208*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
//    la1.text =@"元, 可转出余额";
//    la1.font=[UIFont systemFontOfSize:13];
//    la1.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:la1];
//    
//    
//    
//    UILabel *la2=[[UILabel alloc] initWithFrame:CGRectMake(270*screenWidth/320, 208*screenWidth/320, 230*screenWidth/320, 20*screenWidth/320)];
//    la2.text =@"元";
//    la2.font=[UIFont systemFontOfSize:13];
//    la2.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:la2];
//    
    
    User *user=[User currentUser];
    
    //返佣
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"RATE"]];
    //
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    user.fanYong=[dic1 objectForKey:@"avlBal"];
    
    NSString *many1 =[dic1 objectForKey:@"acctBal"];
    NSString *many2 =[dic1 objectForKey:@"avlBal"];
    UILabel *labManry=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 208*screenWidth/320, 270*screenWidth/320, 20*screenWidth/320)];
    labManry.font=[UIFont systemFontOfSize:13];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"返佣账户余额%@分,可转出余额%@分",many1,many2]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(6,many1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(13+many1.length,many2.length)];
    
    labManry.attributedText = str;
    // labManry.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:labManry];
 
    
    
    //确认按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30*screenWidth/320, 240*screenWidth/320,screenWidth-60*screenWidth/320,40*screenWidth/320);
//    [button setBackgroundImage:[UIImage imageNamed:@"lh_xiayibu.png"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1]];
    [button setTitle:@"确认转出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(noBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //须知
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 300*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"须知";
    lab.font=[UIFont boldSystemFontOfSize:13];
    lab.textColor=[UIColor blackColor];
    [self.view addSubview:lab];
    

    
    NSArray *titleArr=@[@"❶ 返回资金为贵方推荐商户刷卡的返利",@"❷ 你可将你的返佣资金转入到现金账户",@"❸ 转出资金可提现或购买APP中的相关产品"];
    for(int i=0;i<3;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (330+i*30)*screenWidth/320, 250*screenWidth/320, 20*screenWidth/320)];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=titleArr[i];
        lab.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:lab];
    }
    
}
//确认按钮的点击事件
-(void)noBtn
{
    
    //返佣记录
    User * user = [User currentUser];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);

        //自动添加小数点后两位
    NSString *text=[NSString stringWithFormat:@"%.2f",[_num.text doubleValue]];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url21 andKeyArr:@[@"merId",@"transAmt",@"transPwd",@"clientModel"]andValueArr:@[user.merid,text,[MyMD5 md5:_sect.text],[[UIDevice currentDevice] model]]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"---------------------------------%@",dic);
    
    
    if([dic objectForKey:@"respDesc"])
    {
        [self toastResult:sre];
    }
    if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        UIViewController *tempVC = self.navigationController.viewControllers[1];
        //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
        //然后通过数组的下表确定我们想去的VC
        [self.navigationController popToViewController:tempVC animated:YES];
        //将当前VC与想去的VC之间的所有VC执行出栈操作，最后把想去的VC显示出来
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
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
