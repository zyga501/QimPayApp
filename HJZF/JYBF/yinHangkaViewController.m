//
//  yinHangkaViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/28.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "yinHangkaViewController.h"
#import "PostAsynClass.h"
#import "Header.h"
#import "User.h"
#import "yinHangKaTableViewCell.h"
#import "MyNavigationBar.h"
@interface yinHangkaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_table;
    NSMutableArray *_dataArr;
    NSArray *_data;
}
@end

@implementation yinHangkaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self loadData];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"选择提现卡号" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_table];

}
-(void)loadData
{
    User *user=[User currentUser];
    //结算卡查询接口
    
    NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId",@"cardType"]andValueArr:@[user.merid,@"J"]];
    //
    NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
    
    NSData *ata3 = [NSData alloc];
    
    ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shanghujiesuankachaxun%@",dic3);
    _data=[dic3 objectForKey:@"ordersInfo"];
    for(NSDictionary *dicc in _data)
    {
//        user.jiekahao=[dicc objectForKey:@"openAcctId"];
//        user.kaname=[dicc objectForKey:@"openBankName"];
//        user.kaBian=[dicc objectForKey:@"liqCardId"];
        [_dataArr addObject:dicc];
    }
    [_table reloadData];
    
}
//1、设置table的每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*screenWidth/320.0;
}

//2、设置每一行上面显示什么内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str = @"iden";
    
    //给table注册一个cell名称标识
    yinHangKaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    //判断cell有没有,在池子里找
    if(!cell)
    {//没找到进来
        //实例化一个cell
        cell = [[yinHangKaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] ;
    }
    
    
    cell.openBankName.text=_dataArr[indexPath.row][@"openBankName"];
   // user.kaname=cell.openBankName.text;
    cell.openAcctId.text=_dataArr[indexPath.row][@"openAcctId"];
            NSString *str2 =cell.openAcctId.text;
    
            NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
    
            [str1 appendFormat:@"%@",str2];
    
            NSInteger i = str1.length;
    
    if(i>10)
    {
        [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
    }
        cell.openAcctId.text=str1;
    

   // user.jiekahao=cell.openAcctId.text;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    User *user = [User currentUser];
    
    user.jiekahao = _dataArr[indexPath.row][@"openAcctId"];
    
    user.kaname = _dataArr[indexPath.row][@"openBankName"];
    
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
