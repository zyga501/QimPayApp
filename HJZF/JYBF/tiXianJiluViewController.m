//
//  tiXianJiluViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/22.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "tiXianJiluViewController.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "nextTiXianViewController.h"
#import "tiXianTableViewCell.h"
#import "TXXQViewController.h"
@interface tiXianJiluViewController ()
{
    
    NSString *_locationString;
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    UITableView *_table;
    NSMutableArray *_dataArr;
    int _pageNum;
    
    NSArray *_data;
    
    NSDictionary *dicc;
    
    
    
}
@end

@implementation tiXianJiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNum=1;
    [self LoadData];
    [self makeNav];
    [self makeUI];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];

    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"提现记录" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeUI
{
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
   
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
     _table.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_table];
    
    //实例化header和footer
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    //设置header和footer的滚动视图为table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //设置header和footer的代理
    _header.delegate = self;
    _footer.delegate = self;
    
}

-(void)LoadData
{
    
    
    User *user=[User currentUser];

    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-90*24*60*60];
    _formatter=[[NSDateFormatter alloc]init];
    _formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [_formatter setTimeZone:nowZone];
    _timeStr=[_formatter stringFromDate:date];
    NSLog(@"========================%@",_timeStr);
    
    
    
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];
    NSLog(@"------------------------%@",_timeStr1);
    

    NSMutableURLRequest *rever =[PostAsynClass postAsynWithURL:url1 andInterface:url20 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize",@"cardType"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12",@"J"]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    NSData *ata = [NSData alloc];
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    _data=[dic objectForKey:@"ordersInfo"];
    for(dicc in _data)
    {
        
        [_dataArr addObject:dicc];
        
    }
    NSLog(@"-----==============------%@",dic);
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有提现交易" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        return;
    }
    
    [_table reloadData];    
}
//每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40*screenWidth/320.0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str=@"iden";
    
    tiXianTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil) {
        cell=[[tiXianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
   
    NSString *str2 =_dataArr[indexPath.row][@"openAcctId"];
    
    NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
    
    [str1 appendFormat:@"%@",str2];
    
    NSInteger i = str1.length;
    if(i>10)
    {
       [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
    }
    cell.openAcctId.text=str1;
    
    NSLog(@"%@",str1);


    //cell.createDate.text=_dataArr[indexPath.row][@"createDate"];
    
    //把20130303变成2013-03-03
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"createDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"createDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"createDate"] substringWithRange:range3]];
    //cell.createDate.text=string1;
    NSLog(@"%@",string1);

    //cell.createTime.text=_dataArr[indexPath.row][@"createTime"];
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran3]];
    NSString *timeString=[NSString stringWithFormat:@"%@ %@",string1,string2];
    cell.createDate.text=timeString;
   // cell.createTime.text=string2;

    
    cell.transAmt.text=_dataArr[indexPath.row][@"transAmt"];
    cell.transStat.text=_dataArr[indexPath.row][@"transStat"];
    
    return cell;
    
    
}

#pragma mark MJ的代理
//开始的代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //在这里开始网络请求
    if(refreshView == _header)
    {
        _pageNum=1;
        [_dataArr removeAllObjects];
        [self LoadData];
    }
    else
    {
        _pageNum+=1;
        [self LoadData];
        
    }
    [refreshView endRefreshing];//结束刷新，归位
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     TXXQViewController *next=[[TXXQViewController alloc] init];
    
    next.ddic=_dataArr[indexPath.row];
    
    [self.navigationController pushViewController:next animated:YES];
    
}
- (void)dealloc
{
    [_header free];
    [_footer free];
}
#pragma mark  从头开始
-(void)viewDidLayoutSubviews {
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_table respondsToSelector:@selector(setLayoutMargins:)])  {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
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
