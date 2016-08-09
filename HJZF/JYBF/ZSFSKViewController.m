//
//  ZSFSKViewController.m
//  JYBF
//
//  Created by 王健超 on 16/4/28.
//  Copyright © 2016年 wjc. All rights reserved.
//

#import "ZSFSKViewController.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
#import "TwoShouKuanViewController.h"
#import "nextErweiViewController.h"
#import "MBProgressHUD+CZ.h"
#import "zhiFuViewController.h"
@interface ZSFSKViewController ()
{
    //数字显示器
    UITextField *label;
    UIButton *_buu;
    UIButton *_buu1;
    NSString *_s;
    UIScrollView *_scr;
    NSString *_datestr;
    NSMutableArray *arr5;
}
@end

@implementation ZSFSKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)viewDidDisappear:(BOOL)animated
{
    label.text=nil;
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"攒善付收款" andClass:self andSEL:@selector(bacClick:)];
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
    
    //获取当前时间
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSArray *zonearr=[NSTimeZone knownTimeZoneNames];
    NSLog(@"%@",zonearr);
    _datestr=[formatter stringFromDate:date];
    
    
    //scrolView布局
    _scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0)];
    _scr.bounces = NO;//设置是否反弹
    _scr.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    //[self.view addSubview:_scr];
    
    
    //    User *user=[User currentUser];
    //输入框背景
    UIView *white=[[UIView alloc] initWithFrame:CGRectMake(0*screenWidth/320, 0*screenWidth/320, self.view.frame.size.width,self.view.frame.size.height-(64+360.5)*screenWidth/320)];
    white.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [_scr addSubview:white];
    
    //输入框   239,175,20
    label=[[UITextField alloc] initWithFrame:CGRectMake(15*screenWidth/320,white.frame.size.height-40*screenWidth/320, self.view.frame.size.width-45, 40*screenWidth/320)];
    label.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    //label.text=user.numJin;
    label.delegate=self;
    label.textAlignment=NSTextAlignmentRight;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:40];
    [white addSubview:label];
    
    
    //数字按钮
    //添加1-9数字
    NSArray *array=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9" ,nil];
    int n=0;
    for (int i=0; i<3; i++)
    {
        for (int j=0; j<3; j++)
        {
            
            _buu=[UIButton buttonWithType:UIButtonTypeSystem];
            _buu=[UIButton buttonWithType:UIButtonTypeSystem];
            _buu.frame=CGRectMake((80*j)*screenWidth/320, white.frame.size.height+90*i*screenWidth/320, 80*screenWidth/320, 90*screenWidth/320);
            [_buu setTitle:[array objectAtIndex:n++] forState:UIControlStateNormal];   //注意：[array objectAtIndex:n++]
            [_buu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _buu.titleLabel.font= [UIFont systemFontOfSize:30];
            [_buu addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside]; //addTarget:self 的意思是说，这个方法在本类中也可以传入其他类的指针
            if(i==0){_buu.tag=j+1; }
            else if(i==1){_buu.tag
                =i*4+j;}else if(i==2){_buu.tag=i*3+j+1;}
            [_scr addSubview:_buu];
        }
    }
    NSLog(@"anniugaoduwei %f,%f",_buu.frame.
          origin.y,self.view.frame.size.height);
    NSArray *arr=@[@".",@"0",@"00"];
    for (int i=0; i<arr.count;i++)
    {
        
        UIButton *buu1=[UIButton buttonWithType:UIButtonTypeSystem];
        buu1.frame=CGRectMake(80*screenWidth/320*i, white.frame.size.height+270*screenWidth/320, 80*screenWidth/320, 90*screenWidth/320);
        [buu1 setTitle:arr[i]  forState:UIControlStateNormal];   //注意：[array objectAtIndex:n++]
        [buu1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buu1.titleLabel.font= [UIFont systemFontOfSize:30];
        [buu1 addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside];
        buu1.tag=100+i;
        [_scr addSubview:buu1];
        
        if (i==0) {
            _buu1=buu1;
        }
    }
    
    
    
    //竖线横线
    for(int i=0;i<3;i++)
    {
        UIView *greyView=[[UIView alloc] initWithFrame:CGRectMake((80+i*80)*screenWidth/320, white.frame.size.height+0.5*screenWidth/320.0, 1,_scr.frame.size.height-white.frame.size.height)];
        greyView.backgroundColor=[UIColor lightGrayColor];
        [_scr addSubview:greyView];
        
        UIView *honorView=[[UIView alloc] initWithFrame:CGRectMake(0,white.frame.size.height+(1+i)*90*screenWidth/320, self.view.frame.size.width, 1)];
        honorView.backgroundColor=[UIColor lightGrayColor];
        [_scr addSubview:honorView];
        
    }
    
    //微信支付
    UIButton *wxbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wxbtn.frame=CGRectMake(240*screenWidth/320, white.frame.size.height+0.4*screenWidth/320, 80*screenWidth/320, 89.4*screenWidth/320);
    [wxbtn setImage:[UIImage imageNamed:@"weixinzhifu.png"] forState:UIControlStateNormal];
    [wxbtn addTarget:self action:@selector(wxbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_scr addSubview:wxbtn];
    
    //支付宝支付
    UIButton *addbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame=CGRectMake(240*screenWidth/320, white.frame.size.height+90*screenWidth/320, 80*screenWidth/320, 89.7*screenWidth/320);
    [addbtn setTitle:@"AC" forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addbtn.titleLabel.font= [UIFont systemFontOfSize:30];
    [addbtn addTarget:self action:@selector(zhifubaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:addbtn];
    
    
    
    //最底下的横线
    UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, 550*screenWidth/320, self.view.frame.size.width, 0.8)];
    downView.backgroundColor=[UIColor whiteColor];
    downView.alpha=0.5;
    // [_scr addSubview:downView];
    
    //收款按钮
    UIEdgeInsets insets1 = UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *image1 = [UIImage imageNamed:@"bj_shoukuanan.png"];
    image1 = [image1 resizableImageWithCapInsets:insets1 resizingMode:UIImageResizingModeStretch];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(240*screenWidth/320, white.frame.size.height+180.3*screenWidth/320,80*screenWidth/320, 180*screenWidth/320);
    //注意：[array objectAtIndex:n++]
    [btn setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:btn];
    
    
    //    //删除按钮
    UIEdgeInsets insets2 = UIEdgeInsetsMake(0,0,0,0);
    UIImage *image2 = [UIImage imageNamed:@"bj_shanchu.png"];
    image2 = [image2 resizableImageWithCapInsets:insets2 resizingMode:UIImageResizingModeStretch];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(240*screenWidth/320, white.frame.size.height+0.4*screenWidth/320, 80*screenWidth/320, 89.4*screenWidth/320);
    [btn1 setImage:image2 forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:btn1];
    
    _scr.contentSize = CGSizeMake(self.view.frame.size.width, 360*screenWidth/320+white.frame.size.height);
    [self.view addSubview:_scr];
}
//支付宝
-(void)zhifubaoBtn:(UIButton*)btn
{
    _buu1.enabled=YES;
    label.text=@"";
}
//微信
-(void)wxbtnClick:(UIButton*)btn
{
    if(label.text==nil||[label.text isEqualToString:@""])
    {
        [self toastResult:@"收款金额不能为空"];
        return;
    }
    if ([label.text doubleValue]==0) {
        [self toastResult:@"收款金额不能为0"];
        return;
    }
    
    User *user=[User currentUser];
    if(user.jing==NULL||user.jing==nil)
    {
        user.jing=@"";
    }
    if(user.wei==NULL||user.wei==nil)
    {
        user.wei=@"";
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        //截取字符串后六位
        NSString *a1=_datestr;
        NSString *b1=[a1 substringFromIndex:8];
        NSString *str1 = [@"微信支付" stringByAddingPercentEscapesUsingEncoding:enc];
        //自动添加小数点后两位
        NSString *text=[NSString stringWithFormat:@"%.2f",[label.text doubleValue]];
        NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text,str1 ,@"T1",[[UIDevice currentDevice] model],@"X",user.jing,user.wei,@"weixin"]];
        NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
        NSData *ata = [NSData alloc];
        ata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
        user.xia=[di objectForKey:@"transSeqId"];
        NSLog(@"erweimashoukuan%@",di);
        NSString *sre = [di objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre);
        NSLog(@"putongshoukuan%@",di);
        if(![[di objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [self toastResult:sre];
        }
        if([[di objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"myData" object:nil];
            NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            //截取字符串后六位
            NSString *b=_datestr;
            NSString *c=[b substringFromIndex:8];
            NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url15 andKeyArr:@[@"merId",@"transSeqId",@"credNo"]andValueArr:@[user.merid,user.xia,c]];
            //P15101314132319094
            NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
            NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc1];
            NSData *ata3 = [NSData alloc];
            ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
            user.url=[dic3 objectForKey:@"qrCodeUrl"];
            NSLog(@"erweimashoukuan2%@",dic3);
            NSString *sre3 = [dic3 objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre3);//
            if(![[dic3 objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                [self toastResult:sre3];
                return;
            }
            else
            {
                nextErweiViewController *next1=[[nextErweiViewController alloc] init];
                next1.string=@"微信支付";
                next1.type=@"T1";
                [self.navigationController pushViewController:next1 animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
    });
    
}
-(BOOL)xiaoshu
{
    BOOL bl;
    if ([label.text rangeOfString:@"."].location !=NSNotFound) {
        bl=YES;
    }
    else
    {
        bl=NO;
    }
    return bl;
    
}
-(void)shuzi:(UIButton *)btn
{
    if (label.text.length>9) {
        [self toastResult:@"金额不可大于10位"];
        return;
    }
    if([label.text containsString:@"."])
    {
        NSRange range=[label.text rangeOfString:@"."];
        if(([label.text length]-(range.location+1))==2)
        {
            [self toastResult:@"您输入的数字保留2为小数"];
            return;
        }
    }
    if (label.text==nil ) {
        if (btn.tag<100)
        {
            label.text=[NSString stringWithFormat:@"%ld",(long)btn.tag];
        }
        else if(btn.tag==101)
        {
            label.text=@"0";
        }
        
    }
    else
    {
        
        if (btn.tag<100)
        {
            
            label.text=[label.text stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        }
    }if (btn.tag==101) {
        
        label.text=[label.text stringByAppendingString:@"0"];
        
    }
    if (btn.tag==100
        ) {
        label.text=[label.text stringByAppendingString:@"."];
        //            btn.enabled=NO;
        BOOL bl=[self xiaoshu];
        if(bl){
            NSLog(@"yes");
            _buu1.enabled=NO;
        }else{
            NSLog(@"no");
            _buu1.enabled=YES;
        }
        
    }
    else if(btn.tag==102) {
        label.text=[label.text stringByAppendingString:@"00"];
    }
    
}

-(void)ok:(UIButton*)btn
{
    //arr5=[[NSMutableArray alloc] init];    //初始化数组
    
    User *user=[User currentUser];
    if(user.jing==NULL||user.jing==nil)
    {
        user.jing=@"";
    }
    if(user.wei==NULL||user.wei==nil)
    {
        user.wei=@"";
    }
    
    if (label.text.length<=0) {
        [self toastResult:@"收款金额不能为空"];
        return;
    }
    if ([label.text doubleValue]==0) {
        [self toastResult:@"收款金额不能为0"];
        return;
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    //截取字符串后六位
    NSString *a=_datestr;
    NSString *b=[a substringFromIndex:8];
    NSString *str1 = [@"攒善付收款" stringByAddingPercentEscapesUsingEncoding:enc];
    //自动添加小数点后两位
    NSString *text1=[NSString stringWithFormat:@"%.2f",[label.text doubleValue]];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b,text1,str1 ,@"T1",[[UIDevice currentDevice] model],@"X",user.jing,user.wei,@"sltongpay"]];
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.dingDan=[dic objectForKey:@"transSeqId"];
    user.pingZheng=[dic objectForKey:@"credNo"];
    user.shouxu=[dic objectForKey:@"transFee"];
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"putongshoukuan%@",dic);
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url16 andKeyArr:@[@"merId",@"transSeqId",@"credNo",@"paySrc"]andValueArr:@[user.merid,user.dingDan,user.pingZheng,@"nor"]];
        //
        NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
        NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
        NSData *ata1 = [NSData alloc];
        ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"xiaofeiyemian%@",dic1);
        
        
        zhiFuViewController *zhifu=[[zhiFuViewController alloc] init];
        [self.navigationController pushViewController:zhifu animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }
}
-(void)clean:(UIButton*)btn
{
    //_s=label.text;
    if (label.text.length<1) {
        return;
    }
    label.text=[label.text substringToIndex:label.text.length-1];
    _buu1.enabled=YES;
}
//限制输入个数

//用户未输入任何信息提示
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
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
