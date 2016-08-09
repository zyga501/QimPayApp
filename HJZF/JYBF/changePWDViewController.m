//
//  changePWDViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/27.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "changePWDViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "MyMD5.h"
#import "PostAsynClass.h"
#import "User.h"

#import "changeJIaoyiViewController.h"
#import "changeLoginViewController.h"
#import "forjectJiaoyiViewController.h"
@interface changePWDViewController ()
{
    UIButton *_btn;
}
@end

@implementation changePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.9];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"密码修改" andClass:self andSEL:@selector(bacClick:)];
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
    
    NSArray *arr=@[@"更改登录密码",@"更改交易密码",@"忘记交易密码"];
    for(int i=0;i<3;i++)
    {
        _btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btn.frame=CGRectMake(0, (64+i*41)*screenWidth/320, self.view.frame.size.width, 40*screenWidth/320);
        _btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        _btn.backgroundColor=[UIColor whiteColor];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitle:arr[i] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag=1100+i;
        [self.view addSubview:_btn];
    }

    
}
-(void)btn:(UIButton*)btn
{
    switch (btn.tag) {
        case 1100:
        {
            changeLoginViewController *clvc=[[changeLoginViewController alloc] init];
            [self.navigationController pushViewController:clvc animated:YES];
            break;
        }
         case 1101:
        {
            changeJIaoyiViewController *cjvc=[[changeJIaoyiViewController alloc] init];
            [self.navigationController pushViewController:cjvc animated:YES];
            break;
        }
            case 1102:
        {
            forjectJiaoyiViewController *fvc=[[forjectJiaoyiViewController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
            break;
        }
            
        default:
            break;
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
