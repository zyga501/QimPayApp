//
//  ShouKViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/6.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ShouKViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "NSString+Extension.h"
#import "User.h"
#import "PostAsynClass.h"
#import "SKEweimaViewController.h"
@interface ShouKViewController ()<UITextFieldDelegate>
{
    UITextField *numFiled;
    UITextField *textFiled;
}
@end

@implementation ShouKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    textFiled.text=@"货款";
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"收款" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
}
-(void)makeUI
{
    //User *user=[User currentUser];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSArray *titileArray=@[@"收款金额",@"收款说明"];
    for(int i=0;i<titileArray.count;i++)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, (85+i*43)*screenWidth/320, 80*screenWidth/320.0, 35*screenWidth/320.0)];
        label.text=titileArray[i];
        label.textAlignment=NSTextAlignmentRight;
        label.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, (124.4+i*43)*screenWidth/320, self.view.frame.size.width-20*screenWidth/320.0, 0.5*screenWidth/320.0)];
        view.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view];
        
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(118*screenWidth/320.0, (85.5+i*43)*screenWidth/320, 0.5*screenWidth/320.0, 30*screenWidth/320.0)];
        view1.backgroundColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        [self.view addSubview:view1];
    }
    numFiled=[[UITextField alloc] initWithFrame:CGRectMake(130*screenWidth/320.0, 83*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    numFiled.textAlignment=NSTextAlignmentLeft;
    numFiled.font=[UIFont systemFontOfSize:14];
    numFiled.delegate=self;
    numFiled.placeholder=@"请输入收款金额";
    numFiled.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:numFiled];
    
    textFiled=[[UITextField alloc] initWithFrame:CGRectMake(130*screenWidth/320.0, 126*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    textFiled.textAlignment=NSTextAlignmentLeft;
    textFiled.font=[UIFont systemFontOfSize:14];
    textFiled.delegate=self;
    textFiled.placeholder=@"请输入收款说明";
    textFiled.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:textFiled];
    
    UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(20*screenWidth/320.0, 200*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 30*screenWidth/320.0);
    [okButton setTitle:@"确认收款" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    okButton.layer.borderWidth=0.5;
    okButton.layer.cornerRadius=4;
    okButton.clipsToBounds=YES;
    okButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    okButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:okButton];

    
}
-(void)nextBtn
{
    if(numFiled.text==nil)
    {
        [self toastResult:@"请输入交易金额"];
    }
    if(textFiled.text==nil||textFiled.text.length>=20)
    {
        [self toastResult:@"请确认收款说明在0~20个字符内"];
    }
     NSString *str1 = [textFiled.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *string=[NSString stringWithFormat:@"%.2f",[numFiled.text doubleValue]];
        SKEweimaViewController *skevc=[[SKEweimaViewController alloc] init];
        skevc.numString=string;
        skevc.textString=str1;
        [self.navigationController pushViewController:skevc animated:YES];

    [numFiled resignFirstResponder];
    [textFiled resignFirstResponder];
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
-(void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numFiled resignFirstResponder];
    [textFiled resignFirstResponder];
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
