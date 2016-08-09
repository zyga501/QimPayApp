//
//  AppDelegate.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FirstViewController.h"
#import "User.h"
#import "Header.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "PostAsynClass.h"

#import "APService.h"
@interface AppDelegate ()
{
    NSString *_URL;
    NSString *userid;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置引导页;设置根控制器
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:@"firstLaunch"];
    }
    //如果是第一次使用APP,直接进入引导页
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        
        //初始化引导页,设置成主页面
        FirstViewController * firstVC =[[FirstViewController alloc]init];
        self.window.rootViewController = firstVC;
        
    }else
    {
        //如果不是第一次使用APP,直接进入登陆页面
        //开机画面停留时间
        [NSThread sleepForTimeInterval:1.0];
        [_window makeKeyAndVisible];
        
        LoginViewController *log=[[LoginViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:log];
        self.window.rootViewController=nav;
        
    }
//9e87699f2e29  a4142752b894
    [ShareSDK registerApp:@"b13e9817cf40"];
    
    
    [ShareSDK connectWeChatWithAppId:@"wx724bdfaa1a1fc4e0"   //微信APPID
                           appSecret:@"b3743c80a9393282bf4c0e74f19fb2d4"  //微信APPSecret
                           wechatCls:[WXApi class]];
  [ShareSDK connectQQWithAppId:@"1104968507" qqApiCls:[QQApiInterface class]];
    [ShareSDK connectQQWithQZoneAppKey:@"94SNgd6xtLdoEfFL" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectSMS];
    
    User *user=[User currentUser];
    //版本更新代码
    NSMutableURLRequest *rever =[PostAsynClass postAsynWithURL:url1 andInterface:url25 andKeyArr:@[@"agentId",@"appType"]andValueArr:@[can,@"ios"]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    _URL=[dic objectForKey:@"appUrl"];
    user.banBen=[dic objectForKey:@"versionId"];
    user.URL=_URL;
    NSLog(@"6767676767676%@",dic);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"listFileName" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@%@",plistPath,dictionary);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Info.plist"];
    //    NSMutableDictionary *plistData = [[NSMutableDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSLog(@"%@",plistDic);
    user.BenDiBanBen=[plistDic objectForKey:@"CFBundleShortVersionString"];

    //    CFBundleShortVersionString
    //
    //    versionId
//    if ([[dic objectForKey:@"versionId"]isEqualToString:[plistDic objectForKey:@"CFBundleShortVersionString"]]) {
//        NSLog(@"当前为最新版本");
//    }
//    else
//    {
//        NSLog(@"需要更新");
//        
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"存在最新的版本程序，确认是否更新" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新版本", nil];
//        [alertView show];
//        alertView.tag=2;
//        
//    }
//
    //推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    //获取推送的内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //收到消息
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //连接成功
    [defaultCenter addObserver:self selector:@selector(successconnect:) name:kJPFNetworkDidSetupNotification object:nil];
    //关闭连接
    [defaultCenter addObserver:self selector:@selector(closeconnect:) name:kJPFNetworkDidCloseNotification object:nil];
    //成功注册
    [defaultCenter addObserver:self selector:@selector(successregister:) name:kJPFNetworkDidRegisterNotification object:nil];
    //成功登陆
    [defaultCenter addObserver:self selector:@selector(successlogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification != nil)
    {
        self.isLaunchedByNotification = YES;
    }

    // Override point for customization after application launch.
    return YES;
}
- (BOOL)shouldAutorotate

{
    return NO;
}
#pragma mark   推送调用
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
    //User *user=[User currentUser];
    //NSLog(@"是否输出当前的用户id%@",_IDstring);
    
    //[APService setAlias:_IDstring callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    NSLog(@"输出token为%@",deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    
    [APService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#pragma mark  单个推送  f9c5dba3f5bb2f98601345f3
+ (void)setAlias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget
{
    User *user=[User currentUser];
    alias=user.merid;
    NSLog(@"shifou成功");
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark   获取推送内容调用
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSLog(@"推送内容为%@,%@",userInfo,content);
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
-(void)successconnect:(NSNotification *)notification
{
    NSLog(@"成功连接");
}
-(void)closeconnect:(NSNotification *)notification
{
    NSLog(@"关闭连接");
}
-(void)successregister:(NSNotification *)notification
{
    NSLog(@"注册成功");
}
-(void)successlogin:(NSNotification *)notification
{
    NSLog(@"成功登陆");
    User *user=[User currentUser];
    NSLog(@"shucu %@",user.merid);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setAlias" object:nil];
    //[APService setAlias:@"111" callbackSelector:@selector(networkDidReceiveMessage:) object:self];
    //[APService setAlias:@"111" callbackSelector:<#(SEL)#> object:self];
    
}

//版本更新弹出按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
        
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_URL]];
        
    }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"networkDidReceiveMessage:" object:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //角标消除
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"进入应用");
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
