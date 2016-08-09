//
//  nextDuanXinViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/7.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextDuanXinViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "User.h"


@interface nextDuanXinViewController ()
{
    UITextView *_textView;
   
    UILabel *_lab;
    
    UILabel *_lab1;
    
    NSString *_urlStr;
    
      UILabel *_shouLab;
}
@end

@implementation nextDuanXinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    
    
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    
    
    ///状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    
    
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"短信收款" andClass:self andSEL:@selector(baClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)baClick:(UIButton*)btn
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)makeUI
{
    
    for(int i=0;i<3;i++)
    {
        UIImageView *ima=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (84+i*40)*screenWidth/320, self.view.frame.size.width-20, 35*screenWidth/320)];
        ima.image=[UIImage imageNamed:@"caifu_13.png"];
        [self.view addSubview:ima];
        
        
        
    }
    
    NSArray *arr=@[@"手机号码",@"收款金额",@"收款原因"];
    for(int i=0;i<3;i++)
    {
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320,(94+i*40)*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:lab];
        
        
        
    }
    
    //竖线
    for(int i=0;i<3;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(85*screenWidth/320, (94+i*40)*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    
    UILabel *lab1=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 220*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    lab1.text=@"短信内容";
    lab1.textColor=[UIColor grayColor];
    lab1.font=[UIFont systemFontOfSize: 15];
    [self.view addSubview:lab1];
    

    //手机号码传值
    UILabel *phoneLab=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 94*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    phoneLab.text=self.shouNUm;
    phoneLab.textColor=[UIColor blackColor];
    phoneLab.font=[UIFont systemFontOfSize: 15];
    [self.view addSubview:phoneLab];
    
    
    
    //收款金额传值
    _shouLab=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    _shouLab.text=self.shou;
    _shouLab.textColor=[UIColor blackColor];
    _shouLab.font=[UIFont systemFontOfSize: 15];
    [self.view addSubview:_shouLab];
    
    //收款原因
    UILabel *yLab=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 174*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    yLab.text=self.yuanYin;
    yLab.textColor=[UIColor blackColor];
    yLab.font=[UIFont systemFontOfSize: 15];
    [self.view addSubview:yLab];
    
    
    
    
    
    //textView
    //User * user = [User currentUser];
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(20*screenWidth/320, 250*screenWidth/320, self.view.frame.size.width-40, 130*screenWidth/320)];
    _textView.textColor=[UIColor blackColor];
    _textView.font= [UIFont fontWithName:@"Arial"size:18.0];
    _textView.delegate=self;
    
  //   _textView.textAlignment = UITextAlignmentLeft;
    _textView.returnKeyType=UIReturnKeyDone;
    _textView.backgroundColor=[UIColor whiteColor];
    _textView.scrollEnabled=YES;
   // _textView.text=user.ming;
    _textView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _textView.textColor=[UIColor blackColor];
    _textView.font=[UIFont systemFontOfSize:15];
    //设置键盘不弹出
    _textView.editable=NO;
        [self.view addSubview:_textView];
    
    
  
    User *user=[User currentUser];
    
    //网址
    _urlStr=[NSString stringWithFormat:@"http://121.41.118.80/mobile/ss/doPay.do?merId=%@&transSeqId=%@&credNo=%@&paySrc=%@",user.merid,self.ding,self.ping,@"sms"];
//    UILabel *wang=[[UILabel alloc] initWithFrame:CGRectMake(5*screenWidth/320, 25*screenWidth/320, 200*screenWidth/320, 90*screenWidth/320)];
//    wang.text=_urlStr;
//    wang.font=[UIFont systemFontOfSize:14];
//    wang.numberOfLines = 0;
//    wang.adjustsFontSizeToFitWidth = YES;
  //  [_textView addSubview:wang];
    
    
    
    
    //固定短信内容
    UILabel *duan=[[UILabel alloc] initWithFrame:CGRectMake(5*screenWidth/320, 5*screenWidth/320,self.view.frame.size.width-50, 130*screenWidth/320)];
    duan.text=[NSString stringWithFormat:@"你好! %@正在向你收款，金额为：%@元，付款请点击%@",user.name,_shouLab.text,_urlStr];
    duan.numberOfLines=0;
    duan.textAlignment=UITextAlignmentLeft;
    duan.font=[UIFont systemFontOfSize:14];
    duan.textColor=[UIColor blackColor];
    [_textView addSubview:duan];
    
    
    
    //发起收款
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40*screenWidth/320, 400*screenWidth/320,screenWidth-80*screenWidth/320,40*screenWidth/320);
    [button setBackgroundImage:[UIImage imageNamed:@"bj_dengluanniu.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:buttonImageselected forState:UIControlStateHighlighted];
    [button setTitle:@"发送短信" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
   
    
}
//短信发送点击事件
-(void)resClick
{
    User *user=[User currentUser];
    //发送短信调系统方法
    NSString *str123=self.shouNUm;
    NSArray *arr=[NSArray arrayWithObjects:str123,nil];
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller=[[MFMessageComposeViewController alloc]init];
        controller.body=[NSString stringWithFormat:@"你好! %@正在向你收款，金额为：%@元，付款请点击%@",user.name,_shouLab.text,_urlStr];
        NSLog(@"agaggagagaggagaggagaggagagag------%@",controller.body);
        controller.messageComposeDelegate=self;
        controller.recipients=arr;
        //[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:^{
            
                  }];
    }
    
    NSLog(@"--------------------------%@",str123);

}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //Notifies users about errors associated with the interface
    
    switch (result) {
            
        case MessageComposeResultCancelled:
            
        {
                [self toastResult:@"取消短信发送"];
                NSLog(@"Result: canceled");
        }
            break;
            
        case MessageComposeResultSent:
        {
                           NSLog(@"Result: Sent");
            [self toastResult:@"短信发送成功"];
        }
            break;
            
        case MessageComposeResultFailed:
            
        {
                [self toastResult:@"短信发送失败"];
                NSLog(@"Result: Failed");
        }
            break;
            
        default:
            
            break;
            
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
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
