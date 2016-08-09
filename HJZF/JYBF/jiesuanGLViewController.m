//
//  jiesuanGLViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/27.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "jiesuanGLViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "addCardTableViewCell.h"
#import "addCardViewController.h"
#import "PostAsynClass.h"
@interface jiesuanGLViewController ()
{
    UITableView *_tableV;
    NSArray *_data;
    NSMutableArray *_dataArr;
    NSMutableArray *numArr;
    UIAlertView *_alertv;
    NSString *alertNum;
    NSDictionary *dict;
    
}
@end

@implementation jiesuanGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    numArr=[[NSMutableArray alloc] init];
     [self loadData];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"结算管理" andClass:self andSEL:@selector(bacClick:)];
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
    User *user=[User currentUser];
    NSLog(@"输出为%@",user.sm);
    
    _tableV= [[UITableView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableV];
    //可选属性，把两行之间的分隔线隐藏
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;

}
-(void)loadData
{
    User *user=[User currentUser];
    //结算卡查询接口
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shanghujiesuankachaxun%@",dic);
    _data=[dic objectForKey:@"ordersInfo"];
    
    [_dataArr removeAllObjects];
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    if (![[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        [self toastResult:sre];
    }
    for(NSDictionary *dicc in _data)
    {
        [_dataArr addObject:dicc];
    }
    [_tableV reloadData];
    
}
//1、设置table的每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return _dataArr.count;
    }
    else
    {
        return 0;
    }
}
//4、设置图片段头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame=CGRectMake(0,0,320, 50*screenWidth/320);
    [but setImage:[UIImage imageNamed:@"ios320x568_21.png"] forState:UIControlStateNormal];
    
    [but addTarget:self action:@selector(cardbtn:) forControlEvents:UIControlEventTouchUpInside];
    [_tableV addSubview:but];
    
    return but;
}
-(void)cardbtn:(UIButton*)btn
{
    
    addCardViewController *add=[[addCardViewController alloc] init];
    
    [self.navigationController  pushViewController:add animated:YES];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//5、设置段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
        return 100;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*screenWidth/320.0;
}
//2、设置每一行上面显示什么内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str = @"iden";
    
    //给table注册一个cell名称标识
    addCardTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    //判断cell有没有,在池子里找
    if(!cell)
    {//没找到进来
        //实例化一个cell
        cell = [[addCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] ;
    }
    //设置cell不允许被点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //  cell.openAcctId.text= [NSString stringWithFormat:@"%@%@",_dataArr[indexPath.row][@"openAcctId"],_dataArr[indexPath.row][@"openAcctName"]];
    
    
    //    cell.openAcctId.text=_dataArr[indexPath.row][@"openAcctId"];
    //
    //    cell.openAcctName.text=_dataArr[indexPath.row][@"openAcctName"];
    
//    User *user=[User currentUser];
//    user.moRenNun=_dataArr[indexPath.row][@"liqCardId"];
////    [numArr addObject:_dataArr[indexPath.row][@"liqCardId"]] ;
//    [numArr addObject:user.moRenNun];
    //NSLog(@"---------------1111111111111111-------%@",user.moRenNun);
    //默认按钮
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(230, 60,70, 30);
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(onClick3:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = [indexPath row];
    [cell addSubview:btn3];
    
    //删除按钮
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(250, 10,50, 50);
    
    
    [btn4 setImage:[UIImage imageNamed:@"ios750x1334_25.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = [indexPath row];
    [cell addSubview:btn4];
    
    cell.isDefault.text=_dataArr[indexPath.row][@"isDefault"];
    
    if ([_dataArr[indexPath.row][@"isDefault"]isEqualToString:@"Y"]) {
        cell.isDefault.text=@"默认";
        
        [btn3 setUserInteractionEnabled:NO];
        //  [btn4 setUserInteractionEnabled:NO];
        [btn4 removeFromSuperview];
        
    }
    if ([_dataArr[indexPath.row][@"isDefault"]isEqualToString:@"N"])
    {
        cell.isDefault.text=@"设为默认";
    }
    
    
    
    //设置银行卡图片
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"ccb"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_06.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"icbc"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_08.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"abc"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_03.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"bankcomm"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_10.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"cmb"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_12.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"ecitic"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_14.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"cebbank"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_18.png"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"bankofbj"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"ios320x568_16.png"];
    }
    NSString *str2 =_dataArr[indexPath.row][@"openAcctId"];
    
    NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
    
    [str1 appendFormat:@"%@",str2];
    
    NSInteger i = str1.length;
    if(i>10)
    {
        [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
 
    } 
    cell.openAcctId.text=[NSString stringWithFormat:@"%@%@",str1,_dataArr[indexPath.row][@"openAcctName"]];
    
    // user.jiekahao=cell.openAcctId.text;
    return cell;
}
-(void)onClick3:(UIButton*)btn
{
    User *user=[User currentUser];
    user.moRenNun=_dataArr[btn.tag][@"liqCardId"];
    _alertv= [[UIAlertView alloc]initWithTitle:@"更改默认" message:@"您确定将该卡设为默认吗！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    alertNum=@"1";
    [_alertv show];
    _alertv.tag=2;
    
    
}
-(void)deleteClick:(UIButton*)btn
{
    User *user=[User currentUser];
    user.moRenNun=_dataArr[btn.tag][@"liqCardId"];
    NSLog(@"输出结算卡编号为%@",user.moRenNun);
    
    UIAlertView *aler= [[UIAlertView alloc]initWithTitle:@"删除" message:@"您确认删除该银行卡吗！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    [aler show];
    alertNum=@"2";
    aler.tag=2;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if( [alertNum isEqual:@"1"] )
    {
        if (!buttonIndex) {
            
            
        } else {
            
            User *user=[User currentUser];
            //结算卡查询接口
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url26 andKeyArr:@[@"merId",@"liqCardId"]andValueArr:@[user.merid,user.moRenNun]];
            //
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            dict = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"moren%@",dict);
            NSString *sre = [dict objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            if (![[dict objectForKey:@"respCode"]isEqualToString:@"000"]) {
                [self toastResult:sre];
            }
            if ([[dict objectForKey:@"respCode"] isEqualToString:@"000"])
            {
                
                [self loadData];
            }
        }
    }
    else if ([alertNum isEqual:@"2"])
    {
        
        if (!buttonIndex) {
            
            
        } else {
            
            User *user=[User currentUser];
            //结算卡查询接口
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url30 andKeyArr:@[@"merId",@"liqCardId"]andValueArr:@[user.merid,user.moRenNun]];
            
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"shanchu%@",dic);
            NSString *sre = [dic objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            if (![[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
                [self toastResult:sre];
            }
            if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
            {
                
                [self loadData];
            }
            
        }
      
    }
    
    
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

-(void)delLoadData
{
    
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
