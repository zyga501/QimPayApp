//
//  TXXQViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/15.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "TXXQViewController.h"
#import "Header.h"
#import "User.h"
#import "MyNavigationBar.h"
@interface TXXQViewController ()
{
    
    UILabel *_time;
    UILabel *_date;
    UILabel *_num;
    UILabel *_money;
    UILabel *_shou;
    UILabel *_detail;
    UILabel *_zhang;
    UILabel *_kanum;
    
    
    UILabel *_bec;
    
}
@end

@implementation TXXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSLog(@"显示提现详情%@",self.ddic);
    // Do any additional setup after loading the view.
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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"提现详情" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
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
    
    for(int i=0;i<7;i++)
    {
        UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(0, (104+i*40)*screenWidth/320, self.view.frame.size.width, 1*screenWidth/320)];
        
        vi.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:vi];
        
    }
    
    NSArray *titleArr=@[@"提现时间",@"提现单号",@"提现金额",@"手续费",@"提现状态",@"提现账户",@"提现卡号"];
    for(int i=0;i<7;i++)
    {
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (74+i*40)*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
        lab.textColor=[UIColor grayColor];
        lab.text=titleArr[i];
        lab.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:lab];
        
        
    }
    
    //日期
    _date=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 74*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _date.textColor=[UIColor grayColor];
    _date.text=[self.ddic objectForKey:@"createDate"];
    NSLog(@"6767676767676767667676767%@",_date.text);
    
    //把20130303变成2013-03-03
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[ _date.text substringWithRange:range1],[ _date.text substringWithRange:range2],[ _date.text substringWithRange:range3]];
    _date.text=string1;
    NSLog(@"%@",string1);
    
    
    _date.textAlignment= NSTextAlignmentRight;
    _date.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_date];
    
    //时间
    _time=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 74*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _time.textColor=[UIColor grayColor];
    _time.textAlignment= NSTextAlignmentRight;
    _time.text=[self.ddic objectForKey:@"createTime"];
    
    
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_time.text substringWithRange:ran1],[_time.text substringWithRange:ran2],[_time.text substringWithRange:ran3]];
    _time.text=string2;
    
    
    _time.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_time];
    
    
    
    
    //订单号
    _num=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 114*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    _num.textColor=[UIColor grayColor];
    _num.textAlignment= NSTextAlignmentRight;
    _num.text=[self.ddic objectForKey:@"transSeqId"];
    _num.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_num];
    
    
    //提现金额
    _money=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 154*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _money.textColor=[UIColor grayColor];
    _money.textAlignment= NSTextAlignmentRight;
    _money.text=[self.ddic objectForKey:@"transAmt"];
    _money.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_money];
    
    
    //手续费
    _shou=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 194*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _shou.textColor=[UIColor grayColor];
    _shou.textAlignment= NSTextAlignmentRight;
    _shou.text=[self.ddic objectForKey:@"transFee"];
    _shou.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_shou];
    
    
    
    //提现状态
    _detail=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 234*screenWidth/320,80*screenWidth/320, 20*screenWidth/320)];
    _detail.textColor=[UIColor grayColor];
    _detail.textAlignment= NSTextAlignmentRight;
    _detail.text=[self.ddic objectForKey:@"transStat"];
    _detail.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_detail];
    
    
    
    //持卡人
    _zhang=[[UILabel alloc] initWithFrame:CGRectMake(210*screenWidth/320, 274*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
    _zhang.textColor=[UIColor grayColor];
    _zhang.textAlignment= NSTextAlignmentRight;
    _zhang.text=[self.ddic objectForKey:@"openAcctName"];
    _zhang.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_zhang];
    
    //支付卡号
    _kanum=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 314*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    _kanum.textColor=[UIColor grayColor];
    _kanum.textAlignment= NSTextAlignmentRight;
    _kanum.text=[self.ddic objectForKey:@"openAcctId"];
    
    
    
    NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
    
    [str1 appendFormat:@"%@",_kanum.text];
    
    NSInteger i = str1.length;
    if(i>10)
    {
        [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
 
    }    
    _kanum.text=str1;
    
    _kanum.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_kanum];

    //提现失败
    
    if ([[self.ddic objectForKey:@"transStat"]isEqualToString:@"失败"]) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 384*screenWidth/320, self.view.frame.size.width, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
        
        
        UILabel *bai=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 354*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        bai.text=@"失败原因";
        bai.font=[UIFont systemFontOfSize:14];
        bai.textColor=[UIColor grayColor];
        [self.view addSubview:bai];
        
        
        _bec=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 354*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
        _bec.textColor=[UIColor grayColor];
        _bec.textAlignment= NSTextAlignmentRight;
        _bec.text=[self.ddic objectForKey:@"failRemark"];
        _bec.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:_bec];
        
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
