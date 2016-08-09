//
//  ZhuanZhangViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/6.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ZhuanZhangViewController.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "Header.h"
#import "NSString+Extension.h"
#import "MyMD5.h"
#import "nextZZViewController.h"
#import "ZhuanZhangJLViewController.h"

@interface ZhuanZhangViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    UITextField *phoneNum;
}
@end

@implementation ZhuanZhangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    phoneNum.text=user.tongxun;
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"转账" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"转账记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
}
-(void)makeUI
{
    User *user=[User currentUser];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 130*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 40*screenWidth/320.0)];
    view.layer.cornerRadius=3;
    view.clipsToBounds=YES;
    view.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth=0.5;
    view.userInteractionEnabled=YES;
    [self.view addSubview:view];
    
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 0*screenWidth/320.0, 85*screenWidth/320.0, 40*screenWidth/320.0)];
    nameLabel.text=@"收款人手机号";
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont systemFontOfSize:13];
    [view addSubview:nameLabel];
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, 0*screenWidth/320.0, 130*screenWidth/320.0, 40*screenWidth/320.0)];
    phoneNum.textAlignment=NSTextAlignmentLeft;
    phoneNum.font=[UIFont systemFontOfSize:13];
    phoneNum.delegate=self;
    phoneNum.text=user.tongxun;
    phoneNum.placeholder=@"请输入收款人手机号";
    [view addSubview:phoneNum];
    
    UIButton *imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame=CGRectMake(self.view.frame.size.width-80*screenWidth/320.0, 0, 40*screenWidth/320.0, 40*screenWidth/320.0);
    [imageButton setImage:[UIImage imageNamed:@"dxshk_07@2x"] forState:UIControlStateNormal];
    imageButton.imageEdgeInsets=UIEdgeInsetsMake(5*screenWidth/320.0, 5*screenWidth/320.0, 5*screenWidth/320.0, 5*screenWidth/320.0);
    [imageButton addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:imageButton];
    
    
    UILabel *TXlabel=[[UILabel alloc] initWithFrame:CGRectMake(60*screenWidth/320.0, 180*screenWidth/320.0, self.view.frame.size.width-120*screenWidth/320.0, 120*screenWidth/320.0)];
    TXlabel.text=@"提醒:\n您正在短信转账,\n为确保您的正常转账,\n请准确填写对方手机号码!";
    TXlabel.textAlignment=NSTextAlignmentLeft;
    TXlabel.font=[UIFont systemFontOfSize:13];
    TXlabel.numberOfLines=0;
    TXlabel.textColor=[UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.0];
    //[self.view addSubview:TXlabel];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(20*screenWidth/320.0, 220*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 35*screenWidth/320.0);
    nextButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    nextButton.layer.borderWidth=0.5;
    nextButton.layer.cornerRadius=4;
    nextButton.clipsToBounds=YES;
    nextButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

#pragma mark  查看转账记录
-(void)navButtonClick
{
    ZhuanZhangJLViewController *zzjl=[[ZhuanZhangJLViewController alloc] init];
    [self.navigationController pushViewController:zzjl animated:YES];
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
        phoneNum.text = (__bridge NSString*)value;
        //去掉手机号的-
        phoneNum.text=[phoneNum.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }];
}
-(void)nextBtn
{
    BOOL phoneBool=[phoneNum.text isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }
//    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
//    //网络请求
//    [paStr appendFormat:@"%@%@%@",can,phoneNum.text,@"1234567890"];
//    
//    NSLog(@"%@",paStr);
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url32 andKeyArr:@[@"agentId",@"mobile"]andValueArr:@[can,phoneNum.text]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"yonghushifoucunzai%@,%@",dic,self.navigationController);
    NSString *sre1 = [dic objectForKey:@"respDesc"];
     if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
     {
         [self toastResult:sre1];
     }
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
    {
        nextZZViewController *nzvc=[[nextZZViewController alloc] init];
        nzvc.phoneString=phoneNum.text;
        nzvc.nameString=[dic objectForKey:@"merName"];
        nzvc.merIdString=[dic objectForKey:@"merId"];
        [self.navigationController pushViewController:nzvc animated:YES];
    }
    //NSLog(@"确认提交");
    [phoneNum resignFirstResponder];
}
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneNum resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [phoneNum resignFirstResponder];
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
