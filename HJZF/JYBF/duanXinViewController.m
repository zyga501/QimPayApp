//
//  duanXinViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/7.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "duanXinViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "nextDuanXinViewController.h"

@interface duanXinViewController ()<ABPeoplePickerNavigationControllerDelegate>
{
    UIScrollView *_scr;
    
      UITextField *_phone;
    
    
    //当前系统时间
    NSString *_datestr;
}
@end

@implementation duanXinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    _phone.text=user.tongxun;
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"短信收款" andClass:self andSEL:@selector(baclick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)baclick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{

    //获取当前时间
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSArray *zonearr=[NSTimeZone knownTimeZoneNames];
    NSLog(@"%@",zonearr);
    
    _datestr=[formatter stringFromDate:date];
    
    NSLog(@"0000000----------           %@",_datestr);
    
    
    
   
    //scrolView布局
    _scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenWidth, screenHeight)];
    
    _scr.contentSize = CGSizeMake(0, 568);
    _scr.bounces = NO;//设置是否反弹
    _scr.delegate=self;
    _scr.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    [self.view addSubview:_scr];
    
    
    
  //  白色背景
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 50)];
    view.backgroundColor=[UIColor whiteColor];
    [_scr addSubview:view];
    
    //textfield
     User *user=[User currentUser];
    _phone=[[UITextField alloc] initWithFrame:CGRectMake(90*screenWidth/320, 10*screenWidth/320, 130*screenWidth/320, 30*screenWidth/320)];
    _phone.delegate=self;
    _phone.font=[UIFont systemFontOfSize:14];
    _phone.placeholder=@"请输入对方手机号";
        _phone.text=user.tongxun;
       NSLog(@"_+_+_+_+_+_+_+_+_+_+_+_+_+_+%@",_phone.text);
    [_phone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    _phone.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_phone];


    //手机号码
    UILabel *numLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
    numLab.text=@"手机号码";
    numLab.font=[UIFont systemFontOfSize:16];
    numLab.textColor=[UIColor blackColor];
    [view addSubview:numLab];
    
    //竖线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(80, 15, 1, 20)];
    line.backgroundColor=[UIColor blackColor];
    [view addSubview:line];
    
    //提醒
    UIImageView *remind=[[UIImageView alloc] initWithFrame:CGRectMake(60, 150, self.view.frame.size.width-120, 110)];
    remind.image=[UIImage imageNamed:@"dxshk_08.png"];
    [_scr addSubview:remind];
    
    //通讯录按钮
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(240*screenWidth/320, 0*screenWidth/320,60*screenWidth/320, 50*screenWidth/320);
    [btn1 setImage:[UIImage imageNamed:@"dxshk_07.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:btn1];
    
 
    //下一步
    //发起收款
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*screenWidth/320, 300*screenWidth/320,screenWidth-20*screenWidth/320,50*screenWidth/320);
    [button setBackgroundImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:buttonImageselected forState:UIControlStateHighlighted];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resClick) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:button];

}
-(void)address
{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        _phone.text = (__bridge NSString*)value;
        //去掉手机号的-
        _phone.text=[_phone.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }];
}
-(void)resClick
{
    
    User *user=[User currentUser];
    
    NSLog(@"输出经纬度为%@,%@",self.jing,self.wei);
    if(user.jing==NULL||user.jing==nil)
    {
        user.jing=@"";
    }
    if(user.wei==NULL||user.wei==nil)
    {
        user.wei=@"";
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    //截取字符串后六位
    NSString *a1=_datestr;
    NSString *b1=[a1 substringFromIndex:8];
    
    
    NSString *str1 = [_reason stringByAddingPercentEscapesUsingEncoding:enc];
    //自动添加小数点后两位
    NSString *text=[NSString stringWithFormat:@"%.2f",[_sum doubleValue]];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text,str1 ,_txuan,[[UIDevice currentDevice] model],_kaxuan,self.jing,self.wei,self.payway]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"duanxinshoukuan%@",dic);
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    if (![[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        [self toastResult:sre];
    }
    
    if ([[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        nextDuanXinViewController *next=[[nextDuanXinViewController alloc] init];
        
        next.shouNUm=_phone.text;
        //    next.shou=_numoney.text;
        next.yuanYin=_reason;
        // next.shouNUm=[dic objectForKey:@"loginId"];
        next.shou=[dic objectForKey:@"transAmt"];
        //  next.yuanYin=[dic objectForKey:@"ordRemark"];
        
        next.ding=[dic objectForKey:@"transSeqId"];
        next.ping=[dic objectForKey:@"credNo"];
        
        // next.phone=_phone.text;
        
        [self.navigationController pushViewController:next animated:YES];
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
    [_phone resignFirstResponder];
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
