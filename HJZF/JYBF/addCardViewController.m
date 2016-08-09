//
//  addCardViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/13.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "addCardViewController.h"

#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
@interface addCardViewController ()<UITextViewDelegate>
{
    UIButton *_choice;
    UIView *backView;
    
    UIActionSheet *_al;
    NSString *_cardStr;
    UIButton *_alBtn;
    NSString *_imagStr;
    UILabel *namelel;
    UITextField *_field;
    UITextView *_fenhang;
    
}
@end

@implementation addCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    
    [self makeUI];
    
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"添加银行卡" andClass:self andSEL:@selector(bacClick:)];
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
    NSArray *arr=@[@"结算银行",@"结算户主",@"结算卡号"];
    for(int i=0;i<arr.count;i++)
    {

        backView=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, (90+i*60)*screenWidth/320.0, 300*screenWidth/320.0, 50*screenWidth/320.0)];
        backView.backgroundColor=[UIColor colorWithRed:232/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [self.view addSubview:backView];
        
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 10*screenWidth/320, 100*screenWidth/320, 30*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:16];
        lab.textColor=[UIColor lightGrayColor];
        [backView addSubview:lab];
        
        //竖线
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(80*screenWidth/320, 15*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
    
        view1.backgroundColor=[UIColor lightGrayColor];
        [backView addSubview:view1];

    }
    //增加
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(10*screenWidth/320, 380*screenWidth/320, 300*screenWidth/320, 50*screenWidth/320);
    btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *laa=[[UILabel alloc] initWithFrame:CGRectMake((300-100)/2*screenWidth/320, 15*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    laa.text=@"确认增加";
    laa.textAlignment=NSTextAlignmentCenter;
    laa.textColor=[UIColor whiteColor];
    [btn addSubview:laa];
    
    
    _choice=[UIButton buttonWithType:UIButtonTypeSystem];
    _choice.frame=CGRectMake(60*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 30*screenWidth/320);
    [_choice setTitle:@"选择结算银行" forState:UIControlStateNormal];
    
    [_choice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_choice addTarget:self action:@selector(choseAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_choice];
    
    
    User *user=[User currentUser];
    
 
    //结算户主
    namelel=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 165*screenWidth/320, 300*screenWidth/320, 20*screenWidth/320)];
    namelel.text=user.name;
       namelel.font=[UIFont systemFontOfSize:15];
    namelel.textColor=[UIColor blackColor];
    [self.view addSubview:namelel];
    
    //结算卡号
    _field=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320,220*screenWidth/320, 250*screenWidth/320, 30*screenWidth/320)];
    _field.delegate=self;
    _field.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_field];
    
//    //结算分行
//    _fenhang=[[UITextView alloc] initWithFrame:CGRectMake(100*screenWidth/320,280*screenWidth/320, 200*screenWidth/320, 30*screenWidth/320)];
//    _fenhang.delegate=self;
//    _fenhang.backgroundColor=[UIColor clearColor];
//    _fenhang.font=[UIFont systemFontOfSize:14];
//    [self.view addSubview:_fenhang];
   
}

-(void)add:(UIButton*)btn

{
    
    if(_cardStr==nil ){
        [self toastResult:@"请选择结算银行"];
        return;
    }
    
    if (namelel.text == nil||[@"" isEqual:namelel.text]) {
        [self toastResult:@"请输入结算户主姓名"];
        return;
    }
    if (_field.text == nil||[@"" isEqual:_field.text]) {
        [self toastResult:@"请输入银行卡号"];
        return;
    }
    if([_field.text length]< 10){
        [self toastResult:@"卡号长度必须大于10位"];
        return;
    }
//    if(!(_fenhang.text!=NULL&&(_fenhang.text.length>=5&&_fenhang.text.length<=25)))
//    {
//        [self toastResult:@"请重新输入支行名称"];
//        return;
//    }
    
    
    UIAlertView *alerview= [[UIAlertView alloc]initWithTitle:@"确认增加" message:@"确认是否增加银行卡！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    [alerview show];
    alerview.tag=2;
    
    
}
-(void)choseAlert:(UIButton*)btn
{
    // @"中国农业银行",@"中国建设银行",@"中国交通银行",@"招商银行",@"中信银行",@"光大银行",@"北京银行"
    
    _al = [[UIActionSheet alloc]initWithTitle:@"请选择银行" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国交通银行",@"招商银行",@"中信银行",@"光大银行",@"北京银行", nil];
    
    //在某个view中展示
    [_al showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    //通过buttonIndex来确定点击的是actionSheet上的哪个按钮
    
    switch (buttonIndex) {
        case 0:
            _imagStr=@"ios320x568_08.png";
            _cardStr =@"icbc";
            [_choice setTitle:@"中国工商银行" forState:UIControlStateNormal];
            break;
        case 1:
            _imagStr=@"ios320x568_03.png";
            _cardStr=@"abc";
            [_choice setTitle:@"中国农业银行" forState:UIControlStateNormal];
            
            break;
        case 2:
            _imagStr=@"ios320x568_06.png";
            _cardStr =@"ccb";
            [_choice setTitle:@"中国建设银行" forState:UIControlStateNormal];
            break;
        case 3:
            _imagStr=@"ios320x568_10.png";
            _cardStr =@"bankcomm";
            [_choice setTitle:@"交通银行" forState:UIControlStateNormal];
            break;
        case 4:
            _imagStr=@"ios320x568_12.png";
            _cardStr=@"cmb";
            [_choice setTitle:@"招商银行" forState:UIControlStateNormal];
            break;
        case 5:
            _imagStr=@"ios320x568_14.png";
            _cardStr=@"ecitic";
            [_choice setTitle:@"中信银行" forState:UIControlStateNormal];
            break;
        case 6:
            _imagStr=@"ios320x568_18.png";
            _cardStr=@"cebbank";
            [_choice setTitle:@"中国光大银行" forState:UIControlStateNormal];
            
            break;
        case 7:
            _imagStr=@"ios320x568_16.png";
            _cardStr=@"bankofbj";
            [_choice setTitle:@"北京银行" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark -触摸隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_field  resignFirstResponder];
//    [_fenhang resignFirstResponder];
    [namelel resignFirstResponder];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [namelel resignFirstResponder];
    //[_fenhang resignFirstResponder];
    return YES;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
        
        
    } else {
        if(alertView.tag==2)
        {
            User *user=[User currentUser];
            //结算卡银行
            NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            //
            NSString *strr = [namelel.text stringByAddingPercentEscapesUsingEncoding:enc1];
            //NSString *nameString=[_fenhang.text stringByAddingPercentEscapesUsingEncoding:enc1];
//            NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url06 andKeyArr:@[@"merId",@"openAcctName",@"openAcctId",@"openBankId",@"openBranchName"]andValueArr:@[user.merid,strr,_field.text,_cardStr,nameString]];
             NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url06 andKeyArr:@[@"merId",@"openAcctName",@"openAcctId",@"openBankId"]andValueArr:@[user.merid,strr,_field.text,_cardStr]];
            NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
            
            
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
            
            NSData *ata1 = [NSData alloc];
            
            ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"tianjiaYInhangka%@",dict);
            NSString *sre = [dict objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            if (![[dict objectForKey:@"respCode"]isEqualToString:@"000"]) {
                [self toastResult:sre];
            }
            if([[dict  objectForKey:@"respCode"] isEqualToString:@"000"])
                
            {
                [self toastResult:sre];
              [self.navigationController popViewControllerAnimated:YES];
            }

        }
        
        
        
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
