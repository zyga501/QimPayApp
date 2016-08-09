//
//  customViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "customViewController.h"
#import "Header.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShareViewController.h"
#import "WealthViewController.h"
#import "ShouKuanViewController.h"
#import "MyNavigationBar.h"

#import "MyViewController.h"
#import "MyTabbar.h"
//#import "jiSuanAnNiuViewController.h"
@interface customViewController ()
{
    UITabBarController *_tabbarController;
    MyTabbar *_myTabbar;
}
@end

@implementation customViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    
    ShouKuanViewController *skvc=[[ShouKuanViewController alloc] init];
    WealthViewController *wvc=[[WealthViewController alloc] init];
    ShareViewController *svc=[[ShareViewController alloc] init];
    MyViewController *mvc=[[MyViewController alloc] init];
    
    self.vcArr = @[wvc,skvc,svc,mvc];
    self.viewControllers=self.vcArr;
    //self.selectedIndex=1;
//    _tabbarController=[[UITabBarController alloc] init];
//    _tabbarController.viewControllers=[NSArray arrayWithObjects:serve,extens,my,more, nil];
//    self.viewControllers=_tabbarController;
    
    _myTabbar=[[MyTabbar alloc] init];
    _myTabbar.frame=CGRectMake(0, self.view.frame.size.height-49*screenWidth/320
                               , screenWidth, 49*screenWidth/320);
    
    [_myTabbar createMyTabbarWithTabbarPlist:[NSString stringWithFormat:@"%@/MyTabBar.plist",[[NSBundle mainBundle] resourcePath]] andClass:self andSEL:@selector(tabClick:)];
    [self.view addSubview:_myTabbar];
    _myTabbar.tag=2016;
    [_myTabbar selectWithIndex:0];
    
    // Do any additional setup after loading the view.
}
-(void)tabClick:(UIButton*)btn
{
   self.selectedIndex = btn.tag;
    [_myTabbar selectWithIndex:btn.tag];
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
