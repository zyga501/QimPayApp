//
//  nextShouKuanViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/27.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextShouKuanViewController.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "Header.h"

@interface nextShouKuanViewController ()

@end

@implementation nextShouKuanViewController
{
  
    UILabel *_dateLab;
    UILabel *_timeLab;
    UILabel *_num;
    UILabel *_jiao;
    UILabel *_shou;
    UILabel *_zhuang;
    UILabel *_speak;
    UILabel *_name;
    UILabel *_number;
    UILabel *_bec;
    UILabel *_tt;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self makeNav];
    [self makeUI];
  
    self.view.backgroundColor=[UIColor whiteColor];
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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"收款详情" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}

-(void)makeUI
{
    for(int i=0;i<9;i++)
    {
        UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(0, (104+i*40)*screenWidth/320, self.view.frame.size.width, 1*screenWidth/320)];
    
        vi.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:vi];
        
    }
    
    NSArray *titleArr=@[@"交易时间",@"交易单号",@"交易金额",@"手续费",@"交易状态",@"收款方式",@"订单说明",@"持卡人",@"支付卡号"];
    for(int i=0;i<9;i++)
    {
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (74+i*40)*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
        lab.textColor=[UIColor grayColor];
        lab.text=titleArr[i];
        lab.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:lab];
        
        
    }
    
    //日期
    _dateLab=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 74*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _dateLab.textColor=[UIColor grayColor];
     _dateLab.textAlignment= NSTextAlignmentRight;
    _dateLab.text=[self.ndic objectForKey:@"createDate"];
    //把20130303变成2013-03-03
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dateLab.text substringWithRange:range1],[_dateLab.text substringWithRange:range2],[_dateLab.text substringWithRange:range3]];
    _dateLab.text=string1;
    NSLog(@"%@",string1);
    
    NSLog(@"6767676767676767667676767%@",_dateLab.text);
    _dateLab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_dateLab];
    
    
    //时间
    _timeLab=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 74*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _timeLab.textColor=[UIColor grayColor];
     _timeLab.textAlignment= NSTextAlignmentRight;
    _timeLab.text=[self.ndic objectForKey:@"createTime"];
    
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_timeLab.text substringWithRange:ran1],[_timeLab.text substringWithRange:ran2],[_timeLab.text substringWithRange:ran3]];
    _timeLab.text=string2;

    
    _timeLab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_timeLab];
    
    
    //订单号
    _num=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 114*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    _num.textColor=[UIColor grayColor];
     _num.textAlignment= NSTextAlignmentRight;
   _num.text=[self.ndic objectForKey:@"transSeqId"];
    _num.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_num];

    
    //交易金额
    _jiao=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 154*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _jiao.textColor=[UIColor grayColor];
     _jiao.textAlignment= NSTextAlignmentRight;
    _jiao.text=[self.ndic objectForKey:@"transAmt"];
    _jiao.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_jiao];
    
    
    //手续费
    _shou=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 194*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _shou.textColor=[UIColor grayColor];
     _shou.textAlignment= NSTextAlignmentRight;
    _shou.text=[self.ndic objectForKey:@"transFee"];
    _shou.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_shou];
    
    
    
    //交易状态
    _zhuang=[[UILabel alloc] initWithFrame:CGRectMake(210*screenWidth/320, 234*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
    _zhuang.textColor=[UIColor grayColor];
     _zhuang.textAlignment= NSTextAlignmentRight;
    _zhuang.text=[self.ndic objectForKey:@"transStat"];
    _zhuang.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_zhuang];
    
    
    
    
    //收款方式
    _tt=[[UILabel alloc] initWithFrame:CGRectMake(210*screenWidth/320, 274*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
    _tt.textColor=[UIColor grayColor];
    _tt.textAlignment= NSTextAlignmentRight;
    _tt.text=[self.ndic objectForKey:@"liqType"];
    _tt.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_tt];
    
    
    //订单说明
    _shou=[[UILabel alloc] initWithFrame:CGRectMake(200*screenWidth/320, 314*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    _shou.textColor=[UIColor grayColor];
     _shou.textAlignment= NSTextAlignmentRight;
    _shou.text=[self.ndic objectForKey:@"ordRemark"];
    _shou.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_shou];
    
    
    //持卡人
    _name=[[UILabel alloc] initWithFrame:CGRectMake(210*screenWidth/320, 354*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
    _name.textColor=[UIColor grayColor];
     _name.textAlignment= NSTextAlignmentRight;
    _name.text=[self.ndic objectForKey:@"acctName"];
    _name.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_name];
    
    //支付卡号
        _number=[[UILabel alloc] initWithFrame:CGRectMake(150*screenWidth/320, 394*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
        _number.textColor=[UIColor grayColor];
     _number.textAlignment= NSTextAlignmentRight;
        _number.text=[self.ndic objectForKey:@"acctId"];
    NSLog(@"%@",[self.ndic objectForKey:@"acctId"]);
     if ([[self.ndic objectForKey:@"transStat"]isEqualToString:@"交易成功"]) {
         
         NSString *str2 =[self.ndic objectForKey:@"acctId"];

         if (str2.length<10)
         {
             _number.text=str2;
         }
         else
         {
             
             NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
             
             [str1 appendFormat:@"%@",str2];
             
             NSInteger i = str1.length;
             [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
             
             _number.text = str1;
         }
         
     }
        NSLog(@"0-0-00-0-0-0-0-0-0-0-0-00-%@",_number.text);
        _number.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:_number];
    
        
        
    
    
    
    //交易失败
    
    if ([[self.ndic objectForKey:@"transStat"]isEqualToString:@"交易失败"]) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 424*screenWidth/320, self.view.frame.size.width, 1)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
        
        
        UILabel *bai=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 394*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        bai.text=@"失败原因";
        bai.font=[UIFont systemFontOfSize:14];
        bai.textColor=[UIColor grayColor];
        [self.view addSubview:bai];
        
        
        _bec=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 394*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
        _bec.textColor=[UIColor grayColor];
         _bec.textAlignment= NSTextAlignmentRight;
        _bec.text=[self.ndic objectForKey:@"failRemark"];
        _bec.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:_bec];
        
    }  
    
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
