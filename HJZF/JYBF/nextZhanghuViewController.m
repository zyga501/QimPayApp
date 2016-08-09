//
//  nextZhanghuViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextZhanghuViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "PostAsynClass.h"
@interface nextZhanghuViewController ()
{
    UIView *_image;
    
    UILabel *_nameLab;
    
    UILabel *_phoneLab;
    
    UILabel *_xiLab;
    
    UILabel *_zhuLab;
    
    UILabel *_time;
    
    UILabel *_body;
    
    UILabel *_shiMing;
    
    UILabel *_t0;
    
    UILabel *_t1;
    
    UILabel *_up;
    
    UILabel *_down;
    
    UILabel *_shangci;
    
    UILabel *_jiejiKa1;
    
    UILabel *_jiejiKa2;
    
    UILabel *_daijiKa;
    
    UIScrollView *_sv;
    
    NSArray *xinxiArray;
    
}
@end

@implementation nextZhanghuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self searchUserInformation];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];    // Do any additional setup after loading the view.
}
-(void)searchUserInformation
{
    User * user = [User currentUser];
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.one=[dic objectForKey:@"merName"];
    user.two=[dic objectForKey:@"loginId"];
    user.three=[dic objectForKey:@"merId"];
    user.four=[dic objectForKey:@"openDate"];
    
    user.six=[dic objectForKey:@"certId"];
    user.seven=[dic objectForKey:@"isAuthentication"];
    user.eight=[dic objectForKey:@"feeRateT0"];
    user.nine=[dic objectForKey:@"feeRateT1"];
    
    user.ten=[dic objectForKey:@"feeRateLiq1"];
    user.eleven=[dic objectForKey:@"feeRateLiq2"];
    
    user.jieji1=[dic objectForKey:@"debitFeeRateT0"];
    user.jieji2=[dic objectForKey:@"debitFeeRateT1"];
    NSLog(@"xiangxixinxi%@",dic);
    
}


-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"账户详情" andClass:self andSEL:@selector(bacClick:)];
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
    User *user=[User currentUser];
    
    _sv=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0)];
    _sv.backgroundColor=[UIColor whiteColor];
    _sv.delegate=self;
    _sv.showsVerticalScrollIndicator = NO;
    _sv.bounces=NO;
    
    //文字
    NSArray *titArr=@[@"姓名",@"手机号",@"系统编号",@"注册日期",@"上次登录时间",@"身份证号",@"绑定收款银行卡状态",@"提现手续费",@"提现手续费"];
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[user.four substringWithRange:range1],[user.four substringWithRange:range2],[user.four substringWithRange:range3]];
    
    NSRange ran1=NSMakeRange(0, 4);
    NSRange ran2=NSMakeRange(4, 2);
    NSRange ran3=NSMakeRange(6, 2);
    NSRange ran4=NSMakeRange(8, 2);
    NSRange ran5=NSMakeRange(10, 2);
    NSRange ran6=NSMakeRange(12, 2);
    NSString *string2=[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",[user.date substringWithRange:ran1],[user.date substringWithRange:ran2],[user.date substringWithRange:ran3],[user.date substringWithRange:ran4],[user.date substringWithRange:ran5],[user.date substringWithRange:ran6]];
    // NSLog(@"输出user.six为%@,%ld",user.six,user.six.length);
    if(user.six.length>1)
    {
        NSString*before=[user.six substringToIndex:6];
        NSString*after=[user.six substringFromIndex:14];
        NSString *string3=[[NSString alloc] initWithFormat:@"%@********%@", before, after];
        xinxiArray=@[user.one,user.two,user.three,string1,string2,string3,user.sm1,user.ten,user.eleven];
    }
    else
    {
        xinxiArray=@[user.one,user.two,user.three,string1,string2,@"",user.sm1,user.ten,user.eleven];
    }
    
    //灰色横条
    for(int i=0;i<titArr.count;i++)
    {
        UILabel *lab=[[UILabel alloc] init];
        if(i==7||i==8)
        {
            lab.frame= CGRectMake(20*screenWidth/320, (2.5+i*40)*screenWidth/320, 130*screenWidth/320, 15*screenWidth/320);
            
            UILabel *xianeLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (17.5+i*40)*screenWidth/320, 130*screenWidth/320, 15*screenWidth/320)];
            if(i==7)
            {
                xianeLabel.text=@"(5万元以下)";
            }
            else if(i==8)
            {
                xianeLabel.text=@"(5万元以上)";
            }
            xianeLabel.textAlignment=NSTextAlignmentLeft;
            xianeLabel.font=[UIFont systemFontOfSize:14];
            [_sv addSubview:xianeLabel];
            
        }
        else
        {
            lab.frame= CGRectMake(20*screenWidth/320, (5+i*40)*screenWidth/320, 130*screenWidth/320, 30*screenWidth/320);
        }
        lab.text=titArr[i];
        lab.font=[UIFont systemFontOfSize:15];
        lab.textAlignment=NSTextAlignmentLeft;
        [_sv addSubview:lab];
        
        UILabel *xinxiLabel=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, (5+i*40)*screenWidth/320, self.view.frame.size.width-170*screenWidth/320.0, 30*screenWidth/320.0)];
        xinxiLabel.textAlignment=NSTextAlignmentRight;
        xinxiLabel.font=[UIFont systemFontOfSize:15];
        if(i==5)
        {
            if ([user.sm isEqualToString:@"S"])
            {
                xinxiLabel.text=xinxiArray[i];
            }
            else
            {
                xinxiLabel.text=nil;
            }
        }
        else if(i==7||i==8)
        {
            xinxiLabel.text=[NSString stringWithFormat:@"%@元/笔",xinxiArray[i]];
        }
        else
        {
            xinxiLabel.text=xinxiArray[i];
        }
        [_sv addSubview:xinxiLabel];
        
        _image =[[UIView alloc] initWithFrame:CGRectMake(0, (39.5+i*40)*screenWidth/320, self.view.frame.size.width, 0.5*screenWidth/320)];
        _image.backgroundColor=[UIColor lightGrayColor];
        [_sv addSubview:_image];
    }
    
    _sv.contentSize=CGSizeMake(self.view.frame.size.width, titArr.count*40*screenWidth/320.0);
    [self.view addSubview:_sv];
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
