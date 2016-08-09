//
//  feilvxinxiViewController.m
//  WLF
//
//  Created by 王健超 on 15/10/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "feilvxinxiViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "MyTabbar.h"
#import "User.h"
#import "PostAsynClass.h"
@interface feilvxinxiViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollview;
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
     NSMutableArray *arr5;
    NSMutableArray *arrT1;
    NSMutableArray *arrD0;
    
    UILabel *label;
    UILabel *Tlabel;
    UILabel *feetLabel;
}
@end

@implementation feilvxinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    arr4= [[NSMutableArray alloc] init];
    arr5= [[NSMutableArray alloc] init];
    arr3= [[NSMutableArray alloc] init];
    arr2= [[NSMutableArray alloc] init];
    arr1= [[NSMutableArray alloc] init];
    arrT1= [[NSMutableArray alloc] init];
    arrD0= [[NSMutableArray alloc] init];
    
    [self makeNav];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"费率信息" andClass:self andSEL:@selector(bacClick:)];
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
    
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64*screenWidth/320, screenWidth, screenHeight)];
    scrollview.backgroundColor=[UIColor whiteColor];
        scrollview.delegate=self;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.bounces=NO;
    
    User *user=[User currentUser];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url37 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array = [dic objectForKey:@"merFeeInfo"];
   
    
    for(NSDictionary *dict in array)
    {
        NSLog(@"输出通道名字为%@",[dict objectForKey:@"gateName"]);
        
        //[arr3 addObject:[dict objectForKey:@"gateId"]];
       // [arr4 addObject:[dict objectForKey:@"gateName"]];
       
        if([[dict objectForKey:@"t0Stat"]isEqualToString:@"Y"])
        {
             [arrD0 addObject:[dict objectForKey:@"t0Stat"]];
            [arr4 addObject:@"D0"];
            [arr2 addObject:[dict objectForKey:@"feeRateT0"]];
            [arr5 addObject:[dict objectForKey:@"gateName"]];
        }
        if([[dict objectForKey:@"t1Stat"]isEqualToString:@"Y"])
        {
            [arrT1 addObject:[dict objectForKey:@"t1Stat"]];
             [arr4 addObject:@"T1"];
            [arr2 addObject:[dict objectForKey:@"feeRateT1"]];
            [arr5 addObject:[dict objectForKey:@"gateName"]];
        }
        

    }
     NSLog(@"feilv--------------------------------%@---%@",arr5,array);
    NSLog(@"输出费率信息为%@",arr4);
    int n=0;
    for(int i=0;i<arr5.count;i++)
    {
        label=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 5*screenWidth/320.0+i*50*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
        label.text=[NSString stringWithFormat:@"%@",arr5[i]];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentLeft;
        [scrollview addSubview:label];
        
        Tlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-10*screenWidth/320.0, 5*screenWidth/320.0+i*50*screenWidth/320.0, 20*screenWidth/320.0, 40*screenWidth/320.0)];
         Tlabel.text=[NSString stringWithFormat:@"%@",arr4[i]];
        Tlabel.font=[UIFont systemFontOfSize:14];
        Tlabel.textAlignment=NSTextAlignmentCenter;
        [scrollview addSubview:Tlabel];

        
        feetLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70*screenWidth/320.0, 5*screenWidth/320.0+i*50*screenWidth/320.0, 50*screenWidth/320.0, 40*screenWidth/320.0)];
        feetLabel.font=[UIFont systemFontOfSize:14];
        feetLabel.text=[NSString stringWithFormat:@"%@",arr2[i]];
        feetLabel.textColor=[UIColor lightGrayColor];
        feetLabel.textAlignment=NSTextAlignmentRight;
        [scrollview addSubview:feetLabel];
        
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(feetLabel.frame.size.width+feetLabel.frame.origin.x, 5*screenWidth/320.0+i*50*screenWidth/320.0, 20*screenWidth/320.0, 40*screenWidth/320.0)];
        lab.text=@"%";
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor lightGrayColor];
        lab.textAlignment=NSTextAlignmentLeft;
        [scrollview addSubview:lab];
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y+4*screenWidth/320.0, self.view.frame.size.width, 0.5)];
        view.backgroundColor=[UIColor lightGrayColor];
        [scrollview addSubview:view];
        
    }
    
    scrollview.contentSize=CGSizeMake(0, arr5.count*50*screenWidth/320);
    [self.view addSubview:scrollview];


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
