//
//  shangchengViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/26.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "shangchengViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
@interface shangchengViewController ()

@end

@implementation shangchengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.9];
   
    [self makeNav];
     [self makeUI];
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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"商城" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];

}
#pragma mark  返回键
-(void)bacClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320.0)];
    image.image=[UIImage imageNamed:@"shang.png"];
    [self.view addSubview:image];
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
